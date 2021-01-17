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
		ready : in std_logic;
		done : out std_logic;
		result: out std_logic_vector(7 downto 0);
		valid: out std_logic
	);
end LCM_top;

architecture STRUCTURE of LCM_top is
	signal signal_tap_clk : std_logic;
	signal lcm_clk : std_logic;
	
	component pll is 
	port(
		inclk0		: IN STD_LOGIC := '0';
		c0		: OUT STD_LOGIC;
		c1		: OUT STD_LOGIC
	);
	end component;
	
	attribute keep: boolean;
	attribute keep of signal_tap_clk: signal is true;
		
begin
	
	pll_inst : pll
	port map(
		inclk0 => clk,
		c0 => signal_tap_clk,
		c1 => lcm_clk
	);
	
	lcm_calc: entity work.LCM
		generic map (
			DATA_WIDTH => result'length
		)
		port map(
			clk	=> lcm_clk,
			res_n	=> res_n,
			A => A,
			B => B,
			ready => ready,
			done 	=> done,
			result=> result,
			valid	=> valid
		);
		A_deb <= A;
		B_deb <= B;


end STRUCTURE;
