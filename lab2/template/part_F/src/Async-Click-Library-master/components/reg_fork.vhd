----------------------------------------------------------------------------------
-- Register+Forq
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity reg_fork is
  generic (
    DATA_WIDTH: natural := DATA_WIDTH
  );
  Port (
    rst : in std_logic;
    --Input channel
    inA_req     : in std_logic;
    inA_data    : in std_logic_vector(DATA_WIDTH-1 downto 0);
    inA_ack     : out std_logic;
    --Output channel 1
    outB_req    : out std_logic;
    outB_data   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outB_ack    : in std_logic;
    --Output channel 2
    outC_req    : out std_logic;
    outC_data   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_ack    : in std_logic );
  end reg_fork;

architecture Behavioral of reg_fork is

signal en: std_logic;
begin
  handshake : entity work.handshake_dual_output
  port map (
    rst => rst,
    in_req => inA_req,
    in_ack => inA_ack,
    outA_req => outB_req,
    outA_ack => outB_ack,
    outB_req => outC_req,
    outB_ack => outC_ack,
    en => en
  );

  latch_data: process(en, rst)
  begin
    if rst = '1' then
      outB_data <= (others => '0');
      outC_data <= (others => '0');
    elsif rising_edge(en) then
      outB_data <= inA_data;
      outC_data <= inA_data;
    end if;
  end process latch_data;
end Behavioral;