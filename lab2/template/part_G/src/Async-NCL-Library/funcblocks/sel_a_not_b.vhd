----------------------------------------------------------------------------------
-- A != B selector
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.delay_element_pkg.all;
use work.defs.all;

entity sel_a_not_b is
  generic(
    DATA_WIDTH  : natural := DATA_WIDTH
    );
  port(
    -- Input channel
    in_data_t     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
    in_data_f     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
    -- Output channel
    selector_t    : out std_logic;
    selector_f    : out std_logic
    );
end sel_a_not_b;

architecture Behavioral of sel_a_not_b is
    
  signal a_t, a_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
  signal b_t, b_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
    
begin
  a_t <= in_data_t(DATA_WIDTH - 1 downto DATA_WIDTH/2);
  b_t <= in_data_t(DATA_WIDTH/2 -1 downto 0);
  
  a_f <= in_data_f(DATA_WIDTH - 1 downto DATA_WIDTH/2);
  b_f <= in_data_f(DATA_WIDTH/2 -1 downto 0);
    
  selector_t <= '0' when a_t /= b_t else '1';
  selector_f <= '0' when a_f == b_f else '1';

end Behavioral;