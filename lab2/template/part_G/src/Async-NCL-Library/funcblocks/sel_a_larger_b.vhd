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

	signal a_t, a_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal b_t, b_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	
	signal a_larger_b, a_smaller_equal_b, a_smaller_b : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal a_larger_b_current, a_smaller_equal_b_current, a_smaller_b_current : std_logic_vector(DATA_WIDTH/2 -2 downto 0);
	signal a_larger_b_forward, a_smaller_equal_b_forward, a_smaller_b_forward : std_logic_vector(DATA_WIDTH/2 -2 downto 0);

	signal stage_complete : std_logic_vector(DATA_WIDTH/2 -2 downto 0);
	signal completion_vector : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal computation_complete : std_logic;
begin
	a_t <= in_data_t(DATA_WIDTH - 1 downto DATA_WIDTH/2);
	b_t <= in_data_t(DATA_WIDTH/2 -1 downto 0);

	a_f <= in_data_f(DATA_WIDTH - 1 downto DATA_WIDTH/2);
	b_f <= in_data_f(DATA_WIDTH/2 -1 downto 0);
	
	a_larger_b(a_larger_b'length -1) <= a_t(a_t'length -1) and b_f(b_f'length -1) after AND2_DELAY;	
	a_smaller_equal_b(a_smaller_equal_b'length -1) <= a_f(a_f'length -1)  or b_t(b_t'length -1) after OR2_DELAY;
	a_smaller_b(a_smaller_b'length -1) <= a_f(a_f'length -1) and b_t(b_t'length -1) after AND2_DELAY;	
	
	completion_vector(a_smaller_b'length -1) <= a_larger_b(a_larger_b'length -1) or a_smaller_equal_b(a_smaller_equal_b'length -1) after OR2_DELAY;
	
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
		
		stage_complete(i) <= a_larger_b(i) or a_smaller_equal_b(i) after OR2_DELAY;
	
		c_element_stage_complete : entity work.c_element
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
		out1 => selector_t
	);
	
	c_element_inst_selector_f : entity work.c_element
	port map
	(
		in1 => a_smaller_equal_b(0),
		in2 => completion_vector(0),
		out1 => selector_f
	);
		
	c_element_inst_ack : entity work.c_element
	port map
	(
		in1 => completion_vector(0),
		in2 => ack_in,
		out1 => ack_out
	);
	
end Behavioral;