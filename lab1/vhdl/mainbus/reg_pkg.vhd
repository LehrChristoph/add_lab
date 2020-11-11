library ieee;
use ieee.std_logic_1164.all;

package reg_pkg is
  component reg_1rw_1c is
    generic
    (
      RESET_VALUE : std_logic := '0';
      WIDTH : integer
    );
    port
    (
      clk : in std_logic;
      res_n : in std_logic;
      q : out std_logic_vector(WIDTH - 1 downto 0);
      d : in std_logic_vector(WIDTH - 1 downto 0);
      en : in std_logic
    );
   end component reg_1rw_1c;
end package reg_pkg;