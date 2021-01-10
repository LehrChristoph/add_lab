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