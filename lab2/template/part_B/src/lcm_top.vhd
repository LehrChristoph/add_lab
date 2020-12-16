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
	component LCM is
		generic (
			DATA_WIDTH : natural := 16
		);
		port(
			clk: in std_logic;
			res_n: in std_logic;
			AB : in std_logic_vector(DATA_WIDTH-1 downto 0);
			ready : in std_logic;
			done : out std_logic;
			result: out std_logic_vector(DATA_WIDTH-1 downto 0);
			valid: out std_logic
		);
	end component LCM;
	
	signal AB  : std_logic_vector(7 downto 0) := (others => '0');
begin

	lcm_calc: component LCM 
		generic map (
			DATA_WIDTH => 8
		)
		port map(
			clk	=> clk,
			res_n	=> res_n,
			AB 	=> AB,
			ready => ready,
			done 	=> done,
			result=> result,
			valid	=> valid
		);
		
		AB(7 downto 4) <= A;
		AB(3 downto 0) <= B;
		A_deb <= A;
		B_deb <= B;


end STRUCTURE;
