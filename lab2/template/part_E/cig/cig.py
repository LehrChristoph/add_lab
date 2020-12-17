#!/bin/python3

import os
import sys
import math

from enum import Enum
from copy import deepcopy
from collections import OrderedDict

from docopt import docopt
import json
import yaml

from BitVector import *

usage_msg = """
Usage:
  cig.py [options] <SPEC>

Options:
  --vhdl_out FILE    VHDL output file
  --python_out FILE  Python output file
  -h        Show this screen.
"""


python_template = """
#!/bin/python3

from docopt import docopt
import serial

usage_msg = \"\"\"
Usage:
  %TOOL_NAME% [options] <INTERFACE> [VALUE]

Options:
  -d DEVICE      The UART device to use [default: /dev/ttyUSB0]
  -b BAUD_RATE   The baudrate of the UART interface [default: %DEFAULT_BAUD_RATE%]
  -c             Check if there is data to read or a free space to write data in
                 a FIFO interface.
  -h             Show this screen.
\"\"\"


def main():
	options = docopt(usage_msg, version="0.1")
	#print(options)

	uart = serial.Serial()
	uart.port = options["-d"]
	uart.baudrate = int(options["-b"])
	uart.bytesize = serial.EIGHTBITS #number of bits per bytes
	uart.parity = serial.PARITY_NONE #set parity check: no parity
	uart.stopbits = serial.STOPBITS_ONE #number of stop bits
	uart.timeout = 1       # timeout in seconds
	uart.xonxoff = False
	uart.rtscts = False
	uart.dsrdtr = False

	uart.open()

	interface_table = %INTERFACE_TABLE%

	if(options["<INTERFACE>"] not in interface_table):
		print("Unknown Interface!")
		exit(1)

	if(options["VALUE"] == None):
		if(options["-c"]):
			if(interface_table[options["<INTERFACE>"]]["type"] not in {"output_fifo", "input_fifo"}):
				print("The -c option can only be used with FIFO interfaces!")
				exit(1)
			cmd = b"ir"+ format(interface_table[options["<INTERFACE>"]]["address"]+1, 'x').encode("utf-8")+b"\\n"
		else:
			cmd = b"ir"+ format(interface_table[options["<INTERFACE>"]]["address"], 'x').encode("utf-8")+b"\\n"
		uart.write(cmd)
		response = uart.readline().decode("utf-8").strip()
		if (response.lower() == "error"):
			print("ERROR reading interface " + options["<INTERFACE>"])
			exit(1)
		print("0x" + response)
	else:
		cmd = b"iw"
		cmd += format(interface_table[options["<INTERFACE>"]]["address"], 'x').encode("utf-8") + b" "
		cmd += format(int(options["VALUE"],0), 'x').encode("utf-8")
		cmd += b"\\n"
		uart.write(cmd)
		response = uart.readline().decode("utf-8").strip()
		if (response.lower() != "ok"):
			print("ERROR writing " + options["VALUE"] + " to " + options["<INTERFACE>"])
			exit(1)


if __name__ == "__main__":
	main()

"""


vhdl_template = """

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ci_uart_pkg.all;
use work.ci_ram_pkg.all;
use work.ci_math_pkg.all;
use work.ci_util_pkg.all;


entity %ENTITY_NAME% is
	generic(
		CLK_FREQ      : integer := 50_000_000;
		BAUD_RATE     : integer := 9600
	);
	port (
		clk   : in std_logic;
		res_n : in std_logic;
		rx    : in std_logic;
		tx    : out std_logic%PORTS%
	);
end entity;

architecture arch of %ENTITY_NAME% is
	%CONSTANTS%

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

	%SIGNALS%
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

	%INSTANCES%

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
			%RESET_STATEMENTS%
		elsif (rising_edge(clk)) then
			fsm_rx_rd <= '0';
			hex_reader_start <= '0';
			hex_writer_start <= '0';
			str_writer_start <= '0';
			%DEFAULT_ASSIGNMENTS%

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
						%READ_OP_ADDR_DONE%
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
					%READ_FIFO_DONE%
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
						%WRITE_OP_ADDR_DONE%
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
						%WRITE_OP_DATA_DONE%
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

"""

