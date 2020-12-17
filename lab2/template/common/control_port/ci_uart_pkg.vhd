
library ieee;
use ieee.std_logic_1164.all;

package ci_uart_pkg is

	component ci_uart_tx_fsm is 
		generic (
			CLK_DIVISOR : integer
		);
		port (
			clk   : in std_logic;
			res_n : in std_logic;
			data  : in std_logic_vector(7 downto 0);
			empty : in std_logic;

			tx :  out std_logic;
			rd :  out std_logic
		);
	end component;

	component ci_uart_rx_fsm is
		generic (
			CLK_DIVISOR : integer
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			rx : in std_logic;
			new_data : out std_logic;
			data : out std_logic_vector(7 downto 0)
		);
	end component;

	component ci_uart is
		generic (
			CLK_FREQ : integer := 25_000_000;
			SYNC_STAGES : integer := 2;
			RX_FIFO_DEPTH : integer := 16;
			TX_FIFO_DEPTH : integer := 16;
			BAUD_RATE : integer := 9600
		);
		port (
			clk : in std_logic;
			res_n : in std_logic;
			rx : in std_logic;
			tx : out std_logic;
			tx_data : in std_logic_vector(7 downto 0);
			tx_wr : in std_logic;
			tx_free : out std_logic;
			--tx_empty : out std_logic;
			rx_rd : in std_logic;
			rx_data : out std_logic_vector(7 downto 0);
			rx_empty : out std_logic;
			rx_full : out std_logic
		);
	end component;
end package;
