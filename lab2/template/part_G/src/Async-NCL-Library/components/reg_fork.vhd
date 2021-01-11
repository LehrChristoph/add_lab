----------------------------------------------------------------------------------
-- Register+Forq
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.defs.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity reg_fork is
	generic ( 
		DATA_WIDTH: natural := DATA_WIDTH;
		INIT_VALUE		: natural 	:= 0;
		INIT_PHASE		: std_logic := '1'
	);
	Port (
		rst : in std_logic;
		--Input channel
		inA_data_t  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_data_f  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inA_ack     : out std_logic;
		--Output channel 1
		outB_data_t : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outB_data_f : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outB_ack    : in std_logic;
		--Output channel 2
		outC_data_t : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_data_f : out std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_ack    : in std_logic );
	end reg_fork;

architecture Behavioral of reg_fork is
	component c_element is 
		port(
			in1, in2 : in std_logic;
			out1 : out std_logic
		);
	end component;
	
	signal fork_ack : std_logic;
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
		ack_in    => fork_ack,
		ack_out   => inA_ack,
		-- Input channel
		in_t      => inA_data_t,
		in_f      => inA_data_f,
		-- Output channel
		out_t     => temp_t,
		out_f     => temp_f
	);
	
	c_element_inst_f : c_element
	port map(
		in1 => outB_ack,
		in2 => outC_ack,
		out1 => fork_ack
	);
	
	outB_data_t <= temp_t;
	outB_data_f <= temp_f;
	outC_data_t <= temp_t;
	outC_data_f <= temp_f;
	 
end Behavioral;