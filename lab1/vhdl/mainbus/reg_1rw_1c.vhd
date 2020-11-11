library ieee;
use ieee.std_logic_1164.all;

entity reg_1rw_1c is
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
end entity reg_1rw_1c;

architecture beh of reg_1rw_1c is
begin
  process(clk, res_n)
  begin
    if res_n = '0' then
      q <= (others => RESET_VALUE);
    elsif rising_edge(clk) then
      if en = '1' then
        q <= d;
      end if;
    end if;
  end process;
end architecture beh;
