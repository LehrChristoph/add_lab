----------------------------------------------------------------------------------
-- Register+MUX
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity reg_mux is
	--generic for initializing the phase registers
	generic(
		DATA_WIDTH      : natural := DATA_WIDTH;
		INIT_VALUE		: natural 	:= 0;
		INIT_PHASE		: std_logic := '1'
	);
	port(
		rst       : in  std_logic; -- rst line
		-- Input from channel 1
		inA_data_t : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_data_f : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_ack    : out std_logic;
		-- Input from channel 2
		inB_data_t : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inB_data_f : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inB_ack    : out std_logic;
		-- Output port 
		outC_data_t: out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_data_f: out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_ack   : in  std_logic;
		-- Select port
		inSel_ack  : out std_logic;
		selector_t : in std_logic;
		selector_f : in std_logic
	);
end reg_mux;

architecture arch of reg_mux is
	signal reg_ack : std_logic;
	signal temp_t : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal temp_f : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	demux : entity work.mux 
	generic map(
		DATA_WIDTH		=> DATA_WIDTH
	)
	port map(
		rst           => rst,
		-- Input port
		inA_data_t    => inA_data_t,
		inA_data_f    => inA_data_f,
		inA_ack       => inA_ack,
		-- Select port 
		inSel_ack     => inSel_ack,
		selector_t    => selector_t,
		selector_f    => selector_f,
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
		DATA_WIDTH  => DATA_WIDTH,
		INIT_VALUE 	=> INIT_VALUE,
		INIT_PHASE  => INIT_PHASE
	)
	port map(
		-- flags
		rst       => rst,
		ack_in    => outC_ack,
		ack_out   => reg_ack,
		-- Input channel
		in_t      => temp_t ,
		in_f      => temp_f ,
		-- Output channel
		out_t     => outC_data_t,
		out_f     => outC_data_f
	);
	
end arch;
