----------------------------------------------------------------------------------
--LCM Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;

entity LCM_tb is

	constant CLK_PERIOD : time := 10 ns;

	signal clk :    std_logic;
	signal reset :    std_logic;
	signal A, B : std_logic_vector(7 downto 0);
	signal req_AB: std_logic;
	signal ack_AB: std_logic;
	signal result: std_logic_vector(15 downto 0);
	signal req_result: std_logic;
	signal ack_result: std_logic;

	type type_array is array(0 to 3) of integer;
	signal A_test_data : type_array :=  ( 64, 28, 33, 8);
	signal B_test_data : type_array :=  ( 13,  7, 44, 8);
	signal control_data : type_array := (832, 28,132,16);
	signal stop_clock : boolean := false;

end LCM_tb;

architecture beh of LCM_tb is

begin


	lcm_calc: entity work.lcm
	generic map (
		DATA_WIDTH => 16
	)
	port map(
		A => A,
		B => B,
		RESULT => result,
		rst => reset,
		i_req => req_AB,
		i_ack => ack_AB,
		o_req => req_result,
		o_ack => ack_result
	);

	lcm_stimuli : process
		variable iteration : integer := 0 ;
		variable A_temp, B_temp : integer;
		variable var_reqAB : std_logic := '0';
		variable var_ackRes : std_logic := '0';
	begin
		while iteration < A_test_data'LENGTH loop
			req_AB <= var_reqAB;
			ack_result <= var_ackRes;

			wait until rising_edge(clk);

			A_temp := A_test_data(iteration);
			B_temp := B_test_data(iteration);

			A <= std_logic_vector(to_unsigned(A_temp, 8));
			B <= std_logic_vector(to_unsigned(B_temp, 8));

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
		wait for CLK_PERIOD*10;
		stop_clock <= true;
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
