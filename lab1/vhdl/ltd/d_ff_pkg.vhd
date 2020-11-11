library ieee;
use ieee.std_logic_1164.all;

package d_ff_pkg is
	component d_ff is
		port (
			clk, res_n, d : in std_logic;
			q : out std_logic
		);
	end component;
end package;
