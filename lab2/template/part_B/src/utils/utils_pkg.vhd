library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package utils_pkg is

	component reg is
	generic (
		DATA_WIDTH : natural := 16
	);
   port
   (
		clk   :  in std_logic;
		reset :  in std_logic;
      d		:  in std_logic_vector(DATA_WIDTH-1 downto 0);
      q		: out std_logic_vector(DATA_WIDTH-1 downto 0)
   );
	end component reg;
	
	component mux_2to1 is
	generic (
		DATA_WIDTH : natural := 16
	);
   Port (
		sel 	: in  STD_LOGIC;
      inA   : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
      inB   : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
      outC	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
	);
	end component mux_2to1;
	
	component demux_1to2 is
		generic (
			DATA_WIDTH : natural := 16
		);
		Port (
			sel 	: in  STD_LOGIC;
			inA   : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			outB  : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
			outC	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
		);
	end component demux_1to2;
	
	component sel_a_not_b is
	generic(
		DATA_WIDTH  : natural := 16
	);
	port(
		in_data     : in  std_logic_vector(DATA_WIDTH -1 downto 0);
		selector    : out std_logic
	);
	end component sel_a_not_b;
	
	component sel_a_larger_b is
	generic(
		DATA_WIDTH    : natural := 16
	);
	port(
		in_data       : in  std_logic_vector(DATA_WIDTH -1 downto 0);
		selector      : out std_logic
	);
	end component sel_a_larger_b;

	component add_block is
	generic ( 
		DATA_WIDTH: natural := 16);
	port (
		inA_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		inB_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		outC_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
	end component add_block;
	
	component reg_ena_valid is
		generic (
			DATA_WIDTH : natural := 16
		);
		port
		(
			clk   :  in std_logic;
			reset :  in std_logic;
			ena	:	in std_logic;
			d		:  in std_logic_vector(DATA_WIDTH-1 downto 0);
			valid : out std_logic;
			q		: out std_logic_vector(DATA_WIDTH-1 downto 0)
		);
	end component reg_ena_valid;

end package;

