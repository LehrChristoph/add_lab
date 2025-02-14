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
  signal en, enA, enB : std_logic;

  signal outC_reqA, outC_reqB : std_logic;
  signal inSel_ackA, inSel_ackB : std_logic;

  signal int_in_ack : std_logic;

  attribute keep : boolean;
  attribute keep of en, enA, enB : signal is true;

begin
  outC_req <= outC_reqA or outC_reqB;
  inSel_ack <= inSel_ackA or inSel_ackB;

  handshakeA : entity work.handshake_dual_input
  port map (
    rst => rst,
    inA_req => inA_req,
    inA_ack => inA_ack,
    inB_req => inSel_req,
    inB_ack => inSel_ackA,
    out_req => outC_reqA,
    out_ack => outC_ack,
    en => enA
  );
  handshakeB : entity work.handshake_dual_input
  port map (
    rst => rst,
    inA_req => inB_req,
    inA_ack => inB_ack,
    inB_req => inSel_req,
    inB_ack => inSel_ackB,
    out_req => outC_reqB,
    out_ack => outC_ack,
    en => enB
  );

  en <= enA or enB;
  latch_data : process(rst, en, inA_data, inB_data, selector)
  begin
    if rst = '1' then
      outC_data <= (others => '0');
    elsif en = '1' then
      if selector(0) = '1' then
        outC_data <= inA_data after REG_CQ_DELAY;
      else
        outC_data <= inB_data after REG_CQ_DELAY;
      end if;
    end if;
  end process;


end arch;
