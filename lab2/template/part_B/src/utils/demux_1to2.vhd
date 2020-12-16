----------------------------------------------------------------------------------
--DEMUX Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity demux_1to2 is
	generic (
		DATA_WIDTH : natural := 16
	);
   Port (
		sel 	: in  STD_LOGIC;
      inA   : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
      outB  : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
      outC	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);
end demux_1to2;

architecture STRUCTURE of demux_1to2 is
begin
	process (sel, inA)                      
	begin
		if sel = '1' 	then            
			outB <= (others => '0');
			outC <= inA;
		else
			outB <= inA;
			outC <= (others => '0');
		end if;
	end process;
	
end STRUCTURE;