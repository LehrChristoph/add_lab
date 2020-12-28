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
    
begin
	c_elem_proc : process(in1, in2)
		variable prev_out : std_logic := '0';
	begin
		if (in1 = in2 ) then
			prev_out := in1;
		end if;
		out1 <= prev_out after C_ELEMENT_2_DELAY;
	end process c_elem_proc;
	
end architecture;