library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;

package debounce_pkg is
	component debounce_fsm is
		generic (
			CLK_FREQ    : integer;
			TIMEOUT_US  : integer range 100 to 100000 := 1000;
			RESET_VALUE : std_logic
		);
		port (
			clk      : in  std_logic;
			res_n    : in  std_logic;

			i            : in  std_logic;
			o            : out std_logic
		);
	end component ;

	component debounce is
		generic (
			CLK_FREQ    : integer;
			TIMEOUT_US  : integer range 100 to 100000 := 1000;
			RESET_VALUE : std_logic := '0';
			SYNC_STAGES : integer range 2 to integer'high
		);
		port (
			clk      : in  std_logic;
			res_n    : in  std_logic;

			data_in      : in  std_logic;
			data_out     : out std_logic
		);
	end component;
end package;
