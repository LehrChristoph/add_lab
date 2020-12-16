----------------------------------------------------------------------------------
-- A != B selector
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sel_a_not_b is
  generic(
    DATA_WIDTH  : natural := 16
    );
  port(
    -- Input channel
    in_data     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
    -- Output channel
    selector    : out std_logic
    );
end sel_a_not_b;

architecture STRUCTURE of sel_a_not_b is
    
  signal a : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
  signal b : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
begin
  a <= in_data(DATA_WIDTH - 1 downto DATA_WIDTH/2);
  b <= in_data(DATA_WIDTH/2 -1 downto 0);
    
  selector <= '0' when a /= b else '1';

end STRUCTURE;