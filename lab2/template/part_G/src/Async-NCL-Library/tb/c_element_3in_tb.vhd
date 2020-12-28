----------------------------------------------------------------------------------
-- 3 input C-Element Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;

entity c_element_3in_tb is
	
	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal a,b,c,d : std_logic;
	
	type type_array is array(0 to 3) of integer;
	signal A_test_data : type_array :=  ( 64, 28, 33,8);
	signal B_test_data : type_array :=  ( 13,  7, 44,8);
	signal control_data : type_array := (832, 28,132,8);

end c_element_3in_tb;

architecture beh of c_element_3in_tb is

	component c_element_3in is 
		port(
			in1, in2, in3 : in std_logic;
			out1 : out std_logic
		);
	end component;
	
begin
	
	
	c_element_inst_inA_ack : c_element_3in
	port map
		(
			in1 => a,
			in2 => b,
			in3 => c,
			out1 => d
		);
	
	lcm_stimuli : process
	begin	

		wait until rising_edge(clk);
		a <= '0';
		
		wait until rising_edge(clk);
		b <= '0';
		
		wait until rising_edge(clk);
		c <= '0';
	
		wait until rising_edge(clk);
		a <= '1';
		
		wait until rising_edge(clk);
		b <= '1';
		
		wait until rising_edge(clk);
		c <= '1';
		
		wait until rising_edge(clk);
		c <= '0';
		
		wait until rising_edge(clk);
		b <= '0';
		
		wait until rising_edge(clk);
		a <= '0';
		
		wait until rising_edge(clk);
		a <= '1';
		
		wait until rising_edge(clk);
		a <= '0';
		
		wait until rising_edge(clk);
		b <= '1';
		
		wait until rising_edge(clk);
		b <= '0';
		
		wait until rising_edge(clk);
		c <= '1';
		
		wait until rising_edge(clk);
		c <= '0';
		
		wait until rising_edge(clk);
		a <= '1';
		
		wait until rising_edge(clk);
		b <= '1';
		
		wait until rising_edge(clk);
		b <= '0';
		
		wait until rising_edge(clk);
		a <= '0';
		
		wait until rising_edge(clk);
		a <= '1';
		
		wait until rising_edge(clk);
		c <= '1';
		
		wait until rising_edge(clk);
		c <= '0';
		
		wait until rising_edge(clk);
		a <= '0';
		
		wait until rising_edge(clk);
		b <= '1';
		
		wait until rising_edge(clk);
		c <= '1';
		
		wait until rising_edge(clk);
		c <= '0';
		
		wait until rising_edge(clk);
		b <= '0';
		
		
		
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
