----------------------------------------------------------------------------------
-- Select A larger than B Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;

entity sel_a_larger_b_tb is
	
	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal AB_t, AB_f: std_logic_vector(3 downto 0);
	signal selector_t, selector_f: std_logic;

end sel_a_larger_b_tb;

architecture beh of sel_a_larger_b_tb is
begin

	sel_a_larger_b_test : entity work.sel_a_larger_b
	generic map(
		DATA_WIDTH => 4
	)
	port map(
		-- Input channel
		in_data_t     => AB_t,
		in_data_f     => AB_f,
		-- Output channel
		selector_t    => selector_t,
		selector_f    => selector_f
	);
	

	demux_stimuli : process
	begin		
		wait until rising_edge(clk);
		AB_t <= "1100";
		AB_f <= "0011";
				
		wait until rising_edge(clk);
		AB_t <= "0011";
		AB_f <= "1100";
		
		wait until rising_edge(clk);
		AB_t <= "1010";
		AB_f <= "0101";
		
		wait until rising_edge(clk);
		AB_t <= "0101";
		AB_f <= "1010";
		
		wait until rising_edge(clk);
		AB_t <= "1001";
		AB_f <= "0110";
		
		wait until rising_edge(clk);
		AB_t <= "0110";
		AB_f <= "1001";
		
		wait until rising_edge(clk);
		AB_t <= "0000";
		AB_f <= "1111";
				
		wait until rising_edge(clk);
		AB_t <= "1111";
		AB_f <= "0000";
		
		wait;
	end process;
	
	generate_clk : process
	begin
		reset <= '1';
		clk <= '0';
		wait for CLK_PERIOD;
		reset <= '0';
		
		while not stop_clock loop
			clk <= '0', '1' after CLK_PERIOD / 2;
			wait for CLK_PERIOD;
		end loop;
		wait;
	end process;
	
end architecture;