library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

package ltd_d_ff_pkg is
	component cal_data_gen is
		port (
			clk : in std_logic;
			res_n : in std_logic;
			data : out std_logic
		);
	end component;
	
	component delay_line is
		generic (
			SYNC_STAGES : integer;
			PS_VALUE_MIN : signed(31 downto 0);
			PS_VALUE_MAX : signed(31 downto 0);
			PS_VALUE_PULSE_MIN : signed(31 downto 0);
			PS_VALUE_PULSE_MAX : signed(31 downto 0)
		);
		port (
			clk_in, res_n_in : in std_logic;
			clk_uut : out std_logic;
			clk_contr : out std_logic;
			res_contr_n : out std_logic;
			ps_value_det : out std_logic_vector(31 downto 0);
			ps_value_pulse : out std_logic_vector(31 downto 0);
			ps_inc_det, ps_dec_det : in std_logic;
			ps_inc_pulse, ps_dec_pulse : in std_logic;
			ps_in_progress_det, ps_in_progress_pulse : out std_logic;
			clk_det : out std_logic;
			clk_ref : out std_logic;
			res_n_ref : out std_logic;
			cal_sync, cal_data, ff_data_in : in std_logic;
			ff_data : out std_logic
		);
	end component;
		
	component controller is
		generic (
			CLK_FREQ : integer;
			BAUD_RATE : integer;
			SYNC_STAGES : integer;
			CNT_WIDTH : integer;
			CAPTURE_SOURCES : integer;
			BOARD : string;
			VERSION : string;
			CONTR_FREQ : std_logic_vector(31 downto 0);
			UUT_FREQ : std_logic_vector(31 downto 0);
			MIN_STEP : std_logic_vector(31 downto 0);
			MAX_STEP : std_logic_vector(31 downto 0);
			MIN_DUTY : std_logic_vector(31 downto 0);
			MAX_DUTY : std_logic_vector(31 downto 0);
			STEP_SIZE_N : std_logic_vector(31 downto 0);
			STEP_SIZE_D : std_logic_vector(63 downto 0)
		);
		port (
			clk_in, res_n_in : in std_logic;
			cnt : in std_logic_vector(CNT_WIDTH - 1 downto 0);
			mtbf_stack : in std_logic_vector(CNT_WIDTH - 1 downto 0);
			mtbf_stack_addr : out std_logic_vector(log2c(CAPTURE_SOURCES) - 1 downto 0);
			mtbf_stack_rd : out std_logic;
			mtbf_stack_busy : in std_logic;
			mtbf_stack_empty : in std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
			mtbf_stack_overflowed : in std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
			res_n : out std_logic;
			cnt_en : out std_logic;
			heart_beat : in std_logic;
			ps_in_progress_pulse	: in std_logic;
			ps_inc_pulse : out std_logic;
			ps_dec_pulse : out std_logic;
			ps_value_pulse : in std_logic_vector(31 downto 0);
			ps_value_det	: in std_logic_vector(31 downto 0);
			ps_inc_det : out std_logic;
			ps_dec_det : out std_logic;
			ps_in_progress_det	: in std_logic;
			cal : out std_logic;			
			rx : in std_logic;
			tx : out std_logic
		);
	end component;

	component counter_unit is
		generic (
			CNT_WIDTH : integer range 4 to integer'high
		);
		port (
			clk_in : in std_logic;
			clk_ref : in std_logic;
			res_n_ref : in std_logic;
			
			error : in std_logic;
			error010 : in std_logic;
			error01 : in std_logic;
			error10 : in std_logic;
			error101 : in std_logic;
		
			cnt_en_in : in std_logic;
			cnt : out std_logic_vector(CNT_WIDTH - 1 downto 0);
			cnt010 : out std_logic_vector(CNT_WIDTH - 1 downto 0);
			cnt01 : out std_logic_vector(CNT_WIDTH - 1 downto 0);
			cnt10 : out std_logic_vector(CNT_WIDTH - 1 downto 0);
			cnt101 : out std_logic_vector(CNT_WIDTH - 1 downto 0)
		);
	end component;

	component ltd_d_ff is
		generic (
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
		port (
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
	end component;
end package;

