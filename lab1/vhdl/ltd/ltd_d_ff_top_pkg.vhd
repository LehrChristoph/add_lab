library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ltd_d_ff_top_pkg is
	component ltd_d_ff_top is
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
	end component;
end package;
