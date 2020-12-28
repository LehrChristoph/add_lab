----------------------------------------------------------------------------------
-- Weak Condition Half Buffer Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;

entity wchb_ncl_tb is
	
	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal a_t,a_f: std_logic_vector(1 downto 0);
	signal b_t,b_f: std_logic_vector(1 downto 0);
	signal ack, done : std_logic;

end wchb_ncl_tb;

architecture beh of wchb_ncl_tb is
begin
	reg_test : entity work.wchb_ncl
	generic map( 
		DATA_WIDTH  => 2
	)
	port map(
		-- flags
		rst       => reset,
		ack_in    => ack,
		ack_out   => done,
		-- Input channel
		in_t      => a_t ,
		in_f      => a_f ,
		-- Output channel
		out_t     => b_t,
		out_f     => b_f
	);
	
	wchb_stimuli : process
	begin		
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		ack <= '0';
		
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "11";
		wait until done = '1';
		wait until rising_edge(clk);	
		ack <= '1';
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		wait until done = '0';
		wait until rising_edge(clk);
		ack <= '0';
		
		wait until rising_edge(clk);
		a_t <= "01";
		a_f <= "10";
		wait until done = '1';
		wait until rising_edge(clk);	
		ack <= '1';
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		wait until done = '0';
		ack <= '0';
		
		wait until rising_edge(clk);
		a_t <= "10";
		a_f <= "01";
		wait until done = '1';
		wait until rising_edge(clk);	
		ack <= '1';
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		wait until done = '0';
		ack <= '0';
		
		wait until rising_edge(clk);
		a_t <= "11";
		a_f <= "00";
		wait until done = '1';
		wait until rising_edge(clk);	
		ack <= '1';
		wait until rising_edge(clk);
		a_t <= "00";
		a_f <= "00";
		wait until done = '0';
		ack <= '0';
		
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
