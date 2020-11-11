library ieee;
use ieee.std_logic_1164.all;

package ltd_pkg is
	component ltd is
		generic (
			SYNC_STAGES : integer range 2 to integer'high
		);
		port (
			clk_ref : in std_logic;
			clk_det : in std_logic;
			i : in std_logic;
			error : out std_logic;
			error01 : out std_logic;
			error10 : out std_logic;
			error010 : out std_logic;
			error101 : out std_logic
		);
	end component;
end package;
