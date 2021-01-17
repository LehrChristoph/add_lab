----------------------------------------------------------------------------------
-- Demux
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity demux is
  generic(
    DATA_WIDTH    : natural := DATA_WIDTH
  );
  port(
    rst           : in  std_logic;
    -- Input port
    inA_req       : in  std_logic;
    inA_data      : in std_logic_vector(DATA_WIDTH-1 downto 0);
    inA_ack       : out std_logic;
    -- Select port
    inSel_req     : in  std_logic;
    inSel_ack     : out std_logic;
    selector      : in std_logic;
    -- Output channel 1
    outB_req      : out std_logic;
    outB_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outB_ack      : in  std_logic;
    -- Output channel 2
    outC_req      : out std_logic;
    outC_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_ack      : in  std_logic
    );
end demux;

architecture Behavioral of demux is

  signal en : std_logic;
  signal int_out_req : std_logic;

begin
  outB_req <= int_out_req and selector;
  outC_req <= int_out_req and (not selector);

  handshake_in : entity work.handshake_dual_input
  port map (
    rst => rst,
    inA_req => inA_req,
    inA_ack => inA_ack,
    inB_req => inSel_req,
    inB_ack => inSel_ack,
    out_req => int_out_req,
    out_ack => outB_ack xor outC_ack,
    en => en
  );

  req : process(en, rst)
    begin
      if rst = '1' then
        outB_data <= (others => '0');
        outC_data <= (others => '0');
      elsif rising_edge(en) then
        outB_data <= inA_data;
        outC_data <= inA_data;
      end if;
    end process req;

end Behavioral;
