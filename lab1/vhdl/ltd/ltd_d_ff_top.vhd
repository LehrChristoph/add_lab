library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.debounce_pkg.all;
use work.ltd_d_ff_pkg.all;
use work.math_pkg.all;

entity ltd_d_ff_top is
	generic (
		CLK_FREQ : integer;
		BOARD : string;
		VERSION : string;
		CONTR_FREQ : unsigned(31 downto 0);
		UUT_FREQ : unsigned(31 downto 0);
		MIN_STEP : signed(31 downto 0);
		MAX_STEP : signed(31 downto 0);
		MIN_DUTY : signed(31 downto 0);
		MAX_DUTY : signed(31 downto 0);
		STEP_SIZE_N : unsigned(31 downto 0);
		STEP_SIZE_D : unsigned(63 downto 0)
	);
	port (
		clk_in, res_n : in std_logic;
		data_in : in std_logic;

		rx : in std_logic;
		tx : out std_logic;
		
		led_cnt : out std_logic;
		led_res : out std_logic;
		led_running : out std_logic;
		led_heart : out std_logic
	);
end entity;

architecture struct of ltd_d_ff_top is	
	constant CNT_WIDTH : integer := 48;
	constant HEART_BEAT_WIDTH : integer := 32;
	constant PS_VALUE_WIDTH : integer := 32;
	constant SYNC_STAGES : integer := 3;
	constant BAUD_RATE : integer := 115200;
	constant MTBF_STACK_DEPTH : integer := 2048;
	constant CAPTURE_SOURCES : integer := 5;

	signal res_n_in : std_logic;
	signal ps_inc_pulse, ps_dec_pulse : std_logic;
	signal ps_in_progress_pulse : std_logic;
	signal ps_value_pulse : std_logic_vector(PS_VALUE_WIDTH - 1 downto 0);
	signal ps_inc_det, ps_dec_det : std_logic;
	signal ps_in_progress_det : std_logic;
	signal ps_value_det : std_logic_vector(PS_VALUE_WIDTH - 1 downto 0);
	signal cnt_en : std_logic;
	signal cal : std_logic;
	signal res_n_soft : std_logic;
	signal heart_beat : std_logic;
	signal cnt : std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal mtbf_stack : std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal mtbf_stack_addr : std_logic_vector(log2c(CAPTURE_SOURCES) - 1 downto 0);
	signal mtbf_stack_rd : std_logic;
	signal mtbf_stack_busy : std_logic;
	signal mtbf_stack_empty : std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
	signal mtbf_stack_overflowed : std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
	signal clk_contr, res_contr_n : std_logic;
begin
	sys_res_debounce_inst : debounce
	generic map (
		CLK_FREQ => CLK_FREQ,
		TIMEOUT_US => 1000,
		RESET_VALUE => '0',
		SYNC_STAGES => SYNC_STAGES
	)
	port map (
		clk => clk_in,
		res_n => '1',
		data_in => res_n,
		data_out => res_n_in
	);

		
	controller_inst : controller
	generic map (
		CLK_FREQ => CLK_FREQ,
		BAUD_RATE => BAUD_RATE,
		SYNC_STAGES => SYNC_STAGES,
		CNT_WIDTH => CNT_WIDTH,
		CAPTURE_SOURCES => CAPTURE_SOURCES,
		BOARD => BOARD,
		VERSION => VERSION,
		CONTR_FREQ => std_logic_vector(CONTR_FREQ),
		UUT_FREQ => std_logic_vector(UUT_FREQ),
		MIN_STEP => std_logic_vector(MIN_STEP),
		MAX_STEP => std_logic_vector(MAX_STEP),
		MIN_DUTY => std_logic_vector(MIN_DUTY),
		MAX_DUTY => std_logic_vector(MAX_DUTY),
		STEP_SIZE_N => std_logic_vector(STEP_SIZE_N),
		STEP_SIZE_D => std_logic_vector(STEP_SIZE_D)
	)
	port map (
		clk_in => clk_contr,
		res_n_in => res_contr_n,
		cnt => cnt,
		mtbf_stack => mtbf_stack,
		mtbf_stack_addr => mtbf_stack_addr,
		mtbf_stack_rd => mtbf_stack_rd,
		mtbf_stack_busy => mtbf_stack_busy,
		mtbf_stack_empty => mtbf_stack_empty,
		mtbf_stack_overflowed => mtbf_stack_overflowed,
		res_n => res_n_soft,
		cnt_en => cnt_en,
		heart_beat => heart_beat,
		ps_in_progress_pulse => ps_in_progress_pulse,
		ps_inc_pulse => ps_inc_pulse,
		ps_dec_pulse => ps_dec_pulse,
		ps_value_pulse => ps_value_pulse,
		ps_value_det => ps_value_det,
		ps_inc_det => ps_inc_det,
		ps_dec_det => ps_dec_det,
		ps_in_progress_det => ps_in_progress_det,
		cal => cal,
		rx => rx,
		tx => tx
	);

	ltd_d_ff_inst : ltd_d_ff
	generic map (
		CLK_FREQ => CLK_FREQ,
		SYNC_STAGES => SYNC_STAGES,
		CNT_WIDTH => CNT_WIDTH,
		HEART_BEAT_WIDTH => HEART_BEAT_WIDTH,
		PS_VALUE_WIDTH => PS_VALUE_WIDTH,
		MTBF_STACK_DEPTH => MTBF_STACK_DEPTH,
		CAPTURE_SOURCES => CAPTURE_SOURCES,
		MIN_STEP => MIN_STEP,
		MAX_STEP => MAX_STEP,
		MIN_DUTY => MIN_DUTY,
		MAX_DUTY => MAX_DUTY
	)
	port map (
		clk_in => clk_in,
		res_n_in => res_n_in,
		data_in => data_in,

		led_cnt => led_cnt,
		led_res => led_res,
		led_running => led_running,
		led_heart => led_heart,
	
		clk_contr => clk_contr,
		res_contr_n => res_contr_n,
	
		ps_inc_pulse => ps_inc_pulse,
		ps_dec_pulse => ps_dec_pulse,
		ps_in_progress_pulse => ps_in_progress_pulse,
		ps_value_pulse => ps_value_pulse,
		ps_inc_det => ps_inc_det,
		ps_dec_det => ps_dec_det,
		ps_in_progress_det => ps_in_progress_det,
		ps_value_det => ps_value_det,
		cnt_en => cnt_en,
		cal => cal,
		res_n_soft => res_n_soft,
		heart_beat => heart_beat,
		cnt => cnt,
		mtbf_stack => mtbf_stack,
		mtbf_stack_addr => mtbf_stack_addr,
		mtbf_stack_rd => mtbf_stack_rd,
		mtbf_stack_busy => mtbf_stack_busy,
		mtbf_stack_empty => mtbf_stack_empty,
		mtbf_stack_overflowed => mtbf_stack_overflowed
	);
end architecture;
