library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.workcraft_pkg.all;
use work.defs.all;

entity handshake is
    generic (
      INIT_STATE   : std_logic := '0'
    );
    port (
      rst         : in std_logic;
      -- Input channel
      in_req          : in std_logic;
      in_ack          : out std_logic;
      out_req         : out std_logic;
      out_ack         : in std_logic;
      en              : out std_logic);
end entity handshake;


architecture beh of handshake is
    signal c_in1 : std_logic;
    signal c_in2 : std_logic;
    signal c_out : std_logic;
begin

    c_in1 <= in_req and (not out_ack) after AND2_DELAY + NOT1_DELAY;
    c_in2 <= in_req or (not out_ack)  after AND2_DELAY + NOT1_DELAY;

    en <= c_out;
    in_ack <= c_out;
    out_req <= c_out;

    c_elem_reset : IF INIT_STATE = '0' generate
        c_elem : entity work.C2_r
        port map (
            A => c_in1,
            B => c_in2,
            Q => c_out,
            R => rst
        );
    end generate;
    c_elem_set : IF INIT_STATE = '1' generate
        c_elem : entity work.C2_s
        port map (
            A => c_in1,
            B => c_in2,
            Q => c_out,
            S => rst
        );
    end generate;



end beh;