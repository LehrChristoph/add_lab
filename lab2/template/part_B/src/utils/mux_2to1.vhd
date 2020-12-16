----------------------------------------------------------------------------------
--DMUX Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mux_2to1 is
	generic (
		DATA_WIDTH : natural := 16
	);
   Port (
		sel 	: in  STD_LOGIC;
      inA   : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
      inB   : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
      outC	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);
end mux_2to1;

architecture STRUCTURE of mux_2to1 is
begin
   
	process (sel, inA, inB)                      
	begin
		if sel = '1' 	then            
			outC <= inB;
		else
			outC <= inA;
		end if;
	end process;
	
end STRUCTURE;