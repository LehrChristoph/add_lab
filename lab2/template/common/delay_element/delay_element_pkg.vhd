library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package delay_element_pkg is

	component delay_element is
		generic (
			NUM_LCELLS : integer := 8
		);
		port (
			i : in std_logic;
			o : out std_logic
		);
	end component;
	
end package;

