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

architecture STRUCTURE of c_element is
	signal set,reset, trigger : std_logic;
	signal init_output, temp_output : std_logic;
begin

	set <= '1' when ((in1 ='1') and (in2 = '1')) 	else '0';
	reset <= '1' when ((in1 ='0') and (in2 = '0')) 	else '0'; 
	init_output <= '1' when ( out1 /='1' and out1 /='0') 	else '0'; 

	c_elem_proc : process(set, reset, init_output, in1, in2)
		variable prev_out : std_logic := '0';
	begin
		if reset = '1' then 
			temp_output <= '0' after C_ELEMENT_2_DELAY;
		elsif init_output = '1' then
			if (in1 ='1') and (in2 = '1') then
				temp_output <= '1' after C_ELEMENT_2_DELAY;
			else 
				temp_output <= '0' after C_ELEMENT_2_DELAY;
			end if;
		elsif rising_edge(set) then
			temp_output <= '1';
		end if;

	end process c_elem_proc;
	
	out1 <= temp_output after C_ELEMENT_2_DELAY;

end architecture;
