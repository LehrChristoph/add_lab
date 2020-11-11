library ieee;
use ieee.std_logic_1164.all;
use work.serial_port_pkg.all;
use work.reg_pkg.all;
use work.serial_mainbus_pkg.all;
use work.mainbus_coupling_pkg.all;

entity mainbus is
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
end entity mainbus;

architecture mixed of mainbus is
  constant BASE_ADDRESS_MAX_STEP : std_logic_vector(31 downto 0) := x"00000103";
  constant BASE_ADDRESS_HEART_BEAT_CLEAR : std_logic_vector(31 downto 0) := x"00000116";
  constant BASE_ADDRESS_MES_CNT : std_logic_vector(31 downto 0) := x"00000112";
  constant BASE_ADDRESS_CNT_EN_EXT : std_logic_vector(31 downto 0) := x"0000010d";
  constant BASE_ADDRESS_PS_VALUE_PULSE : std_logic_vector(31 downto 0) := x"0000011a";
  constant BASE_ADDRESS_CAL : std_logic_vector(31 downto 0) := x"0000011f";
  constant BASE_ADDRESS_CONTR_FREQ : std_logic_vector(31 downto 0) := x"00000100";
  constant BASE_ADDRESS_MTBF_STACK : std_logic_vector(31 downto 0) := x"00000120";
  constant BASE_ADDRESS_PS_INC_PULSE : std_logic_vector(31 downto 0) := x"00000118";
  constant BASE_ADDRESS_PS_VALUE_DET : std_logic_vector(31 downto 0) := x"0000011e";
  constant BASE_ADDRESS_MTBF_STACK_OVERFLOWED : std_logic_vector(31 downto 0) := x"00000131";
  constant BASE_ADDRESS_OPCODE : std_logic_vector(31 downto 0) := x"0000010e";
  constant BASE_ADDRESS_BUSY : std_logic_vector(31 downto 0) := x"00000114";
  constant BASE_ADDRESS_STEP_SIZE_N : std_logic_vector(31 downto 0) := x"00000106";
  constant BASE_ADDRESS_PS_INC_DET : std_logic_vector(31 downto 0) := x"0000011c";
  constant BASE_ADDRESS_MAX_DUTY : std_logic_vector(31 downto 0) := x"00000105";
  constant BASE_ADDRESS_MTBF_STACK_EMPTY : std_logic_vector(31 downto 0) := x"00000130";
  constant BASE_ADDRESS_CNT : std_logic_vector(31 downto 0) := x"0000010a";
  constant BASE_ADDRESS_PS_IN_PROGRESS_DET : std_logic_vector(31 downto 0) := x"0000011b";
  constant BASE_ADDRESS_MIN_DUTY : std_logic_vector(31 downto 0) := x"00000104";
  constant BASE_ADDRESS_VERSION : std_logic_vector(31 downto 0) := x"00000080";
  constant BASE_ADDRESS_HEART_BEAT_CHANGED : std_logic_vector(31 downto 0) := x"00000115";
  constant BASE_ADDRESS_UUT_FREQ : std_logic_vector(31 downto 0) := x"00000101";
  constant BASE_ADDRESS_PS_IN_PROGRESS_PULSE : std_logic_vector(31 downto 0) := x"00000117";
  constant BASE_ADDRESS_PS_DEC_PULSE : std_logic_vector(31 downto 0) := x"00000119";
  constant BASE_ADDRESS_MIN_STEP : std_logic_vector(31 downto 0) := x"00000102";
  constant BASE_ADDRESS_STEP_SIZE_D : std_logic_vector(31 downto 0) := x"00000108";
  constant BASE_ADDRESS_PS_DEC_DET : std_logic_vector(31 downto 0) := x"0000011d";
  constant BASE_ADDRESS_RES_CNT : std_logic_vector(31 downto 0) := x"00000110";
  constant BASE_ADDRESS_BOARD : std_logic_vector(31 downto 0) := x"00000000";
  constant BASE_ADDRESS_RES_N_EXT : std_logic_vector(31 downto 0) := x"0000010c";
  signal bus_data_sm_min_duty : std_logic_vector(31 downto 0);
  signal bus_done_max_step : std_logic;
  signal bus_data_sm_cal : std_logic_vector(31 downto 0);
  signal bus_data_sm_contr_freq : std_logic_vector(31 downto 0);
  signal cal_reg_data_wr : std_logic_vector(0 downto 0);
  signal ps_inc_det_reg : std_logic_vector(0 downto 0);
  signal ps_dec_det_reg_wr : std_logic;
  signal bus_data_sm_max_step : std_logic_vector(31 downto 0);
  signal mes_cnt_reg_wr : std_logic;
  signal bus_data_sm_ps_inc_pulse : std_logic_vector(31 downto 0);
  signal ps_inc_pulse_reg_wr : std_logic;
  signal bus_data_sm_mes_cnt : std_logic_vector(31 downto 0);
  signal ps_dec_pulse_reg : std_logic_vector(0 downto 0);
  signal cal_reg : std_logic_vector(0 downto 0);
  signal bus_done_min_step : std_logic;
  signal bus_done_step_size_n : std_logic;
  signal bus_done_cal : std_logic;
  signal ps_dec_det_reg_data_wr : std_logic_vector(0 downto 0);
  signal bus_done_ps_in_progress_det : std_logic;
  signal ps_in_progress_det_vec : std_logic_vector(0 downto 0);
  signal bus_done_ps_dec_det : std_logic;
  signal bus_data_sm_heart_beat_clear : std_logic_vector(31 downto 0);
  signal bus_data_ms : std_logic_vector(31 downto 0);
  signal bus_done_ps_value_det : std_logic;
  signal heart_beat_clear_reg : std_logic_vector(0 downto 0);
  signal cnt_en_ext_reg : std_logic_vector(0 downto 0);
  signal serial_data_bus_port : std_logic_vector(7 downto 0);
  signal res_cnt_reg : std_logic_vector(63 downto 0);
  signal bus_done_step_size_d : std_logic;
  signal res_cnt_reg_data_wr : std_logic_vector(63 downto 0);
  signal ps_inc_det_reg_data_wr : std_logic_vector(0 downto 0);
  signal bus_data_sm_ps_dec_pulse : std_logic_vector(31 downto 0);
  signal bus_wr : std_logic;
  signal bus_data_sm_cnt : std_logic_vector(31 downto 0);
  signal bus_done_res_cnt : std_logic;
  signal bus_done_ps_inc_det : std_logic;
  signal bus_done_max_duty : std_logic;
  signal bus_data_sm_ps_inc_det : std_logic_vector(31 downto 0);
  signal res_cnt_reg_wr : std_logic;
  signal bus_done_ps_dec_pulse : std_logic;
  signal heart_beat_clear_reg_wr : std_logic;
  signal cal_reg_wr : std_logic;
  signal bus_done_min_duty : std_logic;
  signal bus_data_sm_res_n_ext : std_logic_vector(31 downto 0);
  signal cnt_en_ext_reg_wr : std_logic;
  signal bus_done_ps_value_pulse : std_logic;
  signal bus_rd : std_logic;
  signal bus_done_ps_in_progress_pulse : std_logic;
  signal opcode_reg_data_wr : std_logic_vector(31 downto 0);
  signal bus_done_board : std_logic;
  signal opcode_reg : std_logic_vector(31 downto 0);
  signal ps_in_progress_pulse_vec : std_logic_vector(0 downto 0);
  signal bus_data_sm_opcode : std_logic_vector(31 downto 0);
  signal ps_dec_pulse_reg_wr : std_logic;
  signal bus_done_ps_inc_pulse : std_logic;
  signal mes_cnt_reg : std_logic_vector(63 downto 0);
  signal bus_done : std_logic;
  signal bus_data_sm_ps_value_pulse : std_logic_vector(31 downto 0);
  signal opcode_reg_wr : std_logic;
  signal bus_data_sm_ps_in_progress_pulse : std_logic_vector(31 downto 0);
  signal bus_done_mtbf_stack_overflowed : std_logic;
  signal bus_data_sm_ps_value_det : std_logic_vector(31 downto 0);
  signal serial_wr : std_logic;
  signal serial_new_data : std_logic;
  signal bus_data_sm_version : std_logic_vector(31 downto 0);
  signal bus_done_uut_freq : std_logic;
  signal serial_data_port_bus : std_logic_vector(7 downto 0);
  signal bus_done_opcode : std_logic;
  signal bus_data_sm_min_step : std_logic_vector(31 downto 0);
  signal bus_data_sm_step_size_n : std_logic_vector(31 downto 0);
  signal bus_data_sm_mtbf_stack : std_logic_vector(31 downto 0);
  signal bus_done_cnt : std_logic;
  signal bus_done_heart_beat_changed : std_logic;
  signal bus_data_sm_step_size_d : std_logic_vector(31 downto 0);
  signal ps_inc_det_reg_wr : std_logic;
  signal mes_cnt_reg_data_wr : std_logic_vector(63 downto 0);
  signal bus_done_heart_beat_clear : std_logic;
  signal res_n_ext_reg : std_logic_vector(0 downto 0);
  signal ps_inc_pulse_reg : std_logic_vector(0 downto 0);
  signal bus_data_sm_ps_dec_det : std_logic_vector(31 downto 0);
  signal heart_beat_clear_reg_data_wr : std_logic_vector(0 downto 0);
  signal bus_data_sm_max_duty : std_logic_vector(31 downto 0);
  signal bus_done_busy : std_logic;
  signal bus_data_sm_uut_freq : std_logic_vector(31 downto 0);
  signal cnt_en_ext_reg_data_wr : std_logic_vector(0 downto 0);
  signal res_n_ext_reg_wr : std_logic;
  signal bus_data_sm : std_logic_vector(31 downto 0);
  signal bus_data_sm_board : std_logic_vector(31 downto 0);
  signal bus_done_mtbf_stack : std_logic;
  signal bus_done_contr_freq : std_logic;
  signal serial_free : std_logic;
  signal busy_vec : std_logic_vector(0 downto 0);
  signal bus_data_sm_cnt_en_ext : std_logic_vector(31 downto 0);
  signal bus_done_res_n_ext : std_logic;
  signal ps_dec_pulse_reg_data_wr : std_logic_vector(0 downto 0);
  signal bus_data_sm_mtbf_stack_overflowed : std_logic_vector(31 downto 0);
  signal bus_data_sm_busy : std_logic_vector(31 downto 0);
  signal heart_beat_changed_vec : std_logic_vector(0 downto 0);
  signal bus_done_cnt_en_ext : std_logic;
  signal bus_data_sm_res_cnt : std_logic_vector(31 downto 0);
  signal bus_data_sm_mtbf_stack_empty : std_logic_vector(31 downto 0);
  signal ps_dec_det_reg : std_logic_vector(0 downto 0);
  signal bus_done_mtbf_stack_empty : std_logic;
  signal bus_done_mes_cnt : std_logic;
  signal bus_address : std_logic_vector(31 downto 0);
  signal res_n_ext_reg_data_wr : std_logic_vector(0 downto 0);
  signal bus_data_sm_ps_in_progress_det : std_logic_vector(31 downto 0);
  signal bus_data_sm_heart_beat_changed : std_logic_vector(31 downto 0);
  signal ps_inc_pulse_reg_data_wr : std_logic_vector(0 downto 0);
  signal bus_done_version : std_logic;
