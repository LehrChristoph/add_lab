----------------------------------------------------------------------------------
-- Join
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity join is
  generic(
    PHASE_INIT  : std_logic := '0'
    );
  port (
    rst         : in std_logic;
    --UPSTREAM channels
    inA_ack     : out std_logic;
    inB_ack     : out std_logic;
    --DOWNSTREAM channel
    outC_ack    : in std_logic);
end join;

architecture Behavioral of join is
signal connect: std_logic; -- signal for constraining i/o (needed only for post-timing simulation)
signal click, phase: std_logic;

attribute dont_touch : string;
attribute dont_touch of phase : signal is "true";
attribute dont_touch of  click : signal is "true";
attribute dont_touch of  connect : signal is "true";

begin                       
  inA_ack <= outC_ack;   
  inB_ack <= outC_ack;
 end Behavioral;