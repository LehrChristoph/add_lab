----------------------------------------------------------------------------------
--LCM Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity LCM_tb is
	
	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal A, B : std_logic_vector(3 downto 0);
	signal A_deb, B_deb : std_logic_vector(3 downto 0);
	signal req_AB: std_logic;
	signal ack_AB: std_logic;
	signal result: std_logic_vector(7 downto 0);
	signal req_result: std_logic;
	signal ack_result: std_logic;
end LCM_tb;

architecture beh of LCM_tb is

	component LCM_top is
 	port(
		clk: in std_logic;
		res_n: in std_logic;
		A, B : in std_logic_vector(3 downto 0);
		A_deb, B_deb : out std_logic_vector(3 downto 0);
		req_AB: in std_logic;
		ack_AB: out std_logic;
		result: out std_logic_vector(7 downto 0);
		req_result: out std_logic;
		ack_result: in std_logic
	);
	end component LCM_top;
begin
	
	lcm: entity work.LCM_top
   	port map(
		clk => clk,
		res_n => reset,
		A => A,
		B => B,
		A_deb => A_deb, 
		B_deb => B_deb,
		req_AB => req_AB,
		ack_AB => ack_AB,
		result => result,
		req_result => req_result,
		ack_result => ack_result
	);
	
	lcm_stimuli : process
		variable iteration : integer := 0 ;
		variable A_temp, B_temp : integer;
	begin
		req_AB <= '0';
		ack_result <= '0';
		
		wait until rising_edge(clk);

		A_temp := 2;
		B_temp := 3;

		A <= std_logic_vector(to_unsigned(A_temp, 4));		
		B <= std_logic_vector(to_unsigned(B_temp, 4));
		
		wait until rising_edge(clk);
		req_AB <= '1';
		wait until ack_AB = '1';
		
		wait until req_result = '1';
		iteration := iteration +1;
	end process;
	
	generate_clk : process
	begin
		reset <= '0';
		clk <= '0';
		wait for CLK_PERIOD;
		reset <= '1';
			while not stop_clock loop
				clk <= '0', '1' after CLK_PERIOD / 2;
				wait for CLK_PERIOD;
			end loop;
		wait;
	end process;
	
end architecture;
