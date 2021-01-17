----------------------------------------------------------------------------------
-- Fork
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity fork is
  port(
   rst          : in std_logic;
   -- Input channel
   inA_req      : in std_logic;
   inA_ack      : out std_logic;
   -- Output channel 1
   outB_req     : out std_logic;
   outB_ack     : in std_logic;
   -- Output channel 2
   outC_req     : out std_logic;
   outC_ack     : in std_logic
  );
end fork;

architecture arch of fork is
begin
  handshake_inst : entity work.handshake_dual_output
  port map (
    rst => rst,
    in_req => inA_req,
    in_ack => inA_ack,
    outA_req => outB_req,
    outA_ack => outB_ack,
    outB_req => outC_req,
    outB_ack => outC_ack,
    en => open
  );

end arch;