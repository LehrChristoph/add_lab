----------------------------------------------------------------------------------
-- Register+Demux
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.defs.all;

entity reg_demux is
  generic(
    DATA_WIDTH    : natural := DATA_WIDTH;
		INIT_VALUE		: natural 	:= 0;
		INIT_PHASE		: std_logic := '1'
	);
  port(
    rst           : in std_logic;
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
    outB_ack      : in std_logic;
    -- Output channel 2
    outC_data_t   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_data_f   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_ack      : in std_logic
    );
end reg_demux;

architecture Behavioral of reg_demux is
	signal demux_ack : std_logic;
	signal temp_t : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal temp_f : std_logic_vector(DATA_WIDTH-1 downto 0);
	
begin  

	reg : entity work.wchb_ncl
	generic map( 
		DATA_WIDTH  => DATA_WIDTH,
		INIT_VALUE 	=> INIT_VALUE,
		INIT_PHASE  => INIT_PHASE
	)
	port map(
		-- flags
		rst       => rst,
		ack_in    => demux_ack,
		ack_out   => inA_ack,
		-- Input channel
		in_t      => inA_data_t,
		in_f      => inA_data_f,
		-- Output channel
		out_t     => temp_t,
		out_f     => temp_f
	);
	
	demux : entity work.demux 
	generic map(
		DATA_WIDTH		=> DATA_WIDTH
	)
	port map(
		rst           => rst,
		-- Input port
		inA_data_t    => temp_t,
		inA_data_f    => temp_f,
		inA_ack       => demux_ack,
		-- Select port 
		inSel_ack     => inSel_ack,
		selector_t    => selector_t,
		selector_f    => selector_f,
		-- Output channel 1
		outB_data_t   => outB_data_t,
		outB_data_f   => outB_data_f,
		outB_ack      => outB_ack,
		-- Output channel 2
		outC_data_t   => outC_data_t,
		outC_data_f   => outC_data_f,
		outC_ack      => outC_ack
	);

end Behavioral;
