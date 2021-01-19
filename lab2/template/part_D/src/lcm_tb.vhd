----------------------------------------------------------------------------------
--LCM Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use std.env.stop;
use ieee.std_logic_textio.all;

use ieee.std_logic_unsigned.all;
use work.defs.all;
use work.click_element_library_constants.all;

entity LCM_tb is

	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal A, B : std_logic_vector(7 downto 0);
	signal req_AB: std_logic;
	signal ack_AB: std_logic;
	signal result: std_logic_vector(15 downto 0);
	signal req_result: std_logic;
	signal ack_result: std_logic;
	signal AB : std_logic_vector(15 downto 0);
	
	type type_array is array(0 to 3) of integer;
	signal A_test_data : type_array :=  (64, 28, 33,8);
	signal B_test_data : type_array :=  (13,  7, 44,8);
	signal control_data : type_array := (832, 28,132,8);


end LCM_tb;

architecture beh of LCM_tb is


begin

	 lcm_calc: entity work.Scope(LCM)
	 generic map(
	 DATA_WIDTH => LCM_DATA_WIDTH,
	 OUT_DATA_WIDTH => LCM_OUT_DATA_WIDTH,
	 IN_DATA_WIDTH => LCM_IN_DATA_WIDTH
	 )
	 port map (
	 rst => reset,
	 -- Input channel
	 in_ack => ack_AB,
	 in_req => req_AB,
	 in_data => AB,
	 -- Output channel
	 out_req => req_result,
	 out_data => result,
	 out_ack => ack_result
	 );

	lcm_stimuli : process
		variable iteration : integer := 0 ;
		variable A_temp, B_temp : integer;
		variable var_reqAB : std_logic := '0';
		variable var_ackRes : std_logic := '0';
	begin		
		while iteration < 5 loop
			req_AB <= var_reqAB;
			ack_result <= var_ackRes;
		
			wait until rising_edge(clk);

			A_temp := A_test_data(iteration);
			B_temp := B_test_data(iteration);

			A <= std_logic_vector(to_unsigned(A_temp, 8));		
			B <= std_logic_vector(to_unsigned(B_temp, 8));
			AB(15 downto 8) <= std_logic_vector(to_unsigned(A_temp, 8));
			AB( 7 downto 0) <= std_logic_vector(to_unsigned(B_temp, 8));
		
			wait until rising_edge(clk);
			var_reqAB := not var_reqAB;
			req_AB <= var_reqAB;
			wait until ack_AB = var_reqAB;
		
			wait until req_result = req_AB;
			assert(result = std_logic_vector(to_unsigned( control_data(iteration), 16)))
				report
					"lcm of " & to_string(A_temp) & " and " & to_string(B_temp) & lf &
					"got " & to_string(result) & lf &
					"expected " & to_string(control_data(iteration)) & lf
				severity error;
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			wait until rising_edge(clk);

			ack_result <= req_result;
			var_ackRes := req_result;
			var_reqAB := req_result;

			iteration := iteration +1;

			wait until rising_edge(clk);
			wait until rising_edge(clk);
			wait until rising_edge(clk);
		end loop;
		stop;
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
