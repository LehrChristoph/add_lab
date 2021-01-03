----------------------------------------------------------------------------------
-- Full-Adder-block
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.defs.all;

entity full_adder is
  generic ( 
    DATA_WIDTH: natural := DATA_WIDTH);
  port (
		-- flags
		done			: out std_logic;
		-- Input channel
		inA_data_t  : in  std_logic;
		inA_data_f  : in  std_logic;
		inB_data_t  : in  std_logic;
		inB_data_f  : in  std_logic;
		carry_in_t  : in  std_logic;
		carry_in_f  : in  std_logic;
		-- Output channel
		outC_data_t : out std_logic;
		outC_data_f : out std_logic;
		carry_out_t : out std_logic;
		carry_out_f : out std_logic
    );
end full_adder;

--architecture STRUCTURE of full_adder is
--	signal xor_t, xor_f: std_logic;
--	signal and_ab_t, and_ab_f: std_logic;
--	signal and_xor_cin_t, and_xor_cin_f: std_logic;
--	signal cd_in_1, cd_in_2, cd_in_3: std_logic;	
--begin
--	xor_t <= (inA_data_t and inB_data_f) or (inA_data_f and inB_data_t) after OR2_DELAY + AND2_DELAY;
--	xor_f <= (inA_data_f and inB_data_f) or (inA_data_t and inB_data_t) after OR2_DELAY + AND2_DELAY;
--	
--	outC_data_t <= (xor_t and carry_in_f) or (xor_f and carry_in_t) after OR2_DELAY + AND2_DELAY;
--	outC_data_f <= (xor_f and carry_in_f) or (xor_t and carry_in_t) after OR2_DELAY + AND2_DELAY;
--	
--	and_ab_t <= inA_data_t and inB_data_t after AND2_DELAY;
--	and_ab_f <= inA_data_f or  inB_data_f after OR2_DELAY;
--	
--	and_xor_cin_t <= carry_in_t and xor_t after AND2_DELAY;
--	and_xor_cin_f <= carry_in_f or  xor_f after OR2_DELAY;
--	
--	carry_out_t <= and_xor_cin_t or and_ab_t after OR2_DELAY;
--	carry_out_f <= and_xor_cin_f and and_ab_f after AND2_DELAY;
--	
--	cd_in_1 <= outC_data_t or outC_data_f after OR2_DELAY;
--	cd_in_2 <= and_xor_cin_t or and_xor_cin_f after OR2_DELAY;
--	cd_in_3 <= and_ab_t or and_ab_f after OR2_DELAY;
--	
--	c_element_done :	entity work.c_element_3in
--	port map
--	(
--		in1 => cd_in_1,
--		in2 => cd_in_2,
--		in3 => cd_in_3, 
--		out1 => done
--	);
--	
--end STRUCTURE;

architecture STRUCTURE of full_adder is
	signal c_element_1, c_element_2, c_element_3, c_element_4, c_element_5, c_element_6, c_element_7, c_element_8: std_logic;
	signal gen, kill : std_logic;
begin

	c_element_inst_1 :	entity work.c_element_3in
	port map
	(
		in1 => inA_data_f,
		in2 => inB_data_f,
		in3 => carry_in_f, 
		out1 => c_element_1
	);
	
	c_element_inst_2 :	entity work.c_element_3in
	port map
	(
		in1 => inA_data_f,
		in2 => inB_data_f,
		in3 => carry_in_t, 
		out1 => c_element_2
	);
	
	c_element_inst_3 :	entity work.c_element_3in
	port map
	(
		in1 => inA_data_f,
		in2 => inB_data_t,
		in3 => carry_in_f, 
		out1 => c_element_3
	);
	
	c_element_inst_4 :	entity work.c_element_3in
	port map
	(
		in1 => inA_data_f,
		in2 => inB_data_t,
		in3 => carry_in_t, 
		out1 => c_element_4
	);
	
	c_element_inst_5 :	entity work.c_element_3in
	port map
	(
		in1 => inA_data_t,
		in2 => inB_data_f,
		in3 => carry_in_f, 
		out1 => c_element_5
	);
	
	c_element_inst_6 :	entity work.c_element_3in
	port map
	(
		in1 => inA_data_t,
		in2 => inB_data_f,
		in3 => carry_in_t, 
		out1 => c_element_6
	);
	
	c_element_inst_7 :	entity work.c_element_3in
	port map
	(
		in1 => inA_data_t,
		in2 => inB_data_t,
		in3 => carry_in_f, 
		out1 => c_element_7
	);
	
	c_element_inst_8 :	entity work.c_element_3in
	port map
	(
		in1 => inA_data_t,
		in2 => inB_data_t,
		in3 => carry_in_t, 
		out1 => c_element_8
	);
	
	
	c_element_generate :	entity work.c_element
	port map
	(
		in1 => inA_data_t,
		in2 => inB_data_t,
		out1 => gen
	);
	
	c_element_kill :	entity work.c_element
	port map
	(
		in1 => inA_data_f,
		in2 => inB_data_f,
		out1 => kill
	);
	
	outC_data_t <= c_element_2 xor c_element_3 xor c_element_5 xor c_element_8; 
	outC_data_f <= c_element_1 xor c_element_4 xor c_element_6 xor c_element_7;
	
	carry_out_t <= c_element_4 xor c_element_6 xor gen;
	carry_out_f <= c_element_3 xor c_element_5 xor kill;
	
	
end STRUCTURE;