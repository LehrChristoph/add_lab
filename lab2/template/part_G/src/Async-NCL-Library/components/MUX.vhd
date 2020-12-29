----------------------------------------------------------------------------------
-- MUX
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity mux is
	--generic for initializing the phase registers
	generic(
		DATA_WIDTH      : natural := DATA_WIDTH
	);
	port(
		rst             : in  std_logic; -- rst line
		-- Input from channel 1
		inA_data_t      : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_data_f      : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_ack         : out std_logic;
		-- Input from channel 2
		inB_data_t      : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inB_data_f      : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inB_ack         : out std_logic;
		-- Output port 
		outC_data_t     : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_data_f     : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_ack        : in  std_logic;
		-- Select port
		inSel_ack       : out std_logic;
		selector_t      : in std_logic;
		selector_f      : in std_logic
	);
end mux;

architecture arch of mux is
	signal inA_buffered_complete, inB_buffered_complete : std_logic;
	signal inA_data_buffered_t, inA_data_buffered_f : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal inB_data_buffered_t, inB_data_buffered_f : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	
--	inSel_ack <= outC_ack;
--	
--	c_element_ackA: entity work.c_element
--	port map
--		(
--			in1 => outC_ack,
--			in2 => selector_t,
--			out1 => inA_ack
--		);
	
	GEN_C_ELEMENT : for i in 0 to DATA_WIDTH-1 generate
		
		c_element_inst_inAt : entity work.c_element
		port map
			(
				in1 => inA_data_t(i),
				in2 => selector_f,
				out1 => inA_data_buffered_t(i)
			);
			
		c_element_inst_inAf : entity work.c_element
		port map
			(
				in1 => inA_data_f(i),
				in2 => selector_f,
				out1 => inA_data_buffered_f(i)
			);
		
		c_element_inst_inBt : entity work.c_element
		port map
			(
				in1 => inB_data_t(i),
				in2 => selector_t,
				out1 => inB_data_buffered_t(i)
			);
			
		c_element_inst_inBf : entity work.c_element
		port map
			(
				in1 => inB_data_f(i),
				in2 => selector_t,
				out1 => inB_data_buffered_f(i)
			);
	end generate GEN_C_ELEMENT;
	
	inA_Buffered_cd : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		rst => rst,
		data_t => inA_data_buffered_t,
		data_f => inA_data_buffered_f,
		complete => inA_buffered_complete
	);
	
	inB_Buffered_cd : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		rst => rst,
		data_t => inB_data_buffered_t,
		data_f => inB_data_buffered_f,
		complete => inB_buffered_complete
	);
	
	c_element_inst_inA_ack : entity work.c_element
	port map
	(
		in1 => inA_buffered_complete,
		in2 => outC_ack,
		out1 => inA_ack
	);
		
	c_element_inst_inB_ack : entity work.c_element
	port map
	(
		in1 => inB_buffered_complete,
		in2 => outC_ack,
		out1 => inB_ack
	);
	
	inSel_ack <= outC_ack;
	
	outC_data_f <= inA_data_buffered_t xor inB_data_buffered_t;
	outC_data_t <= inA_data_buffered_f xor inB_data_buffered_f;
	
end arch;
