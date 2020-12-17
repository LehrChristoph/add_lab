----------------------------------------------------------------------------------
--LCM Test-Bench
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.defs.all;

entity LCM_tb is

end LCM_tb;

architecture STRUCTURE of LCM_tb is

signal result: std_logic_vector(DATA_WIDTH_IF-1 downto 0);
signal A: std_logic_vector(DATA_WIDTH_IF/2-1 downto 0);
signal B: std_logic_vector(DATA_WIDTH_IF/2-1 downto 0);
signal rst: std_logic;
signal req_AB, ack_AB, req_result, ack_result: std_logic;
signal A_result, B_result: std_logic_vector(DATA_WIDTH_IF/2-1 downto 0);

  constant delay : TIME := 10 ns;

  component LCM is
  port (
    A : in std_logic_vector ( DATA_WIDTH_IF/2-1 downto 0 );
    B : in std_logic_vector ( DATA_WIDTH_IF/2-1 downto 0 );    
    result : out std_logic_vector ( DATA_WIDTH_IF-1 downto 0 );
    rst : in std_logic;
    i_req:  in std_logic;
    i_ack:  out std_logic;
    o_req: out std_logic;
    o_ack: in std_logic
    );
  end component LCM;
begin

  process
  begin

    ack_result <= '0';
    req_AB <= '0';
    rst <= '1';
    A <= std_logic_vector(to_unsigned(0,DATA_WIDTH_IF/2));
    B <= std_logic_vector(to_unsigned(0,DATA_WIDTH_IF/2));
   
    wait for 100 ns;

    rst <= '0';
    
    wait for 100 ns;

    ------------------------------------------------------
    
    A <= std_logic_vector(to_unsigned(64,DATA_WIDTH_IF/2));
    B <= std_logic_vector(to_unsigned(13,DATA_WIDTH_IF/2));
    req_AB <= '1';
    
    wait until ( ack_AB = '1');   
   
    wait until req_result = '1';
    assert (result = std_logic_vector(to_unsigned(832,DATA_WIDTH_IF)))
      report "wrong LCM of 64 and 13 computed"
      severity error;
    ack_result <= '1' after delay;

    ------------------------------------------------------
    
    A <= std_logic_vector(to_unsigned(28,DATA_WIDTH_IF/2));
    B <= std_logic_vector(to_unsigned(7,DATA_WIDTH_IF/2));
    req_AB <= '0';
    
    wait until ( ack_AB = '0');   
   
    wait until req_result = '0';
    assert (result = std_logic_vector(to_unsigned(28,DATA_WIDTH_IF)))
      report "wrong LCM of 7 and 28 computed"
      severity error;
    ack_result <= '0' after delay;

    ------------------------------------------------------
    
    A <= std_logic_vector(to_unsigned(44,DATA_WIDTH_IF/2));
    B <= std_logic_vector(to_unsigned(33,DATA_WIDTH_IF/2));
    req_AB <= '1';
    
    wait until ( ack_AB = '1');   
   
    wait until req_result = '1';
    assert (result = std_logic_vector(to_unsigned(132,DATA_WIDTH_IF)))
      report "wrong LCM of 44 and 33 computed"
      severity error;
    ack_result <= '1' after delay;
    
    ------------------------------------------------------

    A <= std_logic_vector(to_unsigned(8,DATA_WIDTH_IF/2));
    B <= std_logic_vector(to_unsigned(8,DATA_WIDTH_IF/2));
    req_AB <= '0';
    
    wait until ( ack_AB = '0');   
   
    wait until req_result = '0';
    assert (result = std_logic_vector(to_unsigned(16,DATA_WIDTH_IF)))
      report "wrong LCM of 8 and 8 computed"
      severity error;
    ack_result <= '0' after delay;
    
    ------------------------------------------------------
       
    wait for 10 ns;

    wait;
    

  end process;
  
  
LCM_module: component LCM
     port map (
       A => A,
       B => B,
      result => result,
      rst => rst,
      i_req => req_ab,
      i_ack => ack_ab,
      o_req => req_result,
      o_ack => ack_result
    );

end STRUCTURE;
