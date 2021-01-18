----------------------------------------------------------------------------------
-- Merge
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity merge is
  generic(
    DATA_WIDTH    : natural := DATA_WIDTH
  );
  port (rst   : in std_logic;
    --Input channel 1
    inA_req   : in std_logic;
    inA_ack   : out std_logic;
    inA_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
    -- Input channel 2
    inB_req   : in std_logic;
    inB_ack   : out std_logic;
    inB_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
    -- Output channel
    outC_req  : out std_logic;
    outC_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_ack  : in std_logic
    );
end merge;

architecture Behavioral of merge is

  signal enA, enB : std_logic;
  signal outC_reqA : std_logic;
  signal outC_reqB : std_logic;
  signal en : std_logic;

  attribute keep : boolean;
  attribute keep of enA, enB, en : signal is true;

begin

  outC_req <= outC_reqA xor outC_reqB;

  handshake_A : entity work.handshake
  port map (
    rst => rst,
    in_req => inA_req,
    in_ack => inA_ack,
    out_req => outC_reqA,
    out_ack => outC_ack,
    en => enA
  );
  handshake_B : entity work.handshake
  port map (
    rst => rst,
    in_req => inB_req,
    in_ack => inB_ack,
    out_req => outC_reqB,
    out_ack => outC_ack,
    en => enB
  );

  en <= enA or enB;

  memory_proc : process(en, rst)
    begin
      if rst = '1' then
        outC_data <= (others => '0');
      elsif rising_edge(en) then
        if inA_req = '1' then
          outC_data <= inA_data;
        else
          outC_data <= inB_data;
        end if;
      end if;
    end process;

end Behavioral;