output_fifo_template = """
	%INTERFACE%_fifo_inst : ci_fifo_1c1r1w
	generic map (
		MIN_DEPTH          => %DEPTH%,
		DATA_WIDTH         => %INTERFACE%_data'length
	)
	port map (
		clk        => clk,
		res_n      => res_n,
		rd_data    => %INTERFACE%_data,
		rd         => %INTERFACE%_rd,
		empty      => %INTERFACE%_empty,
		wr_data    => hex_reader_value(%INTERFACE%_data'length-1 downto 0),
		wr         => %INTERFACE%_wr,
		full       => %INTERFACE%_full,
		fill_level => open
	);
"""

def GetOutputFIFOInstance(interface_name, depth):
	code = output_fifo_template
	code = code.replace("%INTERFACE%", interface_name)
	code = code.replace("%DEPTH%", str(depth))
	return code

input_fifo_template = """
	%INTERFACE%_fifo_inst : ci_fifo_1c1r1w
	generic map (
		MIN_DEPTH          => %DEPTH%,
		DATA_WIDTH         => %INTERFACE%_data'length
	)
	port map (
		clk        => clk,
		res_n      => res_n,
		rd_data    => %INTERFACE%_rd_data,
		rd         => %INTERFACE%_rd,
		empty      => %INTERFACE%_empty,
		wr_data    => %INTERFACE%_data,
		wr         => %INTERFACE%_wr,
		full       => %INTERFACE%_full,
		fill_level => open
	);
"""

def GetInputFIFOInstance(interface_name, depth):
	code = input_fifo_template
	code = code.replace("%INTERFACE%", interface_name)
	code = code.replace("%DEPTH%", str(depth))
	return code



