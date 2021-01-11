----------------------------------------------------------------------------------
--LCM Top-Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.sync_pkg.all;

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
	constant DATA_WIDTH : Integer := result'length;
	constant SYNC_STAGES : NATURAL := 2;
	
	signal sys_res_n : std_logic;
	signal synch_ack_result : std_logic;
	signal synch_req_AB : std_logic;
	signal signal_tap_clk : std_logic;
		
begin
	
	sys_reset_sync : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES ,
		RESET_VALUE => '1'
	)
	port map(
		clk => clk ,
		res_n => '1' ,
		data_in => res_n ,
		data_out => sys_res_n
	);
	
	ack_result_sync : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES ,
		RESET_VALUE => '0'
	)
	port map(
		clk => clk ,
		res_n => res_n ,
		data_in => ack_result ,
		data_out => synch_ack_result
	);
	
	req_AB_sync : sync
	generic map (
		SYNC_STAGES => SYNC_STAGES ,
		RESET_VALUE => '0'
	)
	port map(
		clk => clk ,
		res_n => res_n ,
		data_in => req_AB ,
		data_out => synch_req_AB
	);
	
	lcm_calc: entity work.lcm
	generic map ( 
		DATA_WIDTH => DATA_WIDTH)
	port map(
		A => A,
		B => B,
		RESULT => result,
		rst => not sys_res_n,
		i_req => synch_req_AB,
		i_ack => ack_AB,
		o_req => req_result,
		o_ack => synch_ack_result
	);

	A_deb <= A;
	B_deb <= B;
end STRUCTURE;
