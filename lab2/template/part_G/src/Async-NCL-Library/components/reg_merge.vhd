----------------------------------------------------------------------------------
-- Register+Merge
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;

entity reg_merge is
	generic(
		DATA_WIDTH : natural := DATA_WIDTH
	);
	port (
		rst   		: in std_logic;
		--Input channel 1
		inA_ack   	: out std_logic;
		inA_data_t	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_data_f	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		-- Input channel 2
		inB_ack   	: out std_logic;
		inB_data_t	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		inB_data_f  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		-- Output channel
		outC_ack  	: in std_logic;
		outC_data_t : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_data_f : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
	end reg_merge;

architecture Behavioral of reg_merge is
	
	signal reg_ack : std_logic;
	signal temp_t : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal temp_f : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

	mergeInputs : entity work.merge 
	generic map(
		DATA_WIDTH    => DATA_WIDTH
	)
	port map(
		rst           => rst,
		-- Input port
		inA_data_t    => inA_data_t,
		inA_data_f    => inA_data_f,
		inA_ack       => inA_ack,
		-- Output channel 1
		inB_data_t    => inB_data_t,
		inB_data_f    => inB_data_f,
		inB_ack       => inB_ack,
		-- Output channel 2
		outC_data_t   => temp_t,
		outC_data_f   => temp_f,
		outC_ack      => reg_ack
	);
	
	reg : entity work.wchb_ncl
	generic map( 
		DATA_WIDTH  => DATA_WIDTH
	)
	port map(
		-- flags
		rst       => rst,
		ack_in    => outC_ack,
		ack_out   => reg_ack,
		-- Input channel
		in_t      => temp_t,
		in_f      => temp_f,
		-- Output channel
		out_t     => outC_data_t,
		out_f     => outC_data_f
	);
	
	
end Behavioral;
