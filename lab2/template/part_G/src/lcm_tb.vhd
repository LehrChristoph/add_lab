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
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal A, B : std_logic_vector(7 downto 0);
	signal ack_AB: std_logic;
	signal result_t, result_f: std_logic_vector(15 downto 0);
	signal ack_result: std_logic;
	signal AB_t, AB_f : std_logic_vector(15 downto 0);
	signal complete : std_logic;
	
	type type_array is array(0 to 4) of integer;
	signal A_test_data : type_array :=  (2,  64, 28, 33,8);
	signal B_test_data : type_array :=  (3,  13,  7, 44,8);
	signal control_data : type_array := (6, 832, 28,132,8);
	
end LCM_tb;

architecture beh of LCM_tb is

begin
	
	
	lcm_calc: entity work.lcm
	generic map ( 
		DATA_WIDTH => 16
	)
	port map(
		AB_t 		=> AB_t,
		AB_f 		=> AB_f,
		RESULT_t => result_t,
		RESULT_f => result_f,
		rst   	=> reset,
		ack_in	=> ack_result,
		ack_out	=> ack_AB
	);
	
	cd_test : entity work.completion_detector
	generic map ( DATA_WIDTH => 16)
	port map(
		data_t => result_t,
		data_f => result_f,
		rst => reset,
		complete => complete
	);
	
	
	lcm_stimuli : process
		variable iteration : integer := 0 ;
		variable A_temp, B_temp : integer;
		variable var_reqAB : std_logic := '0';
		variable var_ackRes : std_logic := '0';
	begin		
		while iteration < 5 loop

			ack_result <= var_ackRes;
		
			wait until rising_edge(clk);

			A_temp := A_test_data(iteration);
			B_temp := B_test_data(iteration);

			A <= std_logic_vector(to_unsigned(A_temp, 8));		
			B <= std_logic_vector(to_unsigned(B_temp, 8));
			AB_t(15 downto 8) <= std_logic_vector(to_unsigned(A_temp, 8));
			AB_t( 7 downto 0) <= std_logic_vector(to_unsigned(B_temp, 8));
		
			AB_f(15 downto 8) <= not std_logic_vector(to_unsigned(A_temp, 8));
			AB_f( 7 downto 0) <= not std_logic_vector(to_unsigned(B_temp, 8));
			
			wait until ack_AB = '1';
			
			AB_t <= (others => '0');
			AB_f <= (others => '0');
			
			wait until ack_AB = '0';
			
			wait until ack_AB = '0';
			wait until complete = '1';
			
			assert(result_t = std_logic_vector(to_unsigned( control_data(iteration), 16)))
				report
					"lcm of " & to_string(A_temp) & " and " & to_string(B_temp) & lf &
					"got " & to_string(result_t) & lf &
					"expected " & to_string(control_data(iteration)) & lf
				severity error;
				
			wait until rising_edge(clk);

			

			iteration := iteration +1;

			wait until rising_edge(clk);
			
			wait;
		end loop;
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
