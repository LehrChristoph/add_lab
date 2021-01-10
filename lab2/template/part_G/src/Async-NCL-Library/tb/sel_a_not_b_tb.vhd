----------------------------------------------------------------------------------
-- Select A not equal B Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;
use std.env.stop;

entity sel_a_not_b_tb is
	
	constant CLK_PERIOD : time := 10 ns;
	constant stop_clock : boolean := false;
	
	signal clk :    std_logic;
	signal reset :    std_logic;
	signal AB_t, AB_f: std_logic_vector(5 downto 0);
	signal selector_t, selector_f: std_logic;
	signal selector_ack_out, selector_ack_in : std_logic;
end sel_a_not_b_tb;

architecture beh of sel_a_not_b_tb is
begin

	sel_a_not_b_test : entity work.sel_a_not_b
	generic map(
		DATA_WIDTH => 6
	)
	port map(
		-- Flags
		rst 				=> reset,
		ack_in			=> selector_ack_in,
		ack_out			=> selector_ack_out,
		-- Input channel
		in_data_t     => AB_t,
		in_data_f     => AB_f,
		-- Output channel
		selector_t    => selector_t,
		selector_f    => selector_f
	);
	
	sel_a_not_b_stimuli : process
		variable iterator_1, iterator_2: integer := 0 ;
		variable expected_selector_t, expected_selector_f : std_logic;
	begin		
		wait until rising_edge(clk);
		AB_t <= "000000";
		AB_f <= "000000";
		selector_ack_in <= '0';
		
		while iterator_1 < 8 loop
			iterator_2 := 0; 
			while iterator_2 < 8 loop
				wait until rising_edge(clk);
				AB_t(5 downto 3) <= std_logic_vector(to_unsigned(iterator_1, 3));
				AB_t(2 downto 0) <= std_logic_vector(to_unsigned(iterator_2, 3));
				AB_f(5 downto 3) <= not std_logic_vector(to_unsigned(iterator_1, 3));
				AB_f(2 downto 0) <= not std_logic_vector(to_unsigned(iterator_2, 3));
				wait until (selector_t or selector_f) = '1';
				
				expected_selector_t := '1' when iterator_1 /= iterator_2 else '0';
				expected_selector_f := '1' when iterator_1  = iterator_2 else '0';
				
				assert( selector_t = expected_selector_t and selector_f = expected_selector_f )
				report
					"" & to_string(iterator_1) & " < " & to_string(iterator_2) & lf &
					"got selector_t: " & to_string(selector_t) & " selector_f: " & to_string(selector_f) & lf &
					"expected selector_t: " & to_string(expected_selector_t) & " selector_f: " & to_string(expected_selector_f) & lf
				severity error;
				
				selector_ack_in <= '1';
				wait for 2 ns;
				AB_t <= (others => '0');
				AB_f <= (others => '0');
				selector_ack_in <= '0';
				wait until selector_ack_out= '0';
				iterator_2 := iterator_2 +1; 
			end loop;
			iterator_1 := iterator_1 +1;
		end loop;
		wait until rising_edge(clk);
		wait until rising_edge(clk);
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