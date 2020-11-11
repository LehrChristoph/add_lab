library ieee;
use ieee.std_logic_1164.all;

package serial_port_pkg is
  
  component serial_port is
    generic
    (
      CLK_DIVISOR : integer;
      SYNC_STAGES : integer
    );
    port
    (
      clk, res_n : in  std_logic;
    
      data_in   : in  std_logic_vector(7 downto 0);
      wr        : in  std_logic;
      free      : out std_logic;
        
      data_out  : out std_logic_vector(7 downto 0);
      new_data  : out std_logic;
        
      rx        : in  std_logic;
      tx        : out std_logic
    );
  end component;
  
end serial_port_pkg;
