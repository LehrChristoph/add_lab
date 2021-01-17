----------------------------------------------------------------------------------
--LCM Top-Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use ieee.std_logic_unsigned.all;
use work.defs.all;
use work.click_element_library_constants.all;
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

	signal A_pad,B_pad : std_logic_vector((LCM_IN_DATA_WIDTH/2)-1 downto 0);
	signal result_pad :std_logic_vector(LCM_OUT_DATA_WIDTH-1 downto 0);
	 
	constant SYNC_STAGES : NATURAL := 2;

	signal sys_res_n : std_logic;
	signal synch_ack_result : std_logic;
	signal synch_req_AB : std_logic;
	signal signal_tap_clk : std_logic;
	
	component pll is 
    port(
        inclk0        : IN STD_LOGIC := '0';
        c0        : OUT STD_LOGIC
    );
    end component;

begin

pll_inst : pll
    port map(
        inclk0 => clk,
        c0 => signal_tap_clk
    );

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



	 -- padding with leading zeros
	 A_pad <= ((LCM_IN_DATA_WIDTH/2)-1 downto A'length => '0') & A;
	 B_pad <= ((LCM_IN_DATA_WIDTH/2)-1 downto B'length => '0') & B;

	 lcm_calc: entity work.Scope(LCM)
	 generic map(
	 DATA_WIDTH => LCM_DATA_WIDTH,
	 OUT_DATA_WIDTH => LCM_OUT_DATA_WIDTH,
	 IN_DATA_WIDTH => LCM_IN_DATA_WIDTH
	 )
	 port map (
	 rst => not res_n,
	 -- Input channel
	 in_ack => ack_AB,
	 in_req => req_AB,
	 in_data => A_pad & B_pad,
	 -- Output channel
	 out_req => req_result,
	 out_data => result_pad,
	 out_ack => ack_result
	 );
	 
	 result <= result_pad(result'length-1 downto 0);

	 A_deb <= A;
    B_deb <= B;

end STRUCTURE;
