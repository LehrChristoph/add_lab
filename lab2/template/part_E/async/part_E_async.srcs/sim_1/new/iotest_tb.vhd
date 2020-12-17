LIBRARY ieee;
USE ieee.std_logic_1164.ALL
;
ENTITY iotest_tb IS
END iotest_tb;


ARCHITECTURE behavior OF iotest_tb IS

 component top is
  generic(
   valA : natural := 50_171;
   valB : natural := 59_299
   );
  port(
    clk, res, rx : in std_logic;
    error_led, heartbeat_led : out std_logic;
    tx : out std_logic
    );
 end component;
 
 signal clk, res, error_led :std_logic:='0';
 signal heartbeat_led : std_logic;
 
 constant clk_period :time:=8 ns;
BEGIN


 uut: top
 generic map(
    valA => 4,
    valB => 5
 )
 PORT MAP (
 clk => clk,
 res => res,
 error_led => error_led,
 heartbeat_led => heartbeat_led,
 rx => '1',
 tx => open
 );
 
 
 clk_process :process
 begin
 clk <='0';
 wait for clk_period/2;
 clk <='1';
 wait for clk_period/2;
   
 end process;
 
 stim_proc :process
 begin
    res <='1';
    wait for 100*clk_period;
    
    res <= '0';
    
    wait for 10ms;
 
    wait;
 end process;
END;
