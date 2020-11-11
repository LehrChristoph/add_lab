library ieee;
use ieee.std_logic_1164.all;

package testbench_util_pkg is
  procedure wait_cycle(signal clk : in std_logic; constant cycle_cnt : in integer);
  procedure serial_send_byte
  (
    signal   clk         : in std_logic;
    constant data        : in std_logic_vector(7 downto 0);
    signal   serial_data : out std_logic_vector(7 downto 0);
    signal   serial_wr   : out std_logic;
    signal   serial_free : in std_logic
  );
end testbench_util_pkg;

package body testbench_util_pkg is
  procedure wait_cycle(signal clk : in std_logic; constant cycle_cnt : in integer) is
  begin
    for i in 1 to cycle_cnt loop
      wait until rising_edge(clk);
    end loop;
  end wait_cycle;
  
  procedure serial_send_byte
  (
    signal   clk         : in std_logic;
    constant data        : in std_logic_vector(7 downto 0);
    signal   serial_data : out std_logic_vector(7 downto 0);
    signal   serial_wr   : out std_logic;
    signal   serial_free : in std_logic
  ) is
  begin
    serial_data <= data;
    serial_wr <= '1';
    wait_cycle(clk, 2);
    serial_wr <= '0';
    wait until serial_free = '1';
  end procedure serial_send_byte;

end package body testbench_util_pkg;
