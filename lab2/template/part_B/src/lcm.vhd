----------------------------------------------------------------------------------
--LCM Entity
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.utils_pkg.all;

entity LCM is
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
end LCM;

architecture STRUCTURE of LCM is
	constant DATA_PATH_WIDTH : Integer := 3*DATA_WIDTH;
	constant SUM_WIDTH : Integer := DATA_WIDTH;
	constant SUMMAND_WIDTH : Integer := DATA_WIDTH/2;
	
	signal rev0_AB  : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal rev0_ABsumAB  : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal m1_ABsumAB : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal reg0_ABsumAB : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal reg0_sumAB : std_logic_vector(2*SUM_WIDTH-1 downto 0);
	signal sel0_sumNotEq : std_logic;
	signal reg1_input_select : std_logic;
	signal reg2_input_select : std_logic;
	signal de0_ABsumAB, de0_full_reslt_vector : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal reg3_ABsumAB : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal reg3_sumAB : std_logic_vector(2*SUM_WIDTH-1 downto 0);
	signal sel1_sum_select :std_logic;
	signal de1_AsumA, de1_BsumB,  de1_A, de1_B: std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal add0_AsumA, add1_BsumB, add2_merged_ABsumAB : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);
	signal reg4_ABsumAB : std_logic_vector(DATA_PATH_WIDTH-1 downto 0);

begin
	
rev0_input_reg : component reg_ena_valid
	generic map (
		DATA_WIDTH => DATA_WIDTH
	)
   port map
   (
		clk  	=> clk,
		reset => res_n,
		ena	=> ready,
      d		=> AB,
		valid => done,
      q		=> rev0_AB
   );

	rev0_ABsumAB(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH) <= rev0_AB;
	rev0_ABsumAB(2*SUM_WIDTH -1 downto SUM_WIDTH+SUMMAND_WIDTH) <= (others => '0');
	rev0_ABsumAB(SUM_WIDTH+SUMMAND_WIDTH -1 downto SUM_WIDTH) <= rev0_AB(DATA_WIDTH-1 downto SUMMAND_WIDTH);
	rev0_ABsumAB(SUM_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
	rev0_ABsumAB(SUMMAND_WIDTH -1 downto 0) <= rev0_AB(SUMMAND_WIDTH-1 downto 0);
	
m1_sum_select : component mux_2to1
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map(
		sel 	=> not reg2_input_select,
      inA 	=> rev0_ABsumAB,
      inB	=> reg4_ABsumAB,
      outC 	=> m1_ABsumAB
	);
	
reg0_AB_sumAB : component reg
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map
   (
		clk 	=> clk,
		reset => res_n,
      d		=> m1_ABsumAB,
      q		=> reg0_ABsumAB
   );

reg0_sumAB <= reg0_ABsumAB(2*SUM_WIDTH-1 downto 0);

sel0_select_in_output : component sel_a_not_b 
	generic map(
		DATA_WIDTH => 2*SUM_WIDTH
	)
	port map(
		in_data => reg0_sumAB,
		selector => sel0_sumNotEq
	);

reg1_input_select_1 : component reg
	generic map(
		DATA_WIDTH => 1
	)
   port map
   (
		clk 	=> clk,
		reset => res_n,
      d(0)  => sel0_sumNotEq,
      q(0)  => reg1_input_select
   );

reg2_input_select_1 : component reg
	generic map(
		DATA_WIDTH => 1
	)
   port map
   (
		clk 	=> clk,
		reset => res_n,
      d(0)  => reg1_input_select,
      q(0)  => reg2_input_select
   );
	
de0_set_result : component demux_1to2
	generic map (
		DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map(
		sel 	=> sel0_sumNotEq,
      inA   => reg0_ABsumAB,
      outB  => de0_ABsumAB,
      outC	=> de0_full_reslt_vector
	);
	
rev1_input_reg : component reg_ena_valid
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
   port map
   (
		clk  	=> clk,
		reset => res_n,
		ena	=> sel0_sumNotEq,
      d		=> de0_full_reslt_vector(SUM_WIDTH-1 downto 0),
		valid => valid,
      q		=> result
   );

reg3_AB_sumAB : component reg
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map
   (
		clk 	=> clk,
		reset => res_n,
      d		=> de0_ABsumAB,
      q		=> reg3_ABsumAB
   );
reg3_sumAB <= reg3_ABsumAB(2*SUM_WIDTH-1 downto 0);

sel1_sum_select_cond: component sel_a_larger_b 
	generic map(
		DATA_WIDTH => 2*SUM_WIDTH
	)
	port map(
		in_data 	=> reg3_sumAB,
		selector	=> sel1_sum_select
	);

de1_switch_sum : component demux_1to2
	generic map (
		DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map(
		sel 	=> sel1_sum_select,
      inA   => reg3_ABsumAB,
      outB  => de1_AsumA,
      outC	=> de1_BsumB
	);
	

de1_A(DATA_PATH_WIDTH - 1 downto SUM_WIDTH + SUMMAND_WIDTH) <= (others => '0');
de1_A(SUM_WIDTH + SUMMAND_WIDTH -1 downto SUM_WIDTH) <= de1_AsumA(DATA_PATH_WIDTH -1 downto 2*SUM_WIDTH+ SUMMAND_WIDTH);
de1_A(SUM_WIDTH - 1 downto 0) <= (others => '0');

de1_B(DATA_PATH_WIDTH -1 downto SUMMAND_WIDTH) <= (others => '0');
de1_B(SUMMAND_WIDTH -1 downto 0) <= de1_BsumB(DATA_PATH_WIDTH-SUMMAND_WIDTH -1 downto 2*SUM_WIDTH);


add0_A_sumA: component add_block 
	generic map ( 
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		inA_data => de1_AsumA,
		inB_data => de1_A,
		outC_data=> add0_AsumA
	);

add1_B_sumB: component add_block 
	generic map ( 
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		inA_data => de1_BsumB,
		inB_data => de1_B,
		outC_data=> add1_BsumB
	);
	
add2_merge_AsumA_BsumB: component add_block 
	generic map ( 
		DATA_WIDTH => DATA_PATH_WIDTH
	)
	port map (
		inA_data => add0_AsumA,
		inB_data => add1_BsumB,
		outC_data=> add2_merged_ABsumAB
	);
	
reg4_AB_sumAB : component reg
	generic map(
		DATA_WIDTH => DATA_PATH_WIDTH
	)
   port map
   (
		clk 	=> clk,
		reset => res_n,
      d		=> add2_merged_ABsumAB,
      q		=> reg4_ABsumAB
   );
	
end STRUCTURE;
