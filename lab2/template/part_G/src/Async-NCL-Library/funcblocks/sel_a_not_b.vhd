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
	signal selector_complete : std_logic;
	signal a_t, a_f, b_t, b_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal a_t_xor_b_t, a_f_xor_b_f, a_t_xor_b_f, a_f_xor_b_t, a_not_b_t, a_not_b_f :std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	
	signal stage_complete : std_logic_vector(DATA_WIDTH/2 -1 downto 1);
	signal completion_vector : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal computation_complete : std_logic;
	
begin

	a_t <= in_data_t(DATA_WIDTH - 1 downto DATA_WIDTH/2);
	b_t <= in_data_t(DATA_WIDTH/2 -1 downto 0);

	a_f <= in_data_f(DATA_WIDTH - 1 downto DATA_WIDTH/2);
	b_f <= in_data_f(DATA_WIDTH/2 -1 downto 0);
		
	a_t_xor_b_t(0) <= a_t(0) xor b_t(0) after XOR_DELAY;
	a_f_xor_b_f(0) <= a_f(0) xor b_f(0) after XOR_DELAY;
	
	a_t_xor_b_f(0) <= a_t(0) xor b_f(0) after XOR_DELAY;
	a_f_xor_b_t(0) <= a_f(0) xor b_t(0) after XOR_DELAY;
	
	a_not_b_t(0) <= a_t_xor_b_t(0) and a_f_xor_b_f(0) after AND2_DELAY;
	a_not_b_f(0) <= a_t_xor_b_f(0) and a_f_xor_b_t(0) after AND2_DELAY;
	
	completion_vector(0) <= a_not_b_t(0) or a_not_b_f(0) after OR2_DELAY;
	
	
	GEN_A_NOT_B : for i in 1 to DATA_WIDTH/2 -1 generate
		a_t_xor_b_t(i) <= a_t(i) xor b_t(i) after XOR_DELAY;
		a_f_xor_b_f(i) <= a_f(i) xor b_f(i) after XOR_DELAY;
		
		a_t_xor_b_f(i) <= a_t(i) xor b_f(i) after XOR_DELAY;
		a_f_xor_b_t(i) <= a_f(i) xor b_t(i) after XOR_DELAY;
				
		a_not_b_t(i) <= (a_t_xor_b_t(i) and a_f_xor_b_f(i))  or a_not_b_t(i-1) after AND2_DELAY+OR2_DELAY;
		a_not_b_f(i) <=  a_t_xor_b_f(i) and a_f_xor_b_t(i)  and a_not_b_f(i-1) after AND3_DELAY;
		
		stage_complete(i) <= a_not_b_t(i) or a_not_b_f(i) after OR2_DELAY;
		
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
		out1 => selector_t
	);
	
	c_element_inst_selector_f : entity work.c_element
	port map
	(
		in1 => a_not_b_f(a_not_b_f'length -1),
		in2 => completion_vector(completion_vector'length -1),
		out1 => selector_f
	);
		
	c_element_inst_ack : entity work.c_element
	port map
	(
		in1 => completion_vector(completion_vector'length -1),
		in2 => ack_in,
		out1 => ack_out
	);
	
--	selector_t <= a_not_b_t(a_not_b_t'length -1);
--	selector_f <= a_not_b_f(a_not_b_f'length -1);
--	
--	selector_complete <= selector_t or selector_f after OR2_DELAY;

end Behavioral;