----------------------------------------------------------------------------------
-- (A > B)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity sel_a_larger_b is
	generic(
		DATA_WIDTH    : natural := DATA_WIDTH
	);
	port(
		-- Flags
		rst				: in std_logic;
		ack_in			: in std_logic;
		ack_out			: out std_logic;
		-- Input channel
		in_data_t     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
		in_data_f     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
		-- Output channel
		selector_t    : out std_logic;
		selector_f    : out std_logic
	);
	end sel_a_larger_b;

architecture Behavioral of sel_a_larger_b is
	signal enable_c_elements : std_logic;
	signal in_selected_t, in_selected_f : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal in_buffered_t, in_buffered_f : std_logic_vector(DATA_WIDTH-1 downto 0);
		
	signal a_t, a_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal b_t, b_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	
	signal a_larger_b, a_smaller_equal_b, a_smaller_b : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal a_larger_b_current, a_smaller_equal_b_current, a_smaller_b_current : std_logic_vector(DATA_WIDTH/2 -2 downto 0);
	signal a_larger_b_forward, a_smaller_equal_b_forward, a_smaller_b_forward : std_logic_vector(DATA_WIDTH/2 -2 downto 0);
	
	signal stage_complete, stage_complete_current, stage_complete_forward, stage_complete_next : std_logic_vector(DATA_WIDTH/2 -2 downto 0);
	signal completion_vector : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	
	signal temp_t, temp_f, internal_ack : std_logic;
	
	attribute keep: boolean;
	attribute keep of in_selected_t, in_selected_f: signal is true;
	attribute keep of a_t, a_f, b_t, b_f: signal is true;
	attribute keep of stage_complete, completion_vector : signal is true;
	attribute keep of in_buffered_t, in_buffered_f: signal is true;
begin

	GEN_C_ELEMENT : for i in 0 to DATA_WIDTH-1 generate	
		c_element_inst_t : entity work.c_element
		port map
		(
			in1 => in_selected_t(i),
			in2 => not enable_c_elements,
			out1 => in_buffered_t(i)
		);
		
		c_element_inst_f : entity work.c_element
		port map
		(
			in1 => in_selected_f(i),
			in2 => not enable_c_elements,
			out1 => in_buffered_f(i)
		);
	end generate GEN_C_ELEMENT;
	
	a_t <= in_buffered_t(DATA_WIDTH - 1 downto DATA_WIDTH/2);
	b_t <= in_buffered_t(DATA_WIDTH/2 -1 downto 0);

	a_f <= in_buffered_f(DATA_WIDTH - 1 downto DATA_WIDTH/2);
	b_f <= in_buffered_f(DATA_WIDTH/2 -1 downto 0);
	
	a_larger_b(a_larger_b'length -1) <= a_t(a_t'length -1) and b_f(b_f'length -1) after AND2_DELAY;	
	a_smaller_equal_b(a_smaller_equal_b'length -1) <= a_f(a_f'length -1)  or b_t(b_t'length -1) after OR2_DELAY;
	a_smaller_b(a_smaller_b'length -1) <= a_f(a_f'length -1) and b_t(b_t'length -1) after AND2_DELAY;	
	
	completion_vector(a_smaller_b'length -1) <= a_larger_b(a_larger_b'length -1) xor a_smaller_equal_b(a_smaller_equal_b'length -1) after OR2_DELAY;
	
	GEN_a_larger_b : for i in a_larger_b'length -2 downto 0 generate
	
		a_larger_b_current(i) <= a_t(i) and b_f(i) after AND2_DELAY;	
		a_smaller_equal_b_current(i) <= a_f(i) or b_t(i) after AND2_DELAY;	
		a_smaller_b_current(i) <= a_f(i) and b_t(i) after AND2_DELAY;	
		
		a_larger_b_forward(i) <= a_larger_b_current(i) and not a_smaller_b(i+1) after AND2_DELAY+NOT1_DELAY;	
		a_smaller_equal_b_forward(i) <= a_smaller_equal_b_current(i) and a_smaller_equal_b(i+1) after AND2_DELAY;
		a_smaller_b_forward(i) <= a_smaller_b_current(i) and not a_larger_b(i+1) after AND2_DELAY+NOT1_DELAY;	
		
		a_larger_b(i) <= a_larger_b_forward(i) or a_larger_b(i+1) after OR2_DELAY;	
		a_smaller_equal_b(i) <= a_smaller_equal_b_forward(i) or a_smaller_b(i+1) after OR2_DELAY;
		a_smaller_b(i) <= a_smaller_b_forward(i) or a_smaller_b(i+1) after OR2_DELAY;
		
		stage_complete(i) <= a_larger_b(i) xor a_smaller_equal_b(i) after OR2_DELAY;
		c_element_stage_complete_forward : entity work.c_element
		port map
		(
			in1 => stage_complete(i),
			in2 => completion_vector(i+1),
			out1 => completion_vector(i)
		);
		
	end generate GEN_a_larger_b;
	
	c_element_inst_selector_t : entity work.c_element
	port map
	(
		in1 => a_larger_b(0),
		in2 => completion_vector(0),
		out1 => temp_t
	);
	
	c_element_inst_selector_f : entity work.c_element
	port map
	(
		in1 => a_smaller_equal_b(0),
		in2 => completion_vector(0),
		out1 => temp_f
	);
		
	c_element_inst_ack : entity work.c_element
	port map
	(
		in1 => completion_vector(0),
		in2 => ack_in,
		out1 => internal_ack
	);
	
	reset_function : process (temp_t, temp_f, rst, internal_ack, in_data_t, in_data_f)
	begin
		if rst = '1' then
			selector_t <= '0';
			selector_f <= '0';
		
			in_selected_t <= (others => '0');
			in_selected_f <= (others => '0');
			
			ack_out <= '0';
			enable_c_elements <= '1';
		else
			in_selected_t <= in_data_t;
			in_selected_f <= in_data_f;
			
			selector_t <= temp_t;
			selector_f <= temp_f;
			
			ack_out <= internal_ack;
			enable_c_elements <= internal_ack;

		end if;
	end process;
	
end Behavioral;