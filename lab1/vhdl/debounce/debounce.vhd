library ieee;
use ieee.std_logic_1164.all;
use work.sync_pkg.all;
use work.debounce_pkg.all;
use work.math_pkg.all;

entity debounce is
  generic
  (
    CLK_FREQ    : integer;
    TIMEOUT_US  : integer range 100 to 100000 := 1000;
    RESET_VALUE : std_logic := '0';
    SYNC_STAGES : integer range 2 to integer'high
  );
  port
  (
    clk      : in  std_logic;
    res_n    : in  std_logic;

    data_in      : in  std_logic;
    data_out     : out std_logic
  );
end entity debounce;

architecture struct of debounce is
  signal data_sync : std_logic;
begin
  sync_inst : sync
    generic map
    (
      SYNC_STAGES => SYNC_STAGES,
      RESET_VALUE => RESET_VALUE
    )
    port map
    (
      clk   => clk,
      res_n => res_n,
      data_in   => data_in,
      data_out  => data_sync
    );

  fsm_inst : debounce_fsm
    generic map
    (
      CLK_FREQ    => CLK_FREQ,
      TIMEOUT_US  => TIMEOUT_US,
      RESET_VALUE => RESET_VALUE
    )
    port map
    (
      clk          => clk,
      res_n        => res_n,
      i            => data_sync,
      o            => data_out
    );    
end architecture struct;
