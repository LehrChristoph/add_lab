library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.workcraft_pkg.all;
use work.defs.all;

entity handshake_dual_output is
    port (
      rst         : in std_logic;
      -- Input channel
      in_req      : in std_logic;
      in_ack      : out std_logic;
      outA_req    : out std_logic;
      outA_ack    : in std_logic;
      outB_req    : out std_logic;
      outB_ack    : in std_logic;
      en          : out std_logic);
end entity handshake_dual_output;


architecture beh of handshake_dual_output is
    signal c_in1  : std_logic;
    signal c_in2  : std_logic;
    signal c1_out : std_logic;
    signal c_out  : std_logic;
begin
    c_elem1 : entity work.C2_r
    port map (
        A => outA_ack,
        B => outB_ack,
        Q => c1_out,
        R => rst
    );


    c_in1 <= in_req and (not c1_out) after AND2_DELAY + NOT1_DELAY;
    c_in2 <= in_req or  (not c1_out) after AND2_DELAY + NOT1_DELAY;

    en <= c_out;
    in_ack <= c_out;
    outA_req <= c_out;
    outB_req <= c_out;

    c_elem : entity work.C2_r
    port map (
        A => c_in1,
        B => c_in2,
        Q => c_out,
        R => rst
    );

end beh;