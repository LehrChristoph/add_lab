----------------------------------------------------------------------------------
-- Demux
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity demux is
	generic(
		DATA_WIDTH    : natural := DATA_WIDTH
	);
	port(
		rst           : in  std_logic;
		-- Input port
		inA_data_t    : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_data_f    : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_ack       : out std_logic;
		-- Select port 
		inSel_ack     : out std_logic;
		selector_t    : in std_logic;
		selector_f    : in std_logic;
		-- Output channel 1
		outB_data_t   : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outB_data_f   : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outB_ack      : in  std_logic;
		-- Output channel 2
		outC_data_t   : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_data_f   : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_ack      : in  std_logic
	);
end demux;

architecture Behavioral of demux is

begin
	
	GEN_C_ELEMENT : for i in 0 to DATA_WIDTH-1 generate
		
		c_element_inst_outB_t : entity work.c_element
		port map
			(
				in1 => inA_data_t(i),
				in2 => selector_f,
				out1 => outB_data_t(i)
			);
			
		c_element_inst_outB_f : entity work.c_element
		port map
			(
				in1 => inA_data_f(i),
				in2 => selector_f,
				out1 => outB_data_f(i)
			);
		
		c_element_inst_outC_t : entity work.c_element
		port map
			(
				in1 => inA_data_t(i),
				in2 => selector_t,
				out1 => outC_data_t(i)
			);
			
		c_element_inst_outC_f : entity work.c_element
		port map
			(
				in1 => inA_data_f(i),
				in2 => selector_t,
				out1 => outC_data_f(i)
			);
	end generate GEN_C_ELEMENT;
	
	inA_ack <= outB_ack xor outC_ack;
	inSel_ack <= outB_ack xor outC_ack;
end Behavioral;
