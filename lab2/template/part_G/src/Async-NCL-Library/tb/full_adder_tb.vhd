----------------------------------------------------------------------------------
-- Mux Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;

entity full_adder_tb is
	
	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal a_t,a_f: std_logic;
	signal b_t,b_f: std_logic;
	signal c_t,c_f: std_logic;
	signal c_in_t, c_in_f, c_out_t, c_out_f, done : std_logic;
end full_adder_tb;

architecture beh of full_adder_tb is
begin
	full_adder_test : entity work.full_adder
	generic map(
		DATA_WIDTH => 2
	)
	port map(
		-- flags
		done			=> done,
		-- Input channel
		inA_data_t  => a_t,
		inA_data_f  => a_f,
		inB_data_t  => b_t,
		inB_data_f  => b_f,
		carry_in_t  => c_in_t,
		carry_in_f  => c_in_f,
		-- Output channel
		outC_data_t => c_t,
		outC_data_f => c_f,
		carry_out_t => c_out_t,
		carry_out_f => c_out_f
	);
	
	
	full_adder_stimuli : process
	begin		
		wait until rising_edge(clk);
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		
		-- carry in 0
		-- 0+0
		wait until rising_edge(clk);
		a_t <= '0';
		a_f <= '1';
		b_t <= '0';
		b_f <= '1';
		c_in_t <= '0';
		c_in_f <= '1'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '1';
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '0';
		
		-- 1+0
		wait until rising_edge(clk);
		a_t <= '1';
		a_f <= '0';
		b_t <= '0';
		b_f <= '1';
		c_in_t <= '0';
		c_in_f <= '1'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '1';
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '0';
		
		-- 0+1
		wait until rising_edge(clk);
		a_t <= '0';
		a_f <= '1';
		b_t <= '1';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '1'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '1';
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '0';
		
		-- 1+1
		wait until rising_edge(clk);
		a_t <= '1';
		a_f <= '0';
		b_t <= '1';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '1'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '1';
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '0';
		
		-- carry in 1
		-- 0+0
		wait until rising_edge(clk);
		a_t <= '0';
		a_f <= '1';
		b_t <= '0';
		b_f <= '1';
		c_in_t <= '1';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '1';
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '0';
		
		-- 1+0
		wait until rising_edge(clk);
		a_t <= '1';
		a_f <= '0';
		b_t <= '0';
		b_f <= '1';
		c_in_t <= '1';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '1';
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '0';
		
		-- 0+1
		wait until rising_edge(clk);
		a_t <= '0';
		a_f <= '1';
		b_t <= '1';
		b_f <= '0';
		c_in_t <= '1';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '1';
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '0';
		
		-- 1+1
		wait until rising_edge(clk);
		a_t <= '1';
		a_f <= '0';
		b_t <= '1';
		b_f <= '0';
		c_in_t <= '1';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '1';
		a_t <= '0';
		a_f <= '0';
		b_t <= '0';
		b_f <= '0';
		c_in_t <= '0';
		c_in_f <= '0'; 
		wait until ((c_t xor c_f) and (c_out_t xor c_out_f)) = '0';
		
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
