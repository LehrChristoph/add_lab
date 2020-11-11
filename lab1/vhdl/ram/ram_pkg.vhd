library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;

package ram_pkg is
	component dp_ram_1c1r1w is
		generic (
			ADDR_WIDTH : integer;
			DATA_WIDTH : integer
		);
		port (
			clk    : in std_logic;

			raddr1 : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
			rdata1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			rd1    : in std_logic;

			waddr2 : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
			wdata2 : in std_logic_vector(DATA_WIDTH - 1 downto 0);
			wr2    : in std_logic
		);
	end component;

	component fifo_2c1r1w is
		generic (
			MIN_DEPTH  : integer;
			DATA_WIDTH : integer;
			SYNC_STAGES : integer
		);
		port (
			clk1 : in  std_logic;    
			res1_n : in  std_logic;    
			data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			rd1 : in  std_logic;
			ack1 : out  std_logic;
			empty1 : out std_logic;
			full1 : out std_logic;
			overflowed1 : out std_logic;

			clk2 : in std_logic;
			res2_n : in std_logic;
			data_in2 : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			wr2 : in  std_logic;
			empty2 : out std_logic;
			full2 : out std_logic;
			overflowed2 : out std_logic
		);
	end component;

	component fifo_1c1r1w is
		generic (
			MIN_DEPTH  : integer;
			DATA_WIDTH : integer
		);
		port (
			clk : in  std_logic;    
			res_n : in  std_logic;    
				
			data_out1 : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			rd1 : in  std_logic;
			    
			data_in2 : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
			wr2 : in  std_logic;
				
			empty : out std_logic;
			full : out std_logic;
			overflowed : out std_logic
		);
	end component;
end package;
