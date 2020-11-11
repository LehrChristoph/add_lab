library ieee;
use ieee.std_logic_1164.all;

package fast_cnt_pkg is
	component fast_cnt is
		generic (
			CNT_WIDTH : integer
		);
		port (
			clk, res_n : in std_logic;
			cnt_en	: in std_logic;
			cnt_out : out std_logic_vector(CNT_WIDTH - 1 downto 0)
		);
	end component;
end package;
