

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ci_uart_pkg.all;
use work.ci_ram_pkg.all;
use work.ci_math_pkg.all;
use work.ci_util_pkg.all;


entity control_port is
	generic(
		CLK_FREQ      : integer := 50_000_000;
		BAUD_RATE     : integer := 9600
	);
	port (
		clk   : in std_logic;
		res_n : in std_logic;
		rx    : in std_logic;
		tx    : out std_logic;
		proc_time : in std_logic_vector(31 downto 0);
		result : in std_logic_vector(31 downto 0);
		ctrl : in std_logic_vector(3 downto 0);
		int_result : in std_logic_vector(31 downto 0);
		dbg2 : in std_logic_vector(31 downto 0);
		lcm_dbg : in std_logic_vector(7 downto 0)
	);
end entity;

architecture arch of control_port is
	constant ADDR_WIDTH : integer := 3;
	constant HEX_READER_DATA_WIDTH : integer := 4;
	constant HEX_WRITER_DATA_WIDTH : integer := 32;

	signal uart_tx_data : std_logic_vector(7 downto 0);
	signal uart_tx_free : std_logic;
	signal uart_tx_wr : std_logic;
	signal uart_rx_rd : std_logic;
	signal uart_rx_data : std_logic_vector(7 downto 0);
	signal uart_rx_empty : std_logic;

	signal hex_reader_rx_rd : std_logic;
	signal hex_reader_start : std_logic;
	signal hex_reader_done : std_logic;
	signal hex_reader_value : std_logic_vector(HEX_READER_DATA_WIDTH-1 downto 0);
	signal hex_reader_max_length : std_logic_vector(log2c(HEX_READER_DATA_WIDTH)-1 downto 0);
	signal hex_reader_parse_error : std_logic;
	signal hex_reader_abort : std_logic;
	signal hex_reader_rd : std_logic;

	signal str_writer_tx_wr : std_logic;
	signal str_writer_tx_data : std_logic_vector(7 downto 0);
	signal str_writer_start : std_logic;
	signal str_writer_done : std_logic;
	signal str_writer_str : ascii_array_t(0 to 7);

	signal hex_writer_start : std_logic;
	signal hex_writer_done : std_logic;
	signal hex_writer_value : std_logic_vector(HEX_WRITER_DATA_WIDTH-1 downto 0);
	signal hex_writer_width : std_logic_vector(log2c(HEX_WRITER_DATA_WIDTH)-1 downto 0);
	signal hex_writer_tx_wr : std_logic;
	signal hex_writer_data : std_logic_vector(7 downto 0);

	signal write_address : std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal read_address : std_logic_vector(ADDR_WIDTH-1 downto 0);

	type fsm_state_t is (IDLE, WAIT_READ, READ_COMMAND, READ_OPERATION, READ_FIFO, READ_FIFO_WAIT, WAIT_HEX_WRITER, WRITE_OPERATION_READ_ADDRESS, WRITE_OPERATION_READ_DATA, PRINT_ERROR, WAIT_PRINT_STR, PRINT_OK);
	signal fsm_state : fsm_state_t;

	signal fsm_rx_rd : std_logic;

	
