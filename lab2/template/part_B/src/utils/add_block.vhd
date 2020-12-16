----------------------------------------------------------------------------------
-- Add-block
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity add_block is
  generic ( 
    DATA_WIDTH: natural := 16);
  port (-- Input channel
    inA_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
    inB_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
    -- Output channel
    outC_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end add_block;

architecture Behavioral of add_block is
signal connect: std_logic := '0'; -- signal for constraining i/o (needed only for post-timing simulation)

attribute dont_touch : string;
attribute dont_touch of  connect : signal is "true";   
begin

	outC_data <= inA_data + inB_data;

end Behavioral;