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
	signal result: std_logic_vector(15 downto 0);
	signal ready: std_logic;
	signal done: std_logic;
	signal valid: std_logic;
	signal AB : std_logic_vector(15 downto 0);
	
	type type_array is array(0 to 3) of integer;
	signal A_test_data : type_array :=  ( 64, 28, 33,8);
	signal B_test_data : type_array :=  ( 13,  7, 44,8);
	signal control_data : type_array := (832, 28,132,8);

end LCM_tb;

architecture beh of LCM_tb is

	component lcm is	
		generic ( DATA_WIDTH : natural);
		port (
			clk: in std_logic;
			res_n: in std_logic;
			AB : in std_logic_vector(DATA_WIDTH-1 downto 0);
			ready : in std_logic;
			done : out std_logic;
			result: out std_logic_vector(DATA_WIDTH-1 downto 0);
			valid: out std_logic
		);
	end component lcm;

begin
	
	
	lcm_calc: component lcm
	generic map ( 
		DATA_WIDTH => 16
	)
	port map(
		clk	=> clk,
		res_n	=> reset,
		AB 	=> AB,
		ready => ready,
		done 	=> done,
		result=> result,
		valid	=> valid
	);
	
	lcm_stimuli : process
		variable iteration : integer := 0 ;
		variable A_temp, B_temp : integer;
		variable var_reqAB : std_logic := '0';
		variable var_ackRes : std_logic := '0';
	begin		
		while iteration < 5 loop
		
			wait until rising_edge(clk);

			A_temp := A_test_data(iteration);
			B_temp := B_test_data(iteration);

			A <= std_logic_vector(to_unsigned(A_temp, 8));		
			B <= std_logic_vector(to_unsigned(B_temp, 8));
			AB(15 downto 8) <= std_logic_vector(to_unsigned(A_temp, 8));
			AB( 7 downto 0) <= std_logic_vector(to_unsigned(B_temp, 8));
		
			wait until rising_edge(clk);
			ready <= '1';
			
			wait until done = '1';
			ready <= '0';
			
			wait until rising_edge(clk);

			AB <= (others => '0');
			ready <= '1';
			
			wait until done = '1';
			ready <= '0';
			
			wait until valid = '1';
			assert(result = std_logic_vector(to_unsigned( control_data(iteration), 16)))
				report
					"lcm of " & to_string(A_temp) & " and " & to_string(B_temp) & lf &
					"got " & to_string(result) & lf &
					"expected " & to_string(control_data(iteration)) & lf
				severity error;
			wait until rising_edge(clk);
			iteration := iteration +1;
			
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
