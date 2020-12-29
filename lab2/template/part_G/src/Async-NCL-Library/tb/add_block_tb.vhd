----------------------------------------------------------------------------------
-- Add Block Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;

entity add_block_tb is
	
	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal a_t,a_f: std_logic_vector(1 downto 0);
	signal b_t,b_f: std_logic_vector(1 downto 0);
	signal c_t,c_f: std_logic_vector(1 downto 0);
	signal done : std_logic;
end add_block_tb;

architecture beh of add_block_tb is
begin
	add_block_test : entity work.add_block
	generic map(
		DATA_WIDTH => 2
	)
	port map(
		-- flags
		rst			=> reset,
		done			=> done,
		-- Input channel
		inA_data_t  => a_t,
		inA_data_f  => a_f,
		inB_data_t  => b_t,
		inB_data_f  => b_f,
		-- Output channel
		outC_data_t => c_t,
		outC_data_f => c_f
	);
		
	mux_stimuli : process
	begin		
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "11";
		b_t <= "00";
		b_f <= "11";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "01";
		a_f <= "10";
		b_t <= "00";
		b_f <= "11";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "10";
		a_f <= "01";
		b_t <= "00";
		b_f <= "11";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "11";
		a_f <= "00";
		b_t <= "00";
		b_f <= "11";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "11";
		b_t <= "01";
		b_f <= "10";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "01";
		a_f <= "10";
		b_t <= "01";
		b_f <= "10";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "10";
		a_f <= "01";
		b_t <= "01";
		b_f <= "10";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "11";
		a_f <= "00";
		b_t <= "01";
		b_f <= "10";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "11";
		b_t <= "10";
		b_f <= "01";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "01";
		a_f <= "10";
		b_t <= "10";
		b_f <= "01";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "10";
		a_f <= "01";
		b_t <= "10";
		b_f <= "01";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "11";
		a_f <= "00";
		b_t <= "10";
		b_f <= "01";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "11";
		b_t <= "11";
		b_f <= "00";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "01";
		a_f <= "10";
		b_t <= "11";
		b_f <= "00";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "10";
		a_f <= "01";
		b_t <= "11";
		b_f <= "00";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
		wait until rising_edge(clk);
		a_t <= "11";
		a_f <= "00";
		b_t <= "11";
		b_f <= "00";
		wait until done = '1';
		a_t <= "00";
		a_f <= "00";
		b_t <= "00";
		b_f <= "00";
		wait until done = '0';
		
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