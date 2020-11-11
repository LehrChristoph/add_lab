library ieee;
use ieee.std_logic_1164.all;

package serial_mainbus_pkg is
  component serial_mainbus is
    generic
    (
      CLK_FREQ : integer
    );
    port
    (
      clk, res_n       : in    std_logic;
  
      serial_data_out : out   std_logic_vector(7 downto 0);
      serial_data_in  : in    std_logic_vector(7 downto 0);
      serial_new_data : in    std_logic;
      serial_free     : in    std_logic;
      serial_wr       : out   std_logic;

      bus_data_out    : out   std_logic_vector(31 downto 0);
      bus_data_in     : in    std_logic_vector(31 downto 0);
      bus_address     : out   std_logic_vector(31 downto 0);
      bus_rd          : out   std_logic;
      bus_wr          : out   std_logic;
      bus_done        : in    std_logic
    );
  end component serial_mainbus;
end package serial_mainbus_pkg;
