----------------------------------------------------------------------------------
-- Completion Detector Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;

entity completion_detector_tb is
	
	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal a_t,a_f: std_logic_vector(1 downto 0);
	signal complete : std_logic;


end completion_detector_tb;

architecture beh of completion_detector_tb is
	
begin
	
	
	cd_test : entity work.completion_detector
	generic map ( DATA_WIDTH => 2)
	port map(
		data_t => a_t,
		data_f => a_f,
		rst => reset,
		complete => complete
	);
	
	lcm_stimuli : process
	begin		
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		
		wait until rising_edge(clk);
		a_t <= "11";
		
		wait until rising_edge(clk);
		a_t <= "00";
		
		wait until rising_edge(clk);
		a_f <= "11";
		
		wait until rising_edge(clk);
		a_f <= "00";
		
		wait until rising_edge(clk);
		a_t <= "10";
		a_f <= "01";
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		
		wait until rising_edge(clk);
		a_t <= "01";
		a_f <= "10";
		wait until rising_edge(clk);
		a_t <= "10";
		a_f <= "01";
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		
		wait until rising_edge(clk);
		a_t <= "01";
		a_f <= "10";
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		
		wait until rising_edge(clk);
		a_t <= "11";
		a_f <= "11";
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
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
