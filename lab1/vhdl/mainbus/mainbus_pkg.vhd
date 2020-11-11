library ieee;
use ieee.std_logic_1164.all;
use work.serial_port_pkg.all;
use work.reg_pkg.all;
use work.serial_mainbus_pkg.all;
use work.mainbus_coupling_pkg.all;

package mainbus_pkg is
  component mainbus is
    generic
    (
      CLK_FREQ : integer;
      BAUD_RATE : integer;
      MIN_STEP : std_logic_vector(31 downto 0);
      CONTR_FREQ : std_logic_vector(31 downto 0);
      MIN_DUTY : std_logic_vector(31 downto 0);
      MAX_DUTY : std_logic_vector(31 downto 0);
      MAX_STEP : std_logic_vector(31 downto 0);
      SYNC_STAGES : integer;
      VERSION : string;
      UUT_FREQ : std_logic_vector(31 downto 0);
      STEP_SIZE_D : std_logic_vector(63 downto 0);
      STEP_SIZE_N : std_logic_vector(31 downto 0);
      BOARD : string
    );
    port
    (
      clk : in std_logic;
      res_n : in std_logic;
      mtbf_stack : in std_logic_vector(47 downto 0);
      ps_value_det : in std_logic_vector(31 downto 0);
      mtbf_stack_overflowed : in std_logic_vector(4 downto 0);
      ps_in_progress_det : in std_logic;
      busy : in std_logic;
      rx : in std_logic;
      heart_beat_changed : in std_logic;
      cal : out std_logic;
      ps_inc_det : out std_logic;
      opcode : out std_logic_vector(31 downto 0);
      mtbf_stack_busy : in std_logic;
      tx : out std_logic;
      mtbf_stack_empty : in std_logic_vector(4 downto 0);
      ps_dec_pulse : out std_logic;
      ps_dec_det : out std_logic;
      cnt_en_ext : out std_logic;
      heart_beat_clear : out std_logic;
      ps_value_pulse : in std_logic_vector(31 downto 0);
      ps_inc_pulse : out std_logic;
      res_cnt : out std_logic_vector(63 downto 0);
      mtbf_stack_rd : out std_logic;
      mtbf_stack_addr : out std_logic_vector(2 downto 0);
      mes_cnt : out std_logic_vector(63 downto 0);
      ps_in_progress_pulse : in std_logic;
      res_n_ext : out std_logic;
      cnt : in std_logic_vector(47 downto 0)
    );
  end component mainbus;
end package mainbus_pkg;