begin
  board_coupling_inst : mainbus_coupling_string
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_BOARD,
      VALUE => BOARD
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_board,
      bus_rd => bus_rd,
      bus_done => bus_done_board
    );
  
  version_coupling_inst : mainbus_coupling_string
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_VERSION,
      VALUE => VERSION
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_version,
      bus_rd => bus_rd,
      bus_done => bus_done_version
    );
  
  contr_freq_coupling_inst : mainbus_coupling_constant
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_CONTR_FREQ,
      VALUE => CONTR_FREQ
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_contr_freq,
      bus_rd => bus_rd,
      bus_done => bus_done_contr_freq
    );
  
  uut_freq_coupling_inst : mainbus_coupling_constant
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_UUT_FREQ,
      VALUE => UUT_FREQ
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_uut_freq,
      bus_rd => bus_rd,
      bus_done => bus_done_uut_freq
    );
  
  min_step_coupling_inst : mainbus_coupling_constant
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_MIN_STEP,
      VALUE => MIN_STEP
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_min_step,
      bus_rd => bus_rd,
      bus_done => bus_done_min_step
    );
  
  max_step_coupling_inst : mainbus_coupling_constant
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_MAX_STEP,
      VALUE => MAX_STEP
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_max_step,
      bus_rd => bus_rd,
      bus_done => bus_done_max_step
    );
  
  min_duty_coupling_inst : mainbus_coupling_constant
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_MIN_DUTY,
      VALUE => MIN_DUTY
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_min_duty,
      bus_rd => bus_rd,
      bus_done => bus_done_min_duty
    );
  
  max_duty_coupling_inst : mainbus_coupling_constant
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_MAX_DUTY,
      VALUE => MAX_DUTY
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_max_duty,
      bus_rd => bus_rd,
      bus_done => bus_done_max_duty
    );
  
  step_size_n_coupling_inst : mainbus_coupling_constant
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_STEP_SIZE_N,
      VALUE => STEP_SIZE_N
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_step_size_n,
      bus_rd => bus_rd,
      bus_done => bus_done_step_size_n
    );
  
  step_size_d_coupling_inst : mainbus_coupling_constant
    generic map
    (
      BASE_ADDRESS => BASE_ADDRESS_STEP_SIZE_D,
      VALUE => STEP_SIZE_D
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_step_size_d,
      bus_rd => bus_rd,
      bus_done => bus_done_step_size_d
    );
  
  cnt_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 48,
      BASE_ADDRESS => BASE_ADDRESS_CNT
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_cnt,
      bus_rd => bus_rd,
      bus_done => bus_done_cnt,
      local_data_in => cnt
    );
  
  res_n_ext_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_RES_N_EXT
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_res_n_ext,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_res_n_ext,
      local_data_in => res_n_ext_reg,
      local_data_out => res_n_ext_reg_data_wr,
      local_wr => res_n_ext_reg_wr
    );
  res_n_ext_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 1
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => res_n_ext_reg,
      d => res_n_ext_reg_data_wr,
      en => res_n_ext_reg_wr
    );
  res_n_ext <= res_n_ext_reg(0);
  
  cnt_en_ext_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_CNT_EN_EXT
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_cnt_en_ext,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_cnt_en_ext,
      local_data_in => cnt_en_ext_reg,
      local_data_out => cnt_en_ext_reg_data_wr,
      local_wr => cnt_en_ext_reg_wr
    );
  cnt_en_ext_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 1
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => cnt_en_ext_reg,
      d => cnt_en_ext_reg_data_wr,
      en => cnt_en_ext_reg_wr
    );
  cnt_en_ext <= cnt_en_ext_reg(0);
  
  opcode_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 32,
      BASE_ADDRESS => BASE_ADDRESS_OPCODE
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_opcode,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_opcode,
      local_data_in => opcode_reg,
      local_data_out => opcode_reg_data_wr,
      local_wr => opcode_reg_wr
    );
  opcode_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 32
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => opcode_reg,
      d => opcode_reg_data_wr,
      en => opcode_reg_wr
    );
  opcode <= opcode_reg;
  
  res_cnt_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 64,
      BASE_ADDRESS => BASE_ADDRESS_RES_CNT
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_res_cnt,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_res_cnt,
      local_data_in => res_cnt_reg,
      local_data_out => res_cnt_reg_data_wr,
      local_wr => res_cnt_reg_wr
    );
  res_cnt_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 64
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => res_cnt_reg,
      d => res_cnt_reg_data_wr,
      en => res_cnt_reg_wr
    );
  res_cnt <= res_cnt_reg;
  
  mes_cnt_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 64,
      BASE_ADDRESS => BASE_ADDRESS_MES_CNT
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_mes_cnt,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_mes_cnt,
      local_data_in => mes_cnt_reg,
      local_data_out => mes_cnt_reg_data_wr,
      local_wr => mes_cnt_reg_wr
    );
  mes_cnt_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 64
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => mes_cnt_reg,
      d => mes_cnt_reg_data_wr,
      en => mes_cnt_reg_wr
    );
  mes_cnt <= mes_cnt_reg;
  
  busy_vec(0) <= busy;
  busy_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_BUSY
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_busy,
      bus_rd => bus_rd,
      bus_done => bus_done_busy,
      local_data_in => busy_vec
    );
  
  heart_beat_changed_vec(0) <= heart_beat_changed;
  heart_beat_changed_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_HEART_BEAT_CHANGED
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_heart_beat_changed,
      bus_rd => bus_rd,
      bus_done => bus_done_heart_beat_changed,
      local_data_in => heart_beat_changed_vec
    );
  
  heart_beat_clear_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_HEART_BEAT_CLEAR
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_heart_beat_clear,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_heart_beat_clear,
      local_data_in => heart_beat_clear_reg,
      local_data_out => heart_beat_clear_reg_data_wr,
      local_wr => heart_beat_clear_reg_wr
    );
  heart_beat_clear_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 1
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => heart_beat_clear_reg,
      d => heart_beat_clear_reg_data_wr,
      en => heart_beat_clear_reg_wr
    );
  heart_beat_clear <= heart_beat_clear_reg(0);
  
  ps_in_progress_pulse_vec(0) <= ps_in_progress_pulse;
  ps_in_progress_pulse_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_PS_IN_PROGRESS_PULSE
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_ps_in_progress_pulse,
      bus_rd => bus_rd,
      bus_done => bus_done_ps_in_progress_pulse,
      local_data_in => ps_in_progress_pulse_vec
    );
  
  ps_inc_pulse_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_PS_INC_PULSE
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_ps_inc_pulse,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_ps_inc_pulse,
      local_data_in => ps_inc_pulse_reg,
      local_data_out => ps_inc_pulse_reg_data_wr,
      local_wr => ps_inc_pulse_reg_wr
    );
  ps_inc_pulse_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 1
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => ps_inc_pulse_reg,
      d => ps_inc_pulse_reg_data_wr,
      en => ps_inc_pulse_reg_wr
    );
  ps_inc_pulse <= ps_inc_pulse_reg(0);
  
  ps_dec_pulse_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_PS_DEC_PULSE
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_ps_dec_pulse,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_ps_dec_pulse,
      local_data_in => ps_dec_pulse_reg,
      local_data_out => ps_dec_pulse_reg_data_wr,
      local_wr => ps_dec_pulse_reg_wr
    );
  ps_dec_pulse_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 1
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => ps_dec_pulse_reg,
      d => ps_dec_pulse_reg_data_wr,
      en => ps_dec_pulse_reg_wr
    );
  ps_dec_pulse <= ps_dec_pulse_reg(0);
  
  ps_value_pulse_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 32,
      BASE_ADDRESS => BASE_ADDRESS_PS_VALUE_PULSE
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_ps_value_pulse,
      bus_rd => bus_rd,
      bus_done => bus_done_ps_value_pulse,
      local_data_in => ps_value_pulse
    );
  
  ps_in_progress_det_vec(0) <= ps_in_progress_det;
  ps_in_progress_det_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_PS_IN_PROGRESS_DET
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_ps_in_progress_det,
      bus_rd => bus_rd,
      bus_done => bus_done_ps_in_progress_det,
      local_data_in => ps_in_progress_det_vec
    );
  
  ps_inc_det_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_PS_INC_DET
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_ps_inc_det,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_ps_inc_det,
      local_data_in => ps_inc_det_reg,
      local_data_out => ps_inc_det_reg_data_wr,
      local_wr => ps_inc_det_reg_wr
    );
  ps_inc_det_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 1
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => ps_inc_det_reg,
      d => ps_inc_det_reg_data_wr,
      en => ps_inc_det_reg_wr
    );
  ps_inc_det <= ps_inc_det_reg(0);
  
  ps_dec_det_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_PS_DEC_DET
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_ps_dec_det,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_ps_dec_det,
      local_data_in => ps_dec_det_reg,
      local_data_out => ps_dec_det_reg_data_wr,
      local_wr => ps_dec_det_reg_wr
    );
  ps_dec_det_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 1
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => ps_dec_det_reg,
      d => ps_dec_det_reg_data_wr,
      en => ps_dec_det_reg_wr
    );
  ps_dec_det <= ps_dec_det_reg(0);
  
  ps_value_det_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 32,
      BASE_ADDRESS => BASE_ADDRESS_PS_VALUE_DET
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_ps_value_det,
      bus_rd => bus_rd,
      bus_done => bus_done_ps_value_det,
      local_data_in => ps_value_det
    );
  
  cal_coupling_inst : mainbus_coupling_no_local_address_1cyc
    generic map
    (
      DATA_WIDTH => 1,
      BASE_ADDRESS => BASE_ADDRESS_CAL
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_ms => bus_data_ms,
      bus_data_sm => bus_data_sm_cal,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done_cal,
      local_data_in => cal_reg,
      local_data_out => cal_reg_data_wr,
      local_wr => cal_reg_wr
    );
  cal_reg_inst : reg_1rw_1c
    generic map
    (
      RESET_VALUE => '0',
      WIDTH => 1
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      q => cal_reg,
      d => cal_reg_data_wr,
      en => cal_reg_wr
    );
  cal <= cal_reg(0);
  
  mtbf_stack_coupling_inst : mainbus_coupling_readonly
    generic map
    (
      ADDR_WIDTH => 3,
      DATA_WIDTH => 48,
      BASE_ADDRESS => BASE_ADDRESS_MTBF_STACK
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_mtbf_stack,
      bus_rd => bus_rd,
      bus_done => bus_done_mtbf_stack,
      local_addr => mtbf_stack_addr,
      local_data_in => mtbf_stack,
      local_rd => mtbf_stack_rd,
      local_busy => mtbf_stack_busy
    );
  
  mtbf_stack_empty_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 5,
      BASE_ADDRESS => BASE_ADDRESS_MTBF_STACK_EMPTY
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_mtbf_stack_empty,
      bus_rd => bus_rd,
      bus_done => bus_done_mtbf_stack_empty,
      local_data_in => mtbf_stack_empty
    );
  
  mtbf_stack_overflowed_coupling_inst : mainbus_coupling_value_1cyc
    generic map
    (
      DATA_WIDTH => 5,
      BASE_ADDRESS => BASE_ADDRESS_MTBF_STACK_OVERFLOWED
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      bus_address => bus_address,
      bus_data_sm => bus_data_sm_mtbf_stack_overflowed,
      bus_rd => bus_rd,
      bus_done => bus_done_mtbf_stack_overflowed,
      local_data_in => mtbf_stack_overflowed
    );
  
  serial_mainbus_inst : serial_mainbus
    generic map
    (
      CLK_FREQ => CLK_FREQ
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      serial_data_out => serial_data_bus_port,
      serial_data_in => serial_data_port_bus,
      serial_new_data => serial_new_data,
      serial_free => serial_free,
      serial_wr => serial_wr,
      bus_data_out => bus_data_ms,
      bus_data_in => bus_data_sm,
      bus_address => bus_address,
      bus_rd => bus_rd,
      bus_wr => bus_wr,
      bus_done => bus_done
    );
  serial_port_inst : serial_port
    generic map
    (
      CLK_DIVISOR => CLK_FREQ / BAUD_RATE,
      SYNC_STAGES => SYNC_STAGES
    )
    port map
    (
      clk => clk,
      res_n => res_n,
      data_in => serial_data_bus_port,
      wr => serial_wr,
      free => serial_free,
      data_out => serial_data_port_bus,
      new_data => serial_new_data,
      rx => rx,
      tx => tx
    );
  decoder_process : process(
      bus_data_sm_ps_inc_pulse, bus_done_ps_inc_pulse,
      bus_data_sm_version, bus_done_version,
      bus_data_sm_contr_freq, bus_done_contr_freq,
      bus_data_sm_ps_dec_det, bus_done_ps_dec_det,
      bus_data_sm_uut_freq, bus_done_uut_freq,
      bus_data_sm_min_step, bus_done_min_step,
      bus_data_sm_max_step, bus_done_max_step,
      bus_data_sm_min_duty, bus_done_min_duty,
      bus_data_sm_max_duty, bus_done_max_duty,
      bus_data_sm_step_size_n, bus_done_step_size_n,
      bus_data_sm_heart_beat_changed, bus_done_heart_beat_changed,
      bus_data_sm_busy, bus_done_busy,
      bus_data_sm_step_size_d, bus_done_step_size_d,
      bus_data_sm_mtbf_stack, bus_done_mtbf_stack,
      bus_data_sm_cnt, bus_done_cnt,
      bus_data_sm_ps_value_det, bus_done_ps_value_det,
      bus_data_sm_heart_beat_clear, bus_done_heart_beat_clear,
      bus_data_sm_ps_in_progress_pulse, bus_done_ps_in_progress_pulse,
      bus_data_sm_res_n_ext, bus_done_res_n_ext,
      bus_data_sm_cal, bus_done_cal,
      bus_data_sm_ps_dec_pulse, bus_done_ps_dec_pulse,
      bus_data_sm_board, bus_done_board,
      bus_data_sm_cnt_en_ext, bus_done_cnt_en_ext,
      bus_data_sm_ps_value_pulse, bus_done_ps_value_pulse,
      bus_data_sm_mes_cnt, bus_done_mes_cnt,
      bus_data_sm_ps_in_progress_det, bus_done_ps_in_progress_det,
      bus_data_sm_opcode, bus_done_opcode,
      bus_data_sm_mtbf_stack_empty, bus_done_mtbf_stack_empty,
      bus_data_sm_ps_inc_det, bus_done_ps_inc_det,
      bus_data_sm_res_cnt, bus_done_res_cnt,
      bus_data_sm_mtbf_stack_overflowed, bus_done_mtbf_stack_overflowed,
      bus_address)
  begin
    if bus_address(31 downto 0) = BASE_ADDRESS_PS_INC_PULSE(31 downto 0) then
      bus_data_sm <= bus_data_sm_ps_inc_pulse;
      bus_done <= bus_done_ps_inc_pulse;
    elsif bus_address(31 downto 7) = BASE_ADDRESS_VERSION(31 downto 7) then
      bus_data_sm <= bus_data_sm_version;
      bus_done <= bus_done_version;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_CONTR_FREQ(31 downto 0) then
      bus_data_sm <= bus_data_sm_contr_freq;
      bus_done <= bus_done_contr_freq;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_PS_DEC_DET(31 downto 0) then
      bus_data_sm <= bus_data_sm_ps_dec_det;
      bus_done <= bus_done_ps_dec_det;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_UUT_FREQ(31 downto 0) then
      bus_data_sm <= bus_data_sm_uut_freq;
      bus_done <= bus_done_uut_freq;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_MIN_STEP(31 downto 0) then
      bus_data_sm <= bus_data_sm_min_step;
      bus_done <= bus_done_min_step;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_MAX_STEP(31 downto 0) then
      bus_data_sm <= bus_data_sm_max_step;
      bus_done <= bus_done_max_step;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_MIN_DUTY(31 downto 0) then
      bus_data_sm <= bus_data_sm_min_duty;
      bus_done <= bus_done_min_duty;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_MAX_DUTY(31 downto 0) then
      bus_data_sm <= bus_data_sm_max_duty;
      bus_done <= bus_done_max_duty;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_STEP_SIZE_N(31 downto 0) then
      bus_data_sm <= bus_data_sm_step_size_n;
      bus_done <= bus_done_step_size_n;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_HEART_BEAT_CHANGED(31 downto 0) then
      bus_data_sm <= bus_data_sm_heart_beat_changed;
      bus_done <= bus_done_heart_beat_changed;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_BUSY(31 downto 0) then
      bus_data_sm <= bus_data_sm_busy;
      bus_done <= bus_done_busy;
    elsif bus_address(31 downto 1) = BASE_ADDRESS_STEP_SIZE_D(31 downto 1) then
      bus_data_sm <= bus_data_sm_step_size_d;
      bus_done <= bus_done_step_size_d;
    elsif bus_address(31 downto 4) = BASE_ADDRESS_MTBF_STACK(31 downto 4) then
      bus_data_sm <= bus_data_sm_mtbf_stack;
      bus_done <= bus_done_mtbf_stack;
    elsif bus_address(31 downto 1) = BASE_ADDRESS_CNT(31 downto 1) then
      bus_data_sm <= bus_data_sm_cnt;
      bus_done <= bus_done_cnt;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_PS_VALUE_DET(31 downto 0) then
      bus_data_sm <= bus_data_sm_ps_value_det;
      bus_done <= bus_done_ps_value_det;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_HEART_BEAT_CLEAR(31 downto 0) then
      bus_data_sm <= bus_data_sm_heart_beat_clear;
      bus_done <= bus_done_heart_beat_clear;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_PS_IN_PROGRESS_PULSE(31 downto 0) then
      bus_data_sm <= bus_data_sm_ps_in_progress_pulse;
      bus_done <= bus_done_ps_in_progress_pulse;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_RES_N_EXT(31 downto 0) then
      bus_data_sm <= bus_data_sm_res_n_ext;
      bus_done <= bus_done_res_n_ext;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_CAL(31 downto 0) then
      bus_data_sm <= bus_data_sm_cal;
      bus_done <= bus_done_cal;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_PS_DEC_PULSE(31 downto 0) then
      bus_data_sm <= bus_data_sm_ps_dec_pulse;
      bus_done <= bus_done_ps_dec_pulse;
    elsif bus_address(31 downto 7) = BASE_ADDRESS_BOARD(31 downto 7) then
      bus_data_sm <= bus_data_sm_board;
      bus_done <= bus_done_board;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_CNT_EN_EXT(31 downto 0) then
      bus_data_sm <= bus_data_sm_cnt_en_ext;
      bus_done <= bus_done_cnt_en_ext;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_PS_VALUE_PULSE(31 downto 0) then
      bus_data_sm <= bus_data_sm_ps_value_pulse;
      bus_done <= bus_done_ps_value_pulse;
    elsif bus_address(31 downto 1) = BASE_ADDRESS_MES_CNT(31 downto 1) then
      bus_data_sm <= bus_data_sm_mes_cnt;
      bus_done <= bus_done_mes_cnt;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_PS_IN_PROGRESS_DET(31 downto 0) then
      bus_data_sm <= bus_data_sm_ps_in_progress_det;
      bus_done <= bus_done_ps_in_progress_det;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_OPCODE(31 downto 0) then
      bus_data_sm <= bus_data_sm_opcode;
      bus_done <= bus_done_opcode;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_MTBF_STACK_EMPTY(31 downto 0) then
      bus_data_sm <= bus_data_sm_mtbf_stack_empty;
      bus_done <= bus_done_mtbf_stack_empty;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_PS_INC_DET(31 downto 0) then
      bus_data_sm <= bus_data_sm_ps_inc_det;
      bus_done <= bus_done_ps_inc_det;
    elsif bus_address(31 downto 1) = BASE_ADDRESS_RES_CNT(31 downto 1) then
      bus_data_sm <= bus_data_sm_res_cnt;
      bus_done <= bus_done_res_cnt;
    elsif bus_address(31 downto 0) = BASE_ADDRESS_MTBF_STACK_OVERFLOWED(31 downto 0) then
      bus_data_sm <= bus_data_sm_mtbf_stack_overflowed;
      bus_done <= bus_done_mtbf_stack_overflowed;
    else
      bus_data_sm <= (others =>'0');
      bus_done <= '0';
    end if;
  end process decoder_process;
  
end architecture mixed;

