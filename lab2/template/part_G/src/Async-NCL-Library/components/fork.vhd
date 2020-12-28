----------------------------------------------------------------------------------
-- Fork
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity fork is
  generic ( 
    PHASE_INIT  : std_logic := '0');
  port(
   rst          : in std_logic;
   -- Input channel
   inA_ack      : out std_logic;
   -- Output channel 1
   outB_ack     : in std_logic;
   -- Output channel 2
   outC_ack     : in std_logic
  );
end fork;

architecture arch of fork is
begin

	c_element_inst_f : entity work.c_element
		port map(
			in1 => outB_ack,
			in2 => outC_ack,
			out1 => inA_ack
		);
end arch;