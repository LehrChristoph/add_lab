----------------------------------------------------------------------------------
-- A != B selector
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity sel_a_not_b is
	generic(
		DATA_WIDTH  : natural := DATA_WIDTH
	);
	port(
		-- Flags
		rst				: in std_logic;
		ack_in			: in std_logic;
		ack_out			: out std_logic;
		-- Input channel
		in_data_t     	: in  std_logic_vector(DATA_WIDTH -1 downto 0);
		in_data_f     	: in  std_logic_vector(DATA_WIDTH -1 downto 0);
		-- Output channel
		selector_t    	: out std_logic;
		selector_f    	: out std_logic
	);
	end sel_a_not_b;

architecture Behavioral of sel_a_not_b is
	signal enable_c_elements : std_logic;
	signal in_selected_t, in_selected_f : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal in_buffered_t, in_buffered_f : std_logic_vector(DATA_WIDTH-1 downto 0);
	
	signal selector_complete : std_logic;
	signal a_t, a_f, b_t, b_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal a_t_xor_b_t, a_f_xor_b_f, a_t_xor_b_f, a_f_xor_b_t, a_not_b_t, a_not_b_f :std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	
	signal temp_t, temp_f, internal_ack : std_logic;
	
	signal stage_complete : std_logic_vector(DATA_WIDTH/2 -1 downto 1);
	signal completion_vector : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	
	attribute keep: boolean;
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
		
	a_t_xor_b_t(0) <= a_t(0) xor b_t(0) after XOR_DELAY;
	a_f_xor_b_f(0) <= a_f(0) xor b_f(0) after XOR_DELAY;
	
	a_t_xor_b_f(0) <= a_t(0) xor b_f(0) after XOR_DELAY;
	a_f_xor_b_t(0) <= a_f(0) xor b_t(0) after XOR_DELAY;
	
	a_not_b_t(0) <= a_t_xor_b_t(0) and a_f_xor_b_f(0) after AND2_DELAY;
	a_not_b_f(0) <= a_t_xor_b_f(0) and a_f_xor_b_t(0) after AND2_DELAY;
	
	completion_vector(0) <= a_not_b_t(0) xor a_not_b_f(0) after OR2_DELAY;
	
	
	GEN_A_NOT_B : for i in 1 to DATA_WIDTH/2 -1 generate
		a_t_xor_b_t(i) <= a_t(i) xor b_t(i) after XOR_DELAY;
		a_f_xor_b_f(i) <= a_f(i) xor b_f(i) after XOR_DELAY;
		
		a_t_xor_b_f(i) <= a_t(i) xor b_f(i) after XOR_DELAY;
		a_f_xor_b_t(i) <= a_f(i) xor b_t(i) after XOR_DELAY;
				
		a_not_b_t(i) <= (a_t_xor_b_t(i) and a_f_xor_b_f(i))  or a_not_b_t(i-1) after AND2_DELAY+OR2_DELAY;
		a_not_b_f(i) <= (a_t_xor_b_f(i) and a_f_xor_b_t(i)) and a_not_b_f(i-1) after AND3_DELAY;
		
		stage_complete(i) <= a_not_b_t(i) xor a_not_b_f(i) after OR2_DELAY;
		
		c_element_stage_complete : entity work.c_element
		port map
		(
			in1 => stage_complete(i),
			in2 => completion_vector(i-1),
			out1 => completion_vector(i)
		);
		
	end generate GEN_A_NOT_B;
	
	c_element_inst_selector_t : entity work.c_element
	port map
	(
		in1 => a_not_b_t(a_not_b_t'length -1),
		in2 => completion_vector(completion_vector'length -1),
		out1 => temp_t
	);
	
	c_element_inst_selector_f : entity work.c_element
	port map
	(
		in1 => a_not_b_f(a_not_b_f'length -1),
		in2 => completion_vector(completion_vector'length -1),
		out1 => temp_f
	);
		
	c_element_inst_ack : entity work.c_element
	port map
	(
		in1 => completion_vector(completion_vector'length -1),
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