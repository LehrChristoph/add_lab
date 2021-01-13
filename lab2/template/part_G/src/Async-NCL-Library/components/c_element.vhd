----------------------------------------------------------------------------------
-- C-Element Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.defs.all;

entity c_element is
	port(
		in1       : in  std_logic;
		in2       : in  std_logic;
		out1      : out std_logic
	);
end c_element;

--architecture STRUCTURE of c_element is
--	signal set,reset, trigger : std_logic;
--	signal init_output, next_output : std_logic;
--begin
--
--	set <= '1' when ((in1 ='1') and (in2 = '1')) 	else '0';
--	reset <= '1' when ((in1 ='0') and (in2 = '0')) 	else '0'; 
--	init_output <= '1' when ( out1 /='1' and out1 /='0') 	else '0'; 
--
--	c_elem_proc : process(set, reset, init_output, in1, in2)
--		variable temp_out : std_logic := '0';
--	begin
--		if reset = '1' then 
--			next_output <= '0' after C_ELEMENT_2_DELAY;
--		elsif init_output = '1' then
--			if (in1 ='1') and (in2 = '1') then
--				next_output <= '1' after C_ELEMENT_2_DELAY;
--			else 
--				next_output <= '0' after C_ELEMENT_2_DELAY;
--			end if;
--		elsif rising_edge(set) then
--			next_output <= '1';
--		end if;
--
--	end process c_elem_proc;
--	
--	out1 <= next_output after C_ELEMENT_2_DELAY;
--
--end architecture;

architecture STRUCTURE of c_element is
	signal set, reset, trigger : std_logic;
	signal set_output, reset_output : std_logic;
	signal init_output, output : std_logic;
begin

	set <= '1' when ((in1 ='1') and (in2 = '1')) 	else '0';
	reset <= '1' when ((in1 ='0') and (in2 = '0')) 	else '0';
	init_output <= '1' when ( out1 /='1' and out1 /='0') 	else '0'; 
	
	output <='1' when set = '1'else
				'0' when reset = '1' else
				'0' when init_output = '1' else out1;
	out1 <= output after C_ELEMENT_2_DELAY;
--	reset_proc : process(reset_output, reset)
--		variable temp_out : std_logic := '0';
--	begin
--		if reset_output = '1' or init_output = '1' then 
--			reset_output <= '0';
--		elsif rising_edge(reset) then
--			reset_output <= '1';
--		end if;
--	end process reset_proc;
--	
--	set_proc : process(set_output, set)
--		variable temp_out : std_logic := '0';
--	begin
--		if set_output = '1' or init_output = '1'then 
--			set_output <= '0';
--		elsif rising_edge(set) then
--			set_output <= '1';
--		end if;
--	end process set_proc;
--	
--	trigger <= set_output or reset_output;
--	
--	set_output_proc : process(trigger, init_output)
--		variable temp_out : std_logic := '0';
--	begin
--		if init_output = '1' then 
--			output <= '0';
--		elsif rising_edge(trigger) then
--			if set = '1' then
--				output <= '1';
--			else
--				output <= '0';
--			end if;
--		end if;
--	end process set_output_proc;
--	
--	out1 <= output after C_ELEMENT_2_DELAY;

end architecture;
