----------------------------------------------------------------------------------
-- Register Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity reg is
	generic (
		DATA_WIDTH : natural := 16
	);
   port
   (
		clk   :  in std_logic;
		reset :  in std_logic;
      d		:  in std_logic_vector(DATA_WIDTH-1 downto 0);
      q		: out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end reg;

architecture STRUCTURE of reg is
begin

   process (clk, reset)                      
   begin
       if reset = '1' then            
          q <= (others => '0');
       elsif rising_edge(clk) then
          q <= d;
       end if;
   end process;
   
   
end STRUCTURE;