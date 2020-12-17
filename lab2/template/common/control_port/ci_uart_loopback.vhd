

library ieee;
use ieee.std_logic_1164.all;

use work.ci_uart_pkg.all;

entity ci_uart_loopback is
	port (
		clk : in std_logic;
		res_n : in std_logic;
		rx : in std_logic;
		tx : out std_logic
	);
end entity;


architecture arch of ci_uart_loopback is
	signal uart_tx_data : std_logic_vector(7 downto 0);
	signal uart_rx_data : std_logic_vector(7 downto 0);
	signal uart_rx_rd, uart_rx_empty, uart_tx_free, uart_tx_wr : std_logic;
	signal my_state : std_logic;
begin

	serial_port_inst : ci_uart
	generic map(
		CLK_FREQ => 50_000_000,
		SYNC_STAGES => 2, --the amount of sync stages for the receiver
		RX_FIFO_DEPTH =>16, --the fifo-depth for the receiver
		TX_FIFO_DEPTH =>16, --the fifo-depth for the transmitter
		BAUD_RATE => 9600
	)
	port map (
		clk => clk,
		res_n => res_n,
		rx => rx,
		tx => tx,
		tx_data => uart_tx_data,
		tx_free => uart_tx_free,
		tx_wr => uart_tx_wr,
		rx_rd => uart_rx_rd,
		rx_data => uart_rx_data,
		rx_empty => uart_rx_empty,
		rx_full => open
	);
	
	process (clk, res_n)
	begin
		if res_n= '0' then
			uart_tx_data <= (others=>'0');
			uart_tx_wr <= '0';
			uart_rx_rd <= '0';
			my_state <= '0';
		elsif rising_edge(clk) then
			uart_tx_wr <= '0';
			uart_rx_rd <= '0';
			my_state <= '0';
			
			if (uart_rx_empty = '0' and uart_rx_rd = '0') then
				uart_rx_rd <= '1';
			end if;
			
			if (uart_rx_rd = '1') then
				my_state <= '1'; 
			end if;
			
			if (my_state = '1') then
				uart_tx_wr <= '1'; 
				uart_tx_data <= uart_rx_data;
			end if;
			
		end if;
	end process;
end architecture;

