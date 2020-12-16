----------------------------------------------------------------------------------
-- (A > B)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity sel_a_larger_b is
  generic(
    DATA_WIDTH    : natural := 16
  );
  port(
    -- Data
    in_data       : in  std_logic_vector(DATA_WIDTH -1 downto 0);
    -- Selector
    selector      : out std_logic
      );
end sel_a_larger_b;

architecture STRUCTURE of sel_a_larger_b is
    
    signal a : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
    signal b : std_logic_vector(DATA_WIDTH/2 -1 downto 0);    
begin

	a <= in_data(DATA_WIDTH - 1 downto DATA_WIDTH/2);
	b <= in_data(DATA_WIDTH/2 -1 downto 0);

	selector <= '1' when a > b else '0';
    
end STRUCTURE;