----------------------------------------------------------------------------------
-- Merge
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity merge is
	generic(
		DATA_WIDTH    : natural := DATA_WIDTH
	);
  port (rst   : in std_logic;
    -- Input port
    inA_data_t    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    inA_data_f    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    inA_ack       : out std_logic;
    -- Output channel 1
    inB_data_t    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    inB_data_f    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    inB_ack       : out std_logic;
    -- Output channel 2
    outC_data_t   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_data_f   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_ack      : in  std_logic
    );
end merge;

architecture Behavioral of merge is
	signal inA_complete, inB_complete : std_logic;
	signal inA_data_buffered_t, inA_data_buffered_f : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal inB_data_buffered_t, inB_data_buffered_f : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	
	inA_cd : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		rst => rst,
		data_t => inA_data_t,
		data_f => inA_data_f,
		complete => inA_complete
	);
	
	inB_cd : entity work.completion_detector 
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		rst => rst,
		data_t => inB_data_t,
		data_f => inB_data_f,
		complete => inB_complete
	);
	
	c_element_inst_inA_ack : entity work.c_element
	port map
		(
			in1 => outC_ack,
			in2 => inA_complete,
			out1 => inA_ack
		);
	
	c_element_inst_inB_ack : entity work.c_element
	port map
		(
			in1 => outC_ack,
			in2 => inB_complete,
			out1 => inB_ack
		);
		
	outC_data_f <= inA_data_t xor inB_data_t after XOR_DELAY;
	outC_data_t <= inA_data_f xor inB_data_f after XOR_DELAY;
	
end Behavioral;
