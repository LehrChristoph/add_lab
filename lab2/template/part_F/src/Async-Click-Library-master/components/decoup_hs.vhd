----------------------------------------------------------------------------------
-- Decoupled handshake register
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity decoupled_hs_reg is
  generic (
    DATA_WIDTH      : natural := DATA_WIDTH;
    VALUE           : natural  := 0;
    INIT_REQUEST    : std_logic := '0'
    );
  port (rst         : in std_logic;
    -- Input channel
    in_ack          : out std_logic;
    in_req          : in std_logic;
    in_data         : in std_logic_vector(DATA_WIDTH-1 downto 0);
    -- Output channel
    out_req         : out std_logic;
    out_data        : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_ack         : in std_logic);
end decoupled_hs_reg;

architecture behavioral of decoupled_hs_reg is

  signal en : std_logic;
  attribute keep : boolean;
  attribute keep of en : signal is true;

begin
  handshake_inst : entity work.handshake
  generic map(
    INIT_STATE => INIT_REQUEST
  )
  port map (
    rst => rst,
    in_req => in_req,
    in_ack => in_ack,
    out_req => out_req,
    out_ack => out_ack,
    en => en
  );

  clock_regs: process(en, rst, in_data)
  begin
    if rst = '1' then
      out_data <= std_logic_vector(to_unsigned(VALUE, DATA_WIDTH));
    elsif en = '1' then
      out_data <= in_data after REG_CQ_DELAY;
    end if;
  end process;

end behavioral;