begin

	serial_port_inst : ci_uart
	generic map (
		CLK_FREQ => CLK_FREQ,
		SYNC_STAGES => 2,
		RX_FIFO_DEPTH =>16,
		TX_FIFO_DEPTH =>16,
		BAUD_RATE => BAUD_RATE
	)
	port map (
		clk           => clk,
		res_n         => res_n,
		rx            => rx,
		tx            => tx,
		tx_data       => uart_tx_data,
		tx_free       => uart_tx_free,
		tx_wr         => uart_tx_wr,
		rx_rd         => uart_rx_rd,
		rx_data       => uart_rx_data,
		rx_empty      => uart_rx_empty,
		rx_full       => open
	);

	hex_reader_inst : ci_hex_reader
	generic map (
		ABORT_CHAR => x"69",
		DATA_WIDTH => HEX_READER_DATA_WIDTH
	)
	port map (
		clk         => clk,
		res_n       => res_n,
		start       => hex_reader_start,
		done        => hex_reader_done,
		value       => hex_reader_value,
		max_length  => hex_reader_max_length,
		parse_error => hex_reader_parse_error,
		abort       => hex_reader_abort,
		rx_rd       => hex_reader_rx_rd,
		rx_data     => uart_rx_data,
		rx_empty    => uart_rx_empty
	);

	str_writer_inst : ci_str_writer
	generic map (
		STR_LENGTH => 8
	)
	port map (
		clk     => clk,
		res_n   => res_n,
		start   => str_writer_start,
		done    => str_writer_done,
		str     => str_writer_str,
		tx_wr   => str_writer_tx_wr,
		tx_data => str_writer_tx_data,
		tx_free => uart_tx_free
	);

	ci_hex_writer_inst : ci_hex_writer
	generic map (
		DATA_WIDTH => HEX_WRITER_DATA_WIDTH
	)
	port map (
		clk     => clk,
		res_n   => res_n,
		start   => hex_writer_start,
		done    => hex_writer_done,
		width   => hex_writer_width,
		value   => hex_writer_value,
		tx_wr   => hex_writer_tx_wr,
		tx_data => hex_writer_data,
		tx_free => uart_tx_free
	);

	

	uart_tx_wr <= str_writer_tx_wr or hex_writer_tx_wr;
	uart_tx_data <= hex_writer_data when hex_writer_tx_wr = '1' else str_writer_tx_data;

	uart_rx_rd <= fsm_rx_rd or hex_reader_rx_rd;

	sync : process (clk, res_n)
	begin
		if (res_n = '0') then
			fsm_state <= IDLE;
			fsm_rx_rd <= '0';
			hex_reader_start <= '0';
			hex_writer_start <= '0';
			str_writer_start <= '0';
			write_address <= (others=>'0');
			read_address <= (others=>'0');
			
		elsif (rising_edge(clk)) then
			fsm_rx_rd <= '0';
			hex_reader_start <= '0';
			hex_writer_start <= '0';
			str_writer_start <= '0';
			

			case fsm_state is
				when IDLE =>
					if (uart_rx_empty = '0') then
						fsm_state <= WAIT_READ;
						fsm_rx_rd <= '1';
					end if;

				when WAIT_READ =>
					fsm_state <= READ_COMMAND;

				when READ_COMMAND =>
					case uart_rx_data is
						when x"72" => -- 'r'
							fsm_state <= READ_OPERATION;
							hex_reader_start <= '1';
							hex_reader_max_length <= std_logic_vector(to_unsigned(ADDR_WIDTH, log2c(HEX_READER_DATA_WIDTH)));
						when x"77" => -- 'w'
							fsm_state <= WRITE_OPERATION_READ_ADDRESS;
							hex_reader_start <= '1';
							hex_reader_max_length <= std_logic_vector(to_unsigned(ADDR_WIDTH, log2c(HEX_READER_DATA_WIDTH)));
						when x"69" => -- 'i'
							fsm_state <= IDLE;
						when others =>
							fsm_state <= PRINT_ERROR;
					end case;

				when READ_OPERATION =>
					if (hex_reader_done = '1') then
						hex_writer_start <= '1';
						fsm_state <= WAIT_HEX_WRITER;
						read_address <= hex_reader_value(ADDR_WIDTH-1 downto 0);
						if(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = 0) then
							hex_writer_value(proc_time'length-1 downto 0) <= proc_time;
							hex_writer_width <= std_logic_vector(to_unsigned(proc_time'length, log2c(HEX_WRITER_DATA_WIDTH)));
						elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = 1) then
							hex_writer_value(result'length-1 downto 0) <= result;
							hex_writer_width <= std_logic_vector(to_unsigned(result'length, log2c(HEX_WRITER_DATA_WIDTH)));
						elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = 2) then
							hex_writer_value(ctrl'length-1 downto 0) <= ctrl;
							hex_writer_width <= std_logic_vector(to_unsigned(ctrl'length, log2c(HEX_WRITER_DATA_WIDTH)));
						elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = 3) then
							hex_writer_value(int_result'length-1 downto 0) <= int_result;
							hex_writer_width <= std_logic_vector(to_unsigned(int_result'length, log2c(HEX_WRITER_DATA_WIDTH)));
						elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = 4) then
							hex_writer_value(dbg2'length-1 downto 0) <= dbg2;
							hex_writer_width <= std_logic_vector(to_unsigned(dbg2'length, log2c(HEX_WRITER_DATA_WIDTH)));
						elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = 5) then
							hex_writer_value(lcm_dbg'length-1 downto 0) <= lcm_dbg;
							hex_writer_width <= std_logic_vector(to_unsigned(lcm_dbg'length, log2c(HEX_WRITER_DATA_WIDTH)));
						else
							hex_writer_start <= '0';
							fsm_state <= PRINT_ERROR;
						end if;
					elsif (hex_reader_parse_error = '1') then
						fsm_state <= PRINT_ERROR;
					elsif (hex_reader_abort = '1') then
						fsm_state <= IDLE;
					end if;

				when READ_FIFO_WAIT =>
					fsm_state <= READ_FIFO;

				when READ_FIFO =>
					hex_writer_start <= '1';
					fsm_state <= WAIT_HEX_WRITER;
					if (false) then null;
					end if;

				when WAIT_HEX_WRITER =>
					if(hex_writer_done = '1') then
						fsm_state <= IDLE;
					end if;

				when WRITE_OPERATION_READ_ADDRESS =>
					if (hex_reader_done = '1') then
						hex_reader_start <= '1';
						fsm_state <= WRITE_OPERATION_READ_DATA;
						write_address <= hex_reader_value(ADDR_WIDTH-1 downto 0);
						if (false) then null;
						else
							hex_reader_start <= '0';
							fsm_state <= PRINT_ERROR;
						end if;
					elsif (hex_reader_parse_error = '1') then
						fsm_state <= PRINT_ERROR;
					elsif (hex_reader_abort = '1') then
						fsm_state <= IDLE;
					end if;

				when WRITE_OPERATION_READ_DATA =>
					if (hex_reader_done = '1') then
						fsm_state <= PRINT_OK;
						if (false) then null;
						else
							fsm_state <= PRINT_ERROR;
						end if;
					elsif (hex_reader_parse_error = '1') then
						fsm_state <= PRINT_ERROR;
					elsif (hex_reader_abort = '1') then
						fsm_state <= IDLE;
					end if;

				when PRINT_ERROR =>
					str_writer_start <= '1';
					str_writer_str <= str_to_ascii_array("error", str_writer_str'length, True);
					fsm_state <= WAIT_PRINT_STR;

				when PRINT_OK =>
					str_writer_start <= '1';
					str_writer_str <= str_to_ascii_array("ok", str_writer_str'length, True);
					fsm_state <= WAIT_PRINT_STR;

				when WAIT_PRINT_STR =>
					if(str_writer_done = '1') then
						fsm_state <= IDLE;
					end if;
			end case;
		end if;
	end process;


end architecture;

