----------------------------------------------------------------------------------
-- Registerwith enable input and valid output Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity reg_ena_valid is
	generic (
		DATA_WIDTH : natural := 16
	);
   port
   (
		clk   :  in std_logic;
		reset :  in std_logic;
		ena	:	in std_logic;
      d		:  in std_logic_vector(DATA_WIDTH-1 downto 0);
		valid : out std_logic;
      q		: out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
end reg_ena_valid;

architecture STRUCTURE of reg_ena_valid is
begin

   process (clk, reset)                      
   begin
		if reset = '1' then            
			q <= (others => '0');
			valid <= '0';
		elsif rising_edge(clk) then
			if ena = '1' and valid = '0' then
				q <= d;
				valid <= '1';
			elsif valid = '1' then
				valid <= '0';
			end if;
		end if;
   end process;
   
   
end STRUCTURE;