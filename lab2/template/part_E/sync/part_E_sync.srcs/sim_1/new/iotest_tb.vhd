LIBRARY ieee;
USE ieee.std_logic_1164.ALL
;
ENTITY iotest_tb IS
END iotest_tb;


ARCHITECTURE behavior OF iotest_tb IS

 component top is
  port(
    clk, res_n : in std_logic;
    error_led, heartbeat_led : out std_logic
    );
 end component;
 
 signal clk, res_n, error_led :std_logic:='0';
 signal seq_cnt : std_logic_vector(31 downto 0);
 constant clk_period :time:= 8ns;
 signal stop : std_logic := '0';
BEGIN


 uut: top PORT MAP (
 clk => clk,
 res_n => res_n,
 error_led => error_led,
 heartbeat_led => open
 );
 
 
 clk_process :process
 begin
 clk <='0';
 wait for clk_period/2;
 clk <='1';
 wait for clk_period/2;
 
 if stop = '1' then
    wait;
 end if;
    
 end process;
 
 stim_proc :process
 begin
    res_n <='0';
    wait for 10*clk_period;
    
    res_n <= '1';
    
    wait for 1_000_000*clk_period;
 
    stop <= '1';
    wait;
 end process;
END;
