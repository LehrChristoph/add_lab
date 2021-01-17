----------------------------------------------------------------------------------
-- MUX
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity mux is
  --generic for initializing the phase registers
  generic(DATA_WIDTH      : natural := DATA_WIDTH);
  port(
    rst             : in  std_logic; -- rst line
    -- Input from channel 1
    inA_req         : in  std_logic;
    inA_data        : in std_logic_vector(DATA_WIDTH-1 downto 0);
    inA_ack         : out std_logic;
    -- Input from channel 2
    inB_req         : in std_logic;
    inB_data        : in std_logic_vector(DATA_WIDTH-1 downto 0);
    inB_ack         : out std_logic;
    -- Output port
    outC_req        : out std_logic;
    outC_data       : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_ack        : in  std_logic;
    -- Select port
    inSel_req       : in std_logic;
    inSel_ack       : out std_logic;
    selector        : in std_logic_vector(0 downto 0)
	);
end mux;

architecture arch of mux is
  signal en : std_logic;

  signal int_in_ack : std_logic;

begin

  inA_ack <= int_in_ack and selector(0);
  inB_ack <= int_in_ack and (not selector(0));

  handshake : entity work.handshake_dual_input
  port map (
    rst => rst,
    inA_req => inA_req xor inB_req,
    inA_ack => int_in_ack,
    inB_req => inSel_req,
    inB_ack => inSel_ack,
    out_req => outC_req,
    out_ack => outC_ack,
    en => en
  );

  latch_data : process(rst, en)
  begin
    if rst = '1' then
      outC_data <= (others => '0');
    elsif rising_edge(en) then
      if selector(0) = '1' then
        outC_data <= inA_data;
      else
        outC_data <= inB_data;
      end if;
    end if;
  end process;


end arch;
