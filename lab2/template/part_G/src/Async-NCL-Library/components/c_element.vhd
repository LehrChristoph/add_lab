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
end architecture;
