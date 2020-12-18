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
begin

	lcm_calc: entity work.LCM
		generic map (
			DATA_WIDTH => result'length
		)
		port map(
			clk	=> clk,
			res_n	=> res_n,
			AB 	=> A&B,
			ready => ready,
			done 	=> done,
			result=> result,
			valid	=> valid
		);
		A_deb <= A;
		B_deb <= B;


end STRUCTURE;
