----------------------------------------------------------------------------------
--LCM Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity LCM_top_tb is

end LCM_top_tb;

architecture STRUCTURE of LCM_top_tb is
constant DATA_WIDTH_IF : natural := 32;

signal clk : std_logic;
signal rst: std_logic;
signal start_switch : std_logic;

begin

  clock_proc : process
  begin

    clk <= '0';
    wait for 4 ns;
    clk <= '1';
    wait for 4 ns;

  end process;

  reset_proc : process
  begin
    start_switch <= '0';
    rst <= '1';
    wait for 20 ns;
    wait until rising_edge(clk);
    rst <= '0';
    wait for 5 ms;
    start_switch <= '1';
    wait for 5 ms;

    wait for 10 ms;
    rst <= '1';
    start_switch <= '0';
    wait for 5 ms;
    rst <= '0';
    wait for 5 ms;
    start_switch <= '1';
    wait;
  end process;

LCM_module: entity work.top
     port map (
       clk => clk,
       res => rst,
       rx => '0',
       error_led => open,
       heartbeat_led => open,
       start_switch => start_switch,
       tx => open
    );

end STRUCTURE;
