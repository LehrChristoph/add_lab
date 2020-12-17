
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ci_uart_rx_fsm is 
	generic
	(
		CLK_DIVISOR : integer
	);
	port
	(
		clk : in std_logic;
		res_n : in std_logic;
		
		rx : in std_logic;
		
		new_data : out std_logic;
		data : out std_logic_vector(7 downto 0)
	);
end entity;


architecture beh of ci_uart_rx_fsm is
	type RECEIVER_STATE_TYPE is
	(
		IDLE,
		WAIT_START_BIT,
		GOTO_MIDDLE_OF_START_BIT,
		MIDDLE_OF_START_BIT,
		WAIT_DATA_BIT,
		MIDDLE_OF_DATA_BIT,
		WAIT_STOP_BIT,
		MIDDLE_OF_STOP_BIT
	);

	signal receiver_state : RECEIVER_STATE_TYPE := IDLE;
	signal receiver_state_next : RECEIVER_STATE_TYPE := IDLE; 

	signal clk_cnt : integer range 0 to CLK_DIVISOR := 0;
	signal clk_cnt_next : integer range 0 to CLK_DIVISOR := 0;

	signal bit_cnt : integer range 0 to 7 := 0;
	signal bit_cnt_next : integer range 0 to 7 := 0;

	signal data_int : std_logic_vector(7 downto 0) := (others => '0');
	signal data_int_next : std_logic_vector(7 downto 0) := (others => '0');
	signal data_out : std_logic_vector(7 downto 0) := (others => '0');
	signal data_out_next : std_logic_vector(7 downto 0) := (others => '0');
	signal data_new : std_logic := '0';
	signal data_new_next : std_logic := '0';
begin
	sync : process(res_n, clk)
	begin
		if res_n = '0' then
			receiver_state <= IDLE;
		elsif rising_edge(clk) then
			receiver_state <= receiver_state_next;
			clk_cnt <= clk_cnt_next;
			bit_cnt <= bit_cnt_next;
			data_int <= data_int_next;
			data_out <= data_out_next;
			data_new <= data_new_next;
		end if;
	end process;

	next_state : process(all)
	begin

		receiver_state_next <= receiver_state;
			
		case receiver_state is

			when IDLE =>
				if(rx = '1') then
					receiver_state_next <= WAIT_START_BIT;
				end if;

			when WAIT_START_BIT =>
				if(rx = '0') then
					receiver_state_next <= GOTO_MIDDLE_OF_START_BIT;
				end if;

			when GOTO_MIDDLE_OF_START_BIT =>
				if(clk_cnt = CLK_DIVISOR/2-2) then
					receiver_state_next <= MIDDLE_OF_START_BIT;
				end if;

			when MIDDLE_OF_START_BIT =>
				receiver_state_next <= WAIT_DATA_BIT;

			when WAIT_DATA_BIT =>
				if(clk_cnt = CLK_DIVISOR-2) then
					receiver_state_next <= MIDDLE_OF_DATA_BIT;
				end if;

			when MIDDLE_OF_DATA_BIT =>
				if(bit_cnt < 7) then
					receiver_state_next <= WAIT_DATA_BIT;
				else
					receiver_state_next <= WAIT_STOP_BIT;
				end if;

			when WAIT_STOP_BIT =>
				if(clk_cnt = CLK_DIVISOR-2) then
					receiver_state_next <= MIDDLE_OF_STOP_BIT;
				end if;
			
			when MIDDLE_OF_STOP_BIT =>
				if(rx = '1') then
					receiver_state_next <= WAIT_START_BIT;
				else
					receiver_state_next <= IDLE;
				end if;
		end case;

	end process;


	output : process(all)
	begin
	
		clk_cnt_next <= clk_cnt;
		bit_cnt_next <= bit_cnt;
		data_int_next <= data_int;
		data_out_next <= data_out;
		data_new_next <= '0';

		case receiver_state is

			when IDLE =>
				
			when WAIT_START_BIT =>
				bit_cnt_next <= 0;
				clk_cnt_next <= 0;

			when GOTO_MIDDLE_OF_START_BIT =>
				clk_cnt_next <= clk_cnt + 1;

			when MIDDLE_OF_START_BIT =>
				clk_cnt_next <= 0;

			when WAIT_DATA_BIT =>
				clk_cnt_next <= clk_cnt + 1;

			when MIDDLE_OF_DATA_BIT =>
				clk_cnt_next <= 0;
				if(bit_cnt < 7) then
					bit_cnt_next <= bit_cnt + 1;
				else
					bit_cnt_next <= bit_cnt;
				end if;
				data_int_next <= rx & data_int(7 downto 1);

			when WAIT_STOP_BIT =>
				clk_cnt_next <= clk_cnt + 1;
			
			when MIDDLE_OF_STOP_BIT =>
				data_new_next <= '1';
				data_out_next <= data_int;
				
		end case;
	
	end process;

	data <= data_out;
	new_data <= data_new;
	
