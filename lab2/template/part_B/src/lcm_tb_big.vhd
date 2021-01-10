----------------------------------------------------------------------------------
--LCM Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library std; -- for Printing
use std.textio.all;
use ieee.std_logic_textio.all;

entity LCM_tb_big is

    constant DATA_WIDTH : natural := 32;
    constant CLK_PERIOD : time := 2.75 ns;

    signal cycle_count : natural;

    signal clk :    std_logic;
    signal reset :  std_logic;
    signal A,B :  std_logic_vector(DATA_WIDTH/2 - 1 downto 0);
    signal result: std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ready: std_logic;
    signal done: std_logic;
    signal valid: std_logic;
    signal AB : std_logic_vector(DATA_WIDTH-1 downto 0);

    type type_array is array(0 to 3) of integer;
    signal A_test_data : type_array :=  ( 64, 28, 33, 8);
    signal B_test_data : type_array :=  ( 13,  7, 44, 8);
    signal control_data : type_array := (832, 28,132,16);
    signal stop_clock : boolean := false;

end LCM_tb_big;

architecture beh of LCM_tb_big is

begin
    A <= std_logic_vector(to_unsigned(50_171,DATA_WIDTH/2));
    B <= std_logic_vector(to_unsigned(59_299,DATA_WIDTH/2));
    lcm_calc: entity work.lcm
    generic map (
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        clk     => clk,
        res_n   => not reset,
        A       => A,
        B       => B,
        ready   => ready,
        done    => done,
        result  => result,
        valid   => valid
    );

    lcm_stimuli : process
    begin
        wait until rising_edge(clk);
        ready <= '1';

        wait until done = '1';
        ready <= '0';


        wait until valid = '1';

        assert(result = x"B15445D1")
            report
                "lcm of " & to_string(A) & " and " & to_string(B) & lf &
                "got " & to_string(to_integer(unsigned(result))) & lf &
                "expected " & to_string(x"B15445D1") & lf
            severity error;
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
            clk <= not clk;

            if clk = '1' then
                cycle_count <= cycle_count+1;
            end if;

            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

end architecture;
