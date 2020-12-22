----------------------------------------------------------------------------------
-- Full-Adder-block
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

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
		carry_out_f : out std_logic;
    );
end full_adder_block;

architecture STRUCTURE of full_adder is
	signal xor_t, xor_f: std_logic;
	signal and_ab_t, and_ab_f: std_logic;
	signal and_xor_cin_t, and_xor_cin_f: std_logic;
	signal cd_in_1, cd_in_2, cd_in_3: std_logic;

	component c_element_3in is 
		port(
			in1, in2, in3 : in std_logic;
			out1 : out std_logic
		);
	end component;
	
begin
	xor_t <= (inA_data_t and inB_data_f) or (inA_data_f and inB_data_t);
	xor_f <= (inA_data_f and inB_data_f) or (inA_data_t and inB_data_t);
	
	outC_data_t <= (xor_t and carry_in_f) or (xor_f and carry_in_t);
	outC_data_f <= (xor_f and carry_in_f) or (xor_t and carry_in_t);
	
	and_ab_t <= inA_data_t and inB_data_t;
	and_ab_f <= inA_data_f or  inB_data_f;
	
	and_xor_cin_t <= carry_in_t and xor_t;
	and_xor_cin_f <= carry_in_f or  xor_f;
	
	carry_out_t <= and_xor_cin_t or and_ab_t;
	carry_out_f <= and_xor_cin_f and and_ab_f;
	
	cd_in_1 <= outC_data_t or outC_data_f;
	cd_in_2 <= and_xor_cin_t or and_xor_cin_f:
	cd_in_3 <= and_ab_t or and_ab_t;
	
	c_element_done :	c_element_3in
	port map
		(
			in1 => cd_in_1,
			in2 => cd_in_2,
			in3 => cd_in_3, 
			out1 => done
		);
	
end STRUCTURE;