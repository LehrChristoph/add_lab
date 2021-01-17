library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.workcraft_pkg.all;
use work.defs.all;

entity handshake_dual_input is
    port (
      rst         : in std_logic;
      -- Input channel
      inA_req         : in std_logic;
      inA_ack         : out std_logic;
      inB_req         : in std_logic;
      inB_ack         : out std_logic;
      out_req         : out std_logic;
      out_ack         : in std_logic;
      en              : out std_logic);
end entity handshake_dual_input;


architecture beh of handshake_dual_input is
    signal c_in1 : std_logic;
    signal c_in2 : std_logic;
    signal c_out : std_logic;
    signal c1_out : std_logic;
begin

    c_elem1 : entity work.C2_r
    port map (
        A => inA_req,
        B => inB_req,
        Q => c1_out,
        R => rst
    );

    c_in1 <=  c1_out and (not out_ack) after AND2_DELAY + NOT1_DELAY + XOR_DELAY;
    c_in2 <=  c1_out or  (not out_ack) after AND2_DELAY + NOT1_DELAY + XOR_DELAY;

    en <= c_out;
    inA_ack <= c_out;
    inB_ack <= c_out;
    out_req <= c_out;

    c_elem : entity work.C2_r
    port map (
        A => c_in1,
        B => c_in2,
        Q => c_out,
        R => rst
    );

end beh;