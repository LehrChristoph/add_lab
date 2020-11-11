library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ltd_d_ff_top_pkg.all;

entity ltd_d_ff_top_de2_115 is
	port (
		clk, res_n : in std_logic;
		data_in : in std_logic;

		rx : in std_logic;
		tx : out std_logic;

		led_cnt : out std_logic;
		led_res : out std_logic;
		led_running : out std_logic;
		led_heart : out std_logic
	);
end entity;

architecture struct of ltd_d_ff_top_de2_115 is
	constant CLK_FREQ : integer := 50000000;
	constant BOARD : string := "de2_115";
	constant VERSION : string := "-";
	constant CONTR_FREQ : unsigned(31 downto 0) := to_unsigned(CLK_FREQ, 32);
	constant UUT_FREQ : unsigned(31 downto 0) := to_unsigned(3 * CLK_FREQ, 32);
	constant MIN_STEP : signed(31 downto 0) := to_signed(-47, 32);
	constant MAX_STEP : signed(31 downto 0) := to_signed(47, 32);
	constant MIN_DUTY : signed(31 downto 0) := to_signed(-5, 32);
	constant MAX_DUTY : signed(31 downto 0) := to_signed(5, 32);
	constant STEP_SIZE_N : unsigned(31 downto 0) := to_unsigned(562, 32);
	constant STEP_SIZE_D_HELP : unsigned(127 downto 0) := UUT_FREQ * 100 * 360;
	constant STEP_SIZE_D : unsigned(63 downto 0) := STEP_SIZE_D_HELP(63 downto 0);
begin
	top_inst : ltd_d_ff_top
	generic map (
		CLK_FREQ => CLK_FREQ,
		BOARD => BOARD,
		VERSION => VERSION,
		CONTR_FREQ => CONTR_FREQ,
		UUT_FREQ => UUT_FREQ,
		MIN_STEP => MIN_STEP,
		MAX_STEP => MAX_STEP,
		MIN_DUTY => MIN_DUTY,
		MAX_DUTY =>MAX_DUTY,
		STEP_SIZE_N => STEP_SIZE_N,
		STEP_SIZE_D => STEP_SIZE_D
	)
	port map (
		clk_in => clk,
		res_n => res_n,
		data_in => data_in,

		rx => rx,
		tx => tx,

		led_cnt => led_cnt,
		led_res => led_res,
		led_running => led_running,
		led_heart => led_heart
	);
end architecture;
