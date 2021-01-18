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

end LCM_tb;

architecture beh of LCM_tb is
    constant DATA_WIDTH : natural := 8;
    constant CLK_PERIOD : time := 10 ns;

    function lcm_func(A : natural; B: natural)
        return natural is
        variable sumA, sumB : natural := 0;
    begin
        sumA := A;
        sumB := B;

        if A = B then
            sumA := sumA + A;
        end if;

        while sumA /= sumB loop
            if sumA < sumB then
                sumA := sumA + A;
            else
                sumB := sumB + B;
            end if;
        end loop;

        return sumA;
    end lcm_func;

    signal clk :    std_logic;
    signal reset :    std_logic;
    signal A, B : std_logic_vector(DATA_WIDTH/2-1 downto 0);
    signal req_AB: std_logic;
    signal ack_AB: std_logic;
    signal result: std_logic_vector(DATA_WIDTH-1 downto 0);
    signal req_result: std_logic;
    signal ack_result: std_logic;

    type type_array is array(0 to 3) of natural;
    signal A_test_data : type_array :=  ( 2, 12, 5,12);
    signal B_test_data : type_array :=  ( 3,  7, 7, 9);
    signal control_data : type_array := ( 6, 84,35,36);
    signal stop_clock : boolean := false;
begin


    lcm_calc: entity work.lcm_top
    port map(
        A => A,
        B => B,
        clk => clk,
        RESULT => result,
        res_n => not reset,
        req_AB => req_AB,
        ack_AB => ack_AB,
        req_result => req_result,
        ack_result => ack_result
    );

    lcm_stimuli : process
        variable A_temp, B_temp, expected : natural;
    begin
        A <= (others => '0');
        B <= (others => '0');
        for A_temp in 1 to 15 loop
            for B_temp in 1 to 15 loop
                req_AB <= '0';
                ack_result <= '0';

                wait for 100 ns;
                wait until rising_edge(clk);

                A <= std_logic_vector(to_unsigned(A_temp, DATA_WIDTH/2));
                B <= std_logic_vector(to_unsigned(B_temp, DATA_WIDTH/2));
                expected := beh.lcm_func(A_temp,B_temp);

                wait for 100 ns;
                wait until rising_edge(clk);
                req_AB <= '1';
                wait until ack_AB = '1';
                wait for 100 ns;
                req_AB <= '0';
                wait until ack_AB = '0' or req_result = '1';

                if ack_AB /= '0' or req_result /= '1' then
                    wait until ack_AB = '0' or req_result = '1';
                end if;

                wait for 100 ns;
                assert(result = std_logic_vector(to_unsigned( expected, DATA_WIDTH)))
                    report
                        "lcm of " & to_string(A_temp) & " and " & to_string(B_temp) & lf &
                        "got " & to_string(to_integer(unsigned(result))) & lf &
                        "expected " & to_string(expected) & lf
                    severity error;
                ack_result <= '1';
                wait until req_result = '0';
                wait for 100 ns;
                ack_result <= '0';

                wait for 100 ns;
            end loop;
        end loop;
        wait for CLK_PERIOD*10;
        stop_clock <= true;
        wait;
    end process;

    generate_clk : process
    begin
        reset <= '1';
        clk <= '0';
        wait for 50 ns;
        reset <= '0';

        while not stop_clock loop
            clk <= '0', '1' after CLK_PERIOD / 2;
            wait for CLK_PERIOD;
        end loop;
        wait;
    end process;

end architecture;