end architecture;



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ci_uart_tx_fsm is 

	generic (
		CLK_DIVISOR : integer
	);
	port (
		clk : in std_logic;
		res_n : in std_logic;
		
		tx : out std_logic;
		
		data : in std_logic_vector(7 downto 0);
		empty : in std_logic;
		rd : out std_logic
	);
end entity;


architecture beh of ci_uart_tx_fsm is
	type TRANSMITTER_STATE_TYPE is (IDLE, NEW_DATA, SEND_START_BIT, TRANSMIT_FIRST, TRANSMIT, TRANSMIT_NEXT, TRANSMIT_STOP_NEXT, TRANSMIT_STOP);

	signal transmitter_state : TRANSMITTER_STATE_TYPE;
	signal transmitter_state_next : TRANSMITTER_STATE_TYPE; 

	--clock cycle counter
	signal clk_cnt : integer range 0 to CLK_DIVISOR;
	signal clk_cnt_next : integer range 0 to CLK_DIVISOR;

	--bit counter
	signal bit_cnt : integer range 0 to 7;
	signal bit_cnt_next : integer range 0 to 7;


	signal transmit_data : std_logic_vector(7 downto 0); -- buffer for the current byte
	signal transmit_data_next : std_logic_vector(7 downto 0);
begin
	sync : process(res_n, clk)
	begin
		if res_n = '0' then
			transmitter_state <= IDLE;
			clk_cnt <= 0;
		elsif rising_edge(clk) then
			transmitter_state <= transmitter_state_next;
			clk_cnt <= clk_cnt_next;
			bit_cnt <= bit_cnt_next;
			transmit_data <= transmit_data_next;
		end if;
	end process;

	next_state : process(clk_cnt, bit_cnt, transmitter_state, empty)
	begin
		transmitter_state_next <= transmitter_state; --default
			
		case transmitter_state is
		
			when IDLE =>
				if empty = '0' then --check if the fifo is empty
					transmitter_state_next <= NEW_DATA;
				end if;
			
			when NEW_DATA =>
				transmitter_state_next <= SEND_START_BIT;
				
			when SEND_START_BIT => 
				--check if the bittime is over
				if clk_cnt = CLK_DIVISOR - 2 then 
					transmitter_state_next <= TRANSMIT_FIRST;
				end if;
			
			when TRANSMIT_FIRST =>
				transmitter_state_next <= TRANSMIT;
			
			when TRANSMIT =>
				if clk_cnt = CLK_DIVISOR - 2 and bit_cnt < 7 then 
					transmitter_state_next <= TRANSMIT_NEXT;
				elsif clk_cnt = CLK_DIVISOR - 2 then
					transmitter_state_next <= TRANSMIT_STOP_NEXT;
				end if;
				
			when TRANSMIT_NEXT =>
				transmitter_state_next <= TRANSMIT;
			
			when TRANSMIT_STOP_NEXT =>
				transmitter_state_next <= TRANSMIT_STOP;
			
			when TRANSMIT_STOP =>
				if clk_cnt = CLK_DIVISOR - 2 and empty = '0' then
					transmitter_state_next <= NEW_DATA;
				elsif clk_cnt = CLK_DIVISOR - 2 then
					transmitter_state_next <= IDLE;
				end if;
		end case;
	end process;


	output : process(clk_cnt, bit_cnt, transmitter_state, transmit_data, data)
	begin
	
		transmit_data_next <= transmit_data;
		clk_cnt_next <= clk_cnt;
		bit_cnt_next <= bit_cnt;
		rd <= '0';
		tx <= '1';	-- the idle state of the tx output is high
		
	
		case transmitter_state is
		
			when IDLE =>
				--do nothing
			when NEW_DATA =>
				 -- set rd to read the next byte from the fifo, 
				 -- rd is reset automaticly by the default assignment, when the next state is entered
				rd <= '1';
				clk_cnt_next <= 0; --reset counter 
				
			when SEND_START_BIT => 
				tx <= '0'; --send start bit, low --> automatic reset by default assignment 
				clk_cnt_next <= clk_cnt + 1;
	
			when TRANSMIT_FIRST =>
				clk_cnt_next <= 0; -- reset clk counter
				transmit_data_next <= data; --read databyte from fifo
				bit_cnt_next <= 0;  
				tx <= '0'; --we are still sending the start bit!
				
			when TRANSMIT =>
				clk_cnt_next <= clk_cnt + 1;
				tx <= transmit_data(0);
			
			when TRANSMIT_NEXT =>
				clk_cnt_next <= 0;
				bit_cnt_next <= bit_cnt + 1;
				tx <= transmit_data(0);
				transmit_data_next(6 downto 0) <= transmit_data(7 downto 1); -- shift transmitt_data
				-- srl shift right logical
				
			when TRANSMIT_STOP_NEXT =>
				clk_cnt_next <= 0;
				tx <= transmit_data(0);
			
			when TRANSMIT_STOP =>
				clk_cnt_next <= clk_cnt + 1; 
		
		end case;
	
	end process;

