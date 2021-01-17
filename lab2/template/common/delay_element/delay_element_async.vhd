
library ieee;
use ieee.std_logic_1164.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity delay_element is
	generic (
		SIZE : integer := 5
	);
	port (
		d : in std_logic;
		z : out std_logic
	);
end entity;

architecture arch of delay_element is
        signal s : std_logic_vector(SIZE downto 0);
        attribute preserve: boolean;
        attribute preserve of s: signal is true;
begin
        s(0) <= d;
        z <= s(SIZE) after SIZE*1 ns;
        g_luts: for i in 0 to SIZE-1 generate
                cmp_LUT: LCELL
                port map(
                        a_in => s(i),
                        a_out => s(i+1)
                );
        end generate;

end architecture;



