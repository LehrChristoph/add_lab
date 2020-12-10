----------------------------------------------------------------------------------
--LCM Top-Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity LCM_top is
   port(
		clk: in std_logic;
		res_n: in std_logic;
		A, B : in std_logic_vector(3 downto 0);
		A_deb, B_deb : out std_logic_vector(3 downto 0);
		req_AB: in std_logic;
		ack_AB: out std_logic;
		result: out std_logic_vector(7 downto 0);
		req_result: out std_logic;
		ack_result: in std_logic
	);
end LCM_top;

architecture STRUCTURE of LCM_top is

constant DATA_WIDTH : Integer := 8;

component lcm is	
	generic ( DATA_WIDTH : natural);
	port (
		AB : in std_logic_vector ( DATA_WIDTH-1 downto 0 );
		RESULT : out std_logic_vector ( DATA_WIDTH-1 downto 0 );
		rst : in std_logic;
		i_req:  in std_logic;
		i_ack:  out std_logic;
		o_req: out std_logic;
		o_ack: in std_logic
	);
end component lcm;
	
	signal AB, result_tmp : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
	
lcm_calc: component lcm
	generic map ( DATA_WIDTH => DATA_WIDTH)
	port map(
		AB => AB,
		RESULT => result_tmp,
		rst => res_n,
		i_req => req_AB,
		i_ack => ack_AB,
		o_req => req_result,
		o_ack => ack_result
	);
	
	AB(DATA_WIDTH   -1 downto DATA_WIDTH/2) <= A;
	AB(DATA_WIDTH/2 -1 downto            0) <= B;
	A_deb <= result_tmp(DATA_WIDTH   -1 downto DATA_WIDTH/2);
	B_deb <= result_tmp(DATA_WIDTH/2 -1 downto            0);
	result <= result_tmp;
end STRUCTURE;
