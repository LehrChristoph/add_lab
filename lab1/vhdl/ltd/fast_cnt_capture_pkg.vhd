library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;

package fast_cnt_capture_pkg is
	component fast_cnt_capture is
		generic (
			CNT_WIDTH : integer range 4 to integer'high;
			MIN_DEPTH : integer range 4 to integer'high;
			SYNC_STAGES : integer;
			CAPTURE_SOURCES : integer range 1 to integer'high
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			cnt_en  : in std_logic;
			cnt_out : out std_logic_vector(CNT_WIDTH - 1 downto 0);
			capture : in std_logic_vector(CAPTURE_SOURCES - 1 downto 0);

			clk_contr : in std_logic;
			res_contr_n : in std_logic;
			cnt_stack_source : in std_logic_vector(log2c(CAPTURE_SOURCES) - 1 downto 0);
			cnt_stack_data : out std_logic_vector(CNT_WIDTH - 1 downto 0);
			cnt_stack_rd : in std_logic;
			cnt_stack_busy : out std_logic;
			cnt_stack_empty : out std_logic_vector(CAPTURE_SOURCES - 1 downto 0);
			cnt_stack_overflowed : out std_logic_vector(CAPTURE_SOURCES - 1 downto 0)
		);
	end component;
end package;
