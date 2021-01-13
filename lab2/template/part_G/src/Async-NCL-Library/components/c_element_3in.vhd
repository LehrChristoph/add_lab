----------------------------------------------------------------------------------
-- 3 input C-Element Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.defs.all;

entity c_element_3in is
	port(
		in1       : in  std_logic;
		in2       : in  std_logic;
		in3       : in  std_logic;
		out1      : out std_logic
	);
end c_element_3in;

architecture STRUCTURE of c_element_3in is
	signal set,reset, trigger : std_logic;
	signal init_output, temp_output : std_logic;  
begin
	
	set <= '1' when ((in1 ='1') and (in2 = '1') and (in3 = '1')) 	else '0';
	reset <= '1' when ((in1 ='0') and (in2 = '0') and (in3 = '0')) else '0'; 
	init_output <= '1' when ( out1 /='1' and out1 /='0' and set= '0') 	else '0'; 
	
	temp_output <=	'1' when set = '1'else
						'0' when reset = '1' else
						'0' when init_output = '1' else out1;
	out1 <= temp_output after C_ELEMENT_3_DELAY;
	
--	c_elem_proc : process(set, reset, init_output, in1, in2, in3)
--		variable prev_out : std_logic := '0';
--	begin
--		if reset = '1'  then 
--			temp_output <= '0';
--		elsif init_output = '1' then
--			if (in1 ='1') and (in2 = '1') and (in3 = '1') then
--				temp_output <= '1';
--			else 
--				temp_output <= '0';
--			end if;
--		elsif rising_edge(set) then
--			temp_output <= '1';
--		end if;
--
--	end process c_elem_proc;
--	
--	out1 <= temp_output after C_ELEMENT_3_DELAY;	
end architecture;