def main():
	options = docopt(usage_msg, version="0.1")
	print(options)

	with open(options["<SPEC>"], 'r') as stream:
		spec = yaml.load(stream, Loader=yaml.SafeLoader)

	addr_count = 0 # s.t. addr_width cannot be 0
	max_hex_reader_data_width = 4 # must be at least 4 otherwise hex_reader break
	max_hex_writer_data_width = 4
	for item_name,item in spec["interface"].items():
		if(item["type"] in {"constant", "input", "output", "event"}):
			item["address"] = addr_count
			addr_count += 1
		if(item["type"] in {"output_fifo", "input_fifo"}):
			item["address"] = addr_count
			addr_count += 2
		if(item["type"] in {"constant"}):
			max_hex_writer_data_width = max(max_hex_writer_data_width, len(BitVector(intVal=item["value"])))
		if(item["type"] in {"input", "output", "input_fifo"}):
			max_hex_writer_data_width = max(max_hex_writer_data_width, item["width"])
		if(item["type"] in {"output", "output_fifo"}):
			max_hex_reader_data_width = max(max_hex_reader_data_width, item["width"])

	addr_count = max(addr_count, 2)
	addr_width = math.ceil(math.log2(addr_count))
	max_hex_reader_data_width = max(max_hex_reader_data_width, addr_width)


	python_interface_table = {}

	ports = []
	default_assignments = ""
	reset_statements = ""
	constants = ""
	instances = ""
	read_op_cases = ""
	read_fifo_cases = ""
	write_op_addr_cases = ""
	write_op_data_cases = ""
	signals = ""

	constants += "\tconstant ADDR_WIDTH : integer := " +str(addr_width) +";\n"
	constants += "\tconstant HEX_READER_DATA_WIDTH : integer := "+str(max_hex_reader_data_width)+";\n"
	constants += "\tconstant HEX_WRITER_DATA_WIDTH : integer := "+str(max_hex_writer_data_width)+";\n"

	for name,item in spec["interface"].items():
		address = item["address"]

		python_interface_table[name] = {}
		python_interface_table[name]["address"] = address
		python_interface_table[name]["type"] = item["type"]

		if (item["type"] == "constant"):
			c = BitVector(intVal=int(str(item["value"]),0))
			read_op_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address) + ") then\n"
			read_op_cases += "\t"*7 + "hex_writer_value("+str(len(c)-1)+" downto 0) <= \"" + str(c) + "\";\n"
			read_op_cases += "\t"*7 + "hex_writer_width <= std_logic_vector(to_unsigned("+str(len(c))+", log2c(HEX_WRITER_DATA_WIDTH)));\n"
		elif (item["type"] == "input"):
			sig_width = item["width"]
			ports += [name + " : in std_logic_vector(" +str(sig_width-1)+ " downto 0)"]
			read_op_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address) + ") then\n"
			read_op_cases += "\t"*7 + "hex_writer_value(" + name + "'length-1 downto 0) <= " + name + ";\n"
			read_op_cases += "\t"*7 + "hex_writer_width <= std_logic_vector(to_unsigned(" + name + "'length, log2c(HEX_WRITER_DATA_WIDTH)));\n"
		elif (item["type"] == "output"):
			sig_width = item["width"]
			ports += [name + " : out std_logic_vector(" +str(sig_width-1)+ " downto 0)"]

			if("default" in item and item["default"] != 0):
				sig_default = BitVector(intVal=item["default"])
				reset_statements += "\t\t\t" + name + " <= (others=>'0');\n"
				reset_statements += "\t\t\t" + name + "("+ str(len(sig_default)-1) +" downto 0) <= \"" +str(sig_default)+ "\"; -- " + hex(item["default"]) + "\n"
			else:
				reset_statements += "\t\t\t" + name + " <= (others=>'0');\n"

			read_op_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address) + ") then\n"
			read_op_cases += "\t"*7 + "hex_writer_value(" + name + "'length-1 downto 0) <= " + name + ";\n"
			read_op_cases += "\t"*7 + "hex_writer_width <= std_logic_vector(to_unsigned(" + name + "'length, log2c(HEX_WRITER_DATA_WIDTH)));\n"

			write_op_addr_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address) + ") then\n"
			write_op_addr_cases += "\t"*7 + "hex_reader_max_length <= std_logic_vector(to_unsigned(" + name + "'length, log2c(HEX_WRITER_DATA_WIDTH)));\n"

			write_op_data_cases += "\t"*6 + "elsif(unsigned(write_address) = " + str(address) + ") then\n"
			write_op_data_cases += "\t"*7 + name + " <= hex_reader_value(" + name + "'length-1 downto 0);\n"
		elif (item["type"] == "event"):
			ports += [name + " : out std_logic"]
			reset_statements += "\t\t\t" + name + " <= '0';\n"
			default_assignments += "\t\t\t" + name + " <= '0';\n"

			write_op_addr_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address) + ") then\n"
			write_op_addr_cases += "\t"*7 + "hex_reader_max_length <= std_logic_vector(to_unsigned(1, log2c(HEX_WRITER_DATA_WIDTH)));\n"

			write_op_data_cases += "\t"*6 + "elsif(unsigned(write_address) = " + str(address) + " and hex_reader_value(0) = '1') then\n"
			write_op_data_cases += "\t"*7 + name + " <= '1';\n"
		elif (item["type"] == "output_fifo"):
			instances += GetOutputFIFOInstance(name, item["depth"])
			sig_width = item["width"]
			ports += [name + "_data : out std_logic_vector(" +str(sig_width-1)+ " downto 0)"]
			ports += [name + "_rd : in std_logic"]
			ports += [name + "_empty : out std_logic"]

			signals += "\tsignal " + name + "_wr : std_logic;\n"
			signals += "\tsignal " + name + "_full : std_logic;\n"

			reset_statements += "\t\t\t" + name + "_wr <= '0';\n"
			default_assignments += "\t\t\t" + name + "_wr <= '0';\n"

			write_op_addr_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address) + ") then\n"
			write_op_addr_cases += "\t"*7 + "hex_reader_max_length <= std_logic_vector(to_unsigned(" + name + "_data'length, log2c(HEX_WRITER_DATA_WIDTH)));\n"

			write_op_data_cases += "\t"*6 + "elsif(unsigned(write_address) = " + str(address) + ") then\n"
			write_op_data_cases += "\t"*7 + name + "_wr <= '1';\n"

			read_op_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address+1) + ") then\n"
			read_op_cases += "\t"*7 + "hex_writer_value(0) <= " + name + "_full;\n"
			read_op_cases += "\t"*7 + "hex_writer_width <= std_logic_vector(to_unsigned(1, log2c(HEX_WRITER_DATA_WIDTH)));\n"

		elif (item["type"] == "input_fifo"):
			instances += GetInputFIFOInstance(name, item["depth"])
			sig_width = item["width"]
			ports += [name + "_data : in std_logic_vector(" +str(sig_width-1)+ " downto 0)"]
			ports += [name + "_wr : in std_logic"]
			ports += [name + "_full : out std_logic"]

			signals += "\tsignal " + name + "_rd : std_logic;\n"
			signals += "\tsignal " + name + "_empty : std_logic;\n"
			signals += "\tsignal " + name + "_rd_data : std_logic_vector(" +str(sig_width-1)+ " downto 0);\n"

			reset_statements += "\t\t\t" + name + "_rd <= '0';\n"
			default_assignments += "\t\t\t" + name + "_rd <= '0';\n"

			read_op_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address) + ") then\n"
			read_op_cases += "\t"*7 + "fsm_state <= READ_FIFO_WAIT;\n"
			read_op_cases += "\t"*7 + name + "_rd <= '1';\n"
			read_op_cases += "\t"*7 + "hex_writer_start <= '0';\n"

			read_fifo_cases += "\t"*6 + "elsif(unsigned(read_address) = " + str(address) + ") then\n"
			read_fifo_cases += "\t"*7 + "hex_writer_value(" + name + "_data'length-1 downto 0) <= " + name + "_rd_data;\n"
			read_fifo_cases += "\t"*7 + "hex_writer_width <= std_logic_vector(to_unsigned(" + name + "_data'length, log2c(HEX_WRITER_DATA_WIDTH)));\n"

			read_op_cases += "\t"*6 + "elsif(unsigned(hex_reader_value(ADDR_WIDTH-1 downto 0)) = " + str(address+1) + ") then\n"
			read_op_cases += "\t"*7 + "hex_writer_value(0) <= not " + name + "_empty;\n"
			read_op_cases += "\t"*7 + "hex_writer_width <= std_logic_vector(to_unsigned(1, log2c(HEX_WRITER_DATA_WIDTH)));\n"

	def post_process(x):
		x = x.strip()
		x = x.lstrip("els")
		if (x == ""):
			x = "if (false) then null;"
		return x


	read_op_cases = post_process(read_op_cases)
	read_fifo_cases = post_process(read_fifo_cases)
	write_op_addr_cases = post_process(write_op_addr_cases)
	write_op_data_cases = post_process(write_op_data_cases)


	vhdl_code = vhdl_template
	vhdl_code = vhdl_code.replace("%ENTITY_NAME%", spec["general"]["name"])
	vhdl_code = vhdl_code.replace("%CONSTANTS%", constants.strip())
	vhdl_code = vhdl_code.replace("%READ_OP_ADDR_DONE%", read_op_cases)
	vhdl_code = vhdl_code.replace("%READ_FIFO_DONE%", read_fifo_cases)
	vhdl_code = vhdl_code.replace("%WRITE_OP_ADDR_DONE%", write_op_addr_cases)
	vhdl_code = vhdl_code.replace("%WRITE_OP_DATA_DONE%", write_op_data_cases)
	vhdl_code = vhdl_code.replace("%RESET_STATEMENTS%", reset_statements.strip())
	vhdl_code = vhdl_code.replace("%DEFAULT_ASSIGNMENTS%", default_assignments.strip())
	vhdl_code = vhdl_code.replace("%INSTANCES%", instances)
	vhdl_code = vhdl_code.replace("%SIGNALS%", signals.strip())

	ports_str = ""
	for p in ports:
		ports_str += ";\n\t\t"+p
	vhdl_code = vhdl_code.replace("%PORTS%", ports_str)

	if(options["--vhdl_out"] != None):
		with open(options["--vhdl_out"], 'w') as f:
			f.write(vhdl_code)

	python_code = python_template
	python_code = python_code.replace("%DEFAULT_BAUD_RATE%", "9600")
	python_code = python_code.replace("%INTERFACE_TABLE%", json.dumps(python_interface_table))

	if(options["--python_out"] != None):

		python_code = python_code.replace("%TOOL_NAME%",os.path.basename(options["--python_out"]))

		with open(options["--python_out"], 'w') as f:
			f.write(python_code)

	#print(code)


if __name__ == "__main__":
	main()

