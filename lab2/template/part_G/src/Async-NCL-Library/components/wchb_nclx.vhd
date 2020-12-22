----------------------------------------------------------------------------------
-- Week Condition Half Buffer
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;


entity wchb_nclx is
  generic ( 
    DATA_WIDTH    : natural := DATA_WIDTH
	);
	port(
	   -- flags
		rst       : in std_logic;
		ack       : in std_logic;
		done_in   : in std_logic;
		done_out  : out std_logic;
		-- Input channel
		in_t      : in std_logic_vector(DATA_WIDTH-1 downto 0);
		in_f      : in std_logic_vector(DATA_WIDTH-1 downto 0);
		-- Output channel
		out_t     : out std_logic_vector(DATA_WIDTH-1 downto 0);
		out_f     : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end wchb_nclx;

architecture STRUCTURE of wchb_nclx is
	component c_element is 
		port(
			in1, in2 : in std_logic;
			out1 : out std_logic
		);
	end component;
	
	component c_element_3in is 
		port(
			in1, in2, in3 : in std_logic;
			out1 : out std_logic
		);
	end component;
	
	signal temp_t : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal temp_f : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal internal_ack, internal_done  : std_logic;
begin
	GEN_C_ELEMENT : for i in 1 to DATA_WIDTH-1 generate
		
		c_element_inst_t : c_element
		port map
			(
				in1 => in_t(i),
				in2 => not internal_ack,
				out1 => temp_t(i)
			);
		c_element_inst_f :	c_element
		port map
			(
				in1 => in_f(i),
				in2 => not internal_ack,
				out1 => temp_f(i)
			);
	end generate GEN_C_ELEMENT;
	
	output_complete : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		rst => rst,
		data_t => temp_t,
		data_f => temp_f,
		complete => internal_done
	);
	
	c_element_ack :	c_element_3in
	port map
		(
			in1 => internal_done,
			in2 => ack,
			in3 => done_in, 
			out1 => internal_ack
		);
	
	out_t <= temp_t;
	out_f <= temp_f;
	done_out <= internal_done;
	
end STRUCTURE;