end architecture;



library ieee;
use ieee.std_logic_1164.all;

use work.ci_ram_pkg.all;
use work.ci_uart_pkg.all;

entity ci_uart is 
	generic (
		CLK_FREQ      : integer := 25_000_000; --the system clock frequency
		SYNC_STAGES   : integer := 2; --the amount of sync stages for the receiver
		RX_FIFO_DEPTH : integer := 16; --the fifo-depth for the receiver
		TX_FIFO_DEPTH : integer := 16; --the fifo-depth for the transmitter
		BAUD_RATE     : integer := 9600
	);
	port (
		clk      : in std_logic;
		res_n    : in std_logic;
		
		rx       : in std_logic;
		tx       : out std_logic;

		tx_data        : in std_logic_vector(7 downto 0);
		tx_wr          : in std_logic;
		tx_free        : out std_logic;
		--tx_empty       : out std_logic;
		
		rx_rd          : in std_logic;
		rx_data        : out std_logic_vector(7 downto 0);
		rx_empty  : out std_logic;
		rx_full   : out std_logic
	);
end entity;

architecture arch of ci_uart is
	signal transmitter_fifo_rd : std_logic;
	signal transmitter_fifo_data : std_logic_vector(7 downto 0);
	signal transmitter_fifo_empty : std_logic;

	signal tranmitter_fifo_full : std_logic;

	-- signal between sync and receiver
	signal rx_sync_vector : std_logic_vector(1 to SYNC_STAGES);
	signal sync_rx : std_logic;

	-- signal between receiver and fifo
	signal receiver_fifo_data : std_logic_vector(7 downto 0);
	signal receiver_fifo_wr : std_logic;
begin

	transmitter_fifo : ci_fifo_1c1r1w
	generic map (
		MIN_DEPTH => TX_FIFO_DEPTH,
		DATA_WIDTH => 8
	)
	port map (
		clk      => clk,
		res_n    => res_n,
		wr_data  => tx_data,
		wr       => tx_wr,
		rd       => transmitter_fifo_rd,
		rd_data  => transmitter_fifo_data,
		empty    => transmitter_fifo_empty,
		full     => tranmitter_fifo_full
	);
	
	tx_free <= not tranmitter_fifo_full;
	--tx_empty <= transmitter_fifo_empty;

	
	transmitter_inst : ci_uart_tx_fsm
	generic map (
		CLK_DIVISOR => CLK_FREQ/BAUD_RATE
	)
	port map (
		clk 		=> clk,
		res_n 		=> res_n,
		data 		=> transmitter_fifo_data,
		empty		=> transmitter_fifo_empty,
		tx			=> tx,
		rd			=> transmitter_fifo_rd
	);
	
	rx_sync_proc : process(clk, res_n)
	begin
		if res_n = '0' then
			rx_sync_vector <= (others => '1');
		elsif rising_edge(clk) then
			rx_sync_vector(1) <= rx; -- get new data
			-- forward data to next synchronizer stage
			for i in 2 to SYNC_STAGES loop
				rx_sync_vector(i) <= rx_sync_vector(i - 1);
			end loop;
		end if;
	end process;

	sync_rx <= rx_sync_vector(SYNC_STAGES);
	
	receiver_inst : ci_uart_rx_fsm
	generic map (
		CLK_DIVISOR => CLK_FREQ/BAUD_RATE
	)
	port map (
		clk 		=> clk,
		res_n 		=> res_n,
		
		rx 		=> sync_rx,
		data 		=> receiver_fifo_data,
		new_data	=> receiver_fifo_wr
	);
	
	receiver_fifo : ci_fifo_1c1r1w
	generic map (
		MIN_DEPTH => RX_FIFO_DEPTH,
		DATA_WIDTH => 8
	)
	port map (
		clk 		=> clk,
		res_n 		=> res_n,
		
		wr_data 	=> receiver_fifo_data,
		wr 		=> receiver_fifo_wr,
		rd 		=> rx_rd,
		rd_data 	=> rx_data,
		empty 		=> rx_empty,
		full 		=> rx_full
	);
end architecture;




