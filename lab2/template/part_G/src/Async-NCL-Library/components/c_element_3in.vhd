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
    
begin
	c_elem_proc : process(in1, in2, in3)
		variable prev_out : std_logic := '0';
	begin
		if (in1 = in2) and (in1 = in3) then
			prev_out := in1;
		end if;
		out1 <= prev_out  after C_ELEMENT_3_DELAY;
	end process c_elem_proc;
	
end architecture;