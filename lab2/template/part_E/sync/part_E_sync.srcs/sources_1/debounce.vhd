LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity debounce is
  generic (
        CLK_FREQ : NATURAL;
        THRESHOLD_US : NATURAL := 50
    );
    port(
        clk     : in std_logic;
        rst_n   : in std_logic;
        asyn    : in std_logic;
        result  : out std_logic
    );
end entity;

architecture beh of debounce is
    constant CNT_MAX : NATURAL := CLK_FREQ / (1000000 / THRESHOLD_US);
    signal counter : natural range 0 to CNT_MAX;
    signal ff1 : std_logic;
    signal ff2 : std_logic;
    signal debounced : std_logic;
begin
    result <= debounced;

    debounce : process(clk, rst_n)
    begin
        if rst_n = '0' then
            debounced <= '0';
            counter <= 0;
            ff1 <= '0';
            ff2 <= '0';
        elsif rising_edge(clk) then
            if (ff1 xor ff2) = '1' then
                counter <= 0;
            elsif counter = CNT_MAX then
                debounced <= ff1;
            else
                counter <= counter + 1;
            end if;

            ff1 <= asyn;
            ff2 <= ff1;
        end if;
    end process;

end architecture beh;