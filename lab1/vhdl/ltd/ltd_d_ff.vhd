library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.debounce_pkg.all;
use work.d_ff_pkg.all;
use work.ltd_d_ff_pkg.all;
use work.sync_pkg.all;
use work.math_pkg.all;
use work.fast_cnt_pkg.all;
use work.ltd_pkg.all;
use work.fast_cnt_capture_pkg.all;

entity ltd_d_ff is
	generic
	(
		CLK_FREQ : integer;
		SYNC_STAGES : integer;
		CNT_WIDTH : integer;
		HEART_BEAT_WIDTH : integer;
		PS_VALUE_WIDTH : integer;
		MTBF_STACK_DEPTH : integer;
		CAPTURE_SOURCES : integer;
		MIN_STEP : signed(31 downto 0);
		MAX_STEP : signed(31 downto 0);
		MIN_DUTY : signed(31 downto 0);
		MAX_DUTY : signed(31 downto 0)
	);
	port
	(
		clk_in, res_n_in : in std_logic;
		data_in : in std_logic;

		led_cnt : out std_logic;
		led_res : out std_logic;
		led_running : out std_logic;
		led_heart : out std_logic;
		
		clk_contr : out std_logic;
		res_contr_n : out std_logic;

		ps_inc_pulse, ps_dec_pulse : in std_logic;
		ps_in_progress_pulse : out std_logic;
		ps_value_pulse : out std_logic_vector(PS_VALUE_WIDTH - 1 downto 0);
		ps_inc_det, ps_dec_det : in std_logic;
		ps_in_progress_det : out std_logic;
		ps_value_det : out std_logic_vector(PS_VALUE_WIDTH - 1 downto 0);
		cnt_en : in std_logic;
		cal : in std_logic;
		res_n_soft : in std_logic;
		heart_beat : out std_logic;
		cnt : out std_logic_vector(CNT_WIDTH - 1 downto 0);
		mtbf_stack : out std_logic_vector(CNT_WIDTH - 1 downto 0);
		mtbf_stack_addr : in std_logic_vector(log2c(CAPTURE_SOURCES) - 1 downto 0);
		mtbf_stack_rd : in std_logic;
		mtbf_stack_busy : out std_logic;
		mtbf_stack_empty : out std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
		mtbf_stack_overflowed : out std_logic_vector(CAPTURE_SOURCES - 1 downto 0)
	);
end entity;

architecture struct of ltd_d_ff is
	constant CNT_MAX : unsigned(CNT_WIDTH - 1 downto 0) := (others => '1');
	
	signal q : std_logic;
	signal clk_uut, clk_ref, clk_det : std_logic;
	
	signal heart_beat_cnt : std_logic_vector(HEART_BEAT_WIDTH - 1 downto 0);
	 
	signal data : std_logic;
	signal res_n_ref, res_n_soft_ref, res_n_full_ref : std_logic;	
	signal cnt_en_sync : std_logic;
	signal cal_data, cal_sync : std_logic;
	
	signal error, error01, error10, error010, error101 : std_logic;
	signal cnt_int : std_logic_vector(CNT_WIDTH - 1 downto 0);
	signal error_vec : std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
	signal clk_contr_int, res_contr_n_int : std_logic;
begin
	uut : d_ff
	port map
	(
		clk => clk_uut,
		d => data,
		res_n => '1',
		q => q
	);

	res_n_full_ref <= res_n_ref and res_n_soft_ref;

	ltd_inst : ltd
	generic map
	(
		SYNC_STAGES => SYNC_STAGES
	)
	port map
	(
		clk_ref => clk_ref,
		clk_det => clk_det,
		i => q,
		error => error,
		error01 => error01,
		error10 => error10,
		error010 => error010,
		error101 => error101
	);

	error_vec <= error & error01 & error10	& error010 & error101;

	fast_cnt_capture_inst : fast_cnt_capture
	generic map
	(
		CNT_WIDTH => CNT_WIDTH,
		MIN_DEPTH => MTBF_STACK_DEPTH,
		SYNC_STAGES => SYNC_STAGES,
		CAPTURE_SOURCES => CAPTURE_SOURCES
	)
	port map
	(
		clk => clk_ref,
		res_n => res_n_full_ref,
		cnt_en => cnt_en_sync,
		cnt_out => cnt_int,
		capture => error_vec,
		
		clk_contr => clk_contr_int,
		res_contr_n => res_contr_n_int,
		cnt_stack_source => mtbf_stack_addr,
		cnt_stack_data => mtbf_stack,
		cnt_stack_rd => mtbf_stack_rd,
		cnt_stack_busy => mtbf_stack_busy,
		cnt_stack_empty => mtbf_stack_empty,
		cnt_stack_overflowed => mtbf_stack_overflowed
	);
	cnt <= cnt_int ;
	
	heart_beat_inst : fast_cnt
		generic map
		(
			CNT_WIDTH => HEART_BEAT_WIDTH
		)
		port map
		(
			clk => clk_uut,
			res_n => '1',
			cnt_en => '1',
			cnt_out => heart_beat_cnt
		);

	led_heart <= not heart_beat_cnt(HEART_BEAT_WIDTH - 1);
	led_running <= not cnt_en;
	led_res <= not res_n_full_ref;
	led_cnt <= not cnt_int(0);

	delay_line_inst : delay_line
	generic map
	(
		SYNC_STAGES => SYNC_STAGES,
		PS_VALUE_MIN => MIN_STEP,
		PS_VALUE_MAX => MAX_STEP,
		PS_VALUE_PULSE_MIN => MIN_DUTY,
		PS_VALUE_PULSE_MAX => MAX_DUTY
	)
	port map
	(			
		clk_in => clk_in,
		res_n_in => res_n_in,

		clk_uut => clk_uut,
		clk_contr => clk_contr_int,
		res_contr_n => res_contr_n_int,
		ps_inc_pulse => ps_inc_pulse,
		ps_dec_pulse => ps_dec_pulse,
		ps_in_progress_pulse => ps_in_progress_pulse,
		ps_value_pulse => ps_value_pulse,
		ps_value_det => ps_value_det,
		ps_inc_det => ps_inc_det,
		ps_dec_det => ps_dec_det,
		ps_in_progress_det => ps_in_progress_det,
		clk_det => clk_det,
		clk_ref => clk_ref,
		res_n_ref => res_n_ref,
		cal_sync => cal_sync,
		cal_data => cal_data,
		ff_data_in => data_in,
		ff_data => data
	);
	clk_contr <= clk_contr_int;
	res_contr_n <= res_contr_n_int;

	heart_beat_sync_inst : sync
	generic map
	(
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '0'
	)
	port map
	(
		clk => clk_contr_int,
		res_n => '1',
		data_in => heart_beat_cnt(HEART_BEAT_WIDTH / 2),
		data_out => heart_beat
	);

	cnt_en_sync_inst : sync
		generic map (
			SYNC_STAGES => SYNC_STAGES,
			RESET_VALUE => '0'
		)
		port map (
			clk => clk_ref,
			res_n => res_n_ref,
			data_in => cnt_en,
			data_out => cnt_en_sync
		);

	res_n_soft_inst : sync
		generic map (
			SYNC_STAGES => SYNC_STAGES,
			RESET_VALUE => '0'
		)
		port map (
			clk => clk_ref,
			res_n => res_n_ref,
			data_in => res_n_soft,
			data_out => res_n_soft_ref
		);

	cal_data_gen_inst : cal_data_gen
	port map
	(
		clk => clk_ref,
		res_n => '1',
		data => cal_data
	);

	cal_sync_inst : sync
	generic map
	(
		SYNC_STAGES => SYNC_STAGES,
		RESET_VALUE => '0'
	)
	port map
	(
		clk => clk_uut,
		res_n => '1',
		data_in => cal,
		data_out => cal_sync
	);
end architecture;
