----------------------------------------------------------------------------------
-- (A > B)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity sel_a_larger_b is
	generic(
		DATA_WIDTH    : natural := DATA_WIDTH
	);
	port(
		-- Input channel
		in_data_t     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
		in_data_f     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
		-- Output channel
		selector_t    : out std_logic;
		selector_f    : out std_logic
	);
	end sel_a_larger_b;

architecture Behavioral of sel_a_larger_b is
    
	signal a_t, a_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
	signal b_t, b_f : std_logic_vector(DATA_WIDTH/2 -1 downto 0);
    
begin

  a_t <= in_data_t(DATA_WIDTH - 1 downto DATA_WIDTH/2);
  b_t <= in_data_t(DATA_WIDTH/2 -1 downto 0);
  
  a_f <= in_data_f(DATA_WIDTH - 1 downto DATA_WIDTH/2);
  b_f <= in_data_f(DATA_WIDTH/2 -1 downto 0);
    
  selector_t <= '1' when a_t >  b_t else '0';
  selector_f <= '1' when a_f >= b_f else '0';
end Behavioral;