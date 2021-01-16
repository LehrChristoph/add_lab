
#!/bin/python3

from docopt import docopt
import serial

usage_msg = """
Usage:
  control.py [options] <INTERFACE> [VALUE]

Options:
  -d DEVICE      The UART device to use [default: /dev/ttyUSB0]
  -b BAUD_RATE   The baudrate of the UART interface [default: 9600]
  -c             Check if there is data to read or a free space to write data in
                 a FIFO interface.
  -h             Show this screen.
"""


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

	interface_table = {"proc_time": {"address": 0, "type": "input"}, "result": {"address": 1, "type": "input"}, "ctrl": {"address": 2, "type": "input"}, "int_result": {"address": 3, "type": "input"}, "dbg2": {"address": 4, "type": "input"}, "lcm_dbg": {"address": 5, "type": "input"}}

	if(options["<INTERFACE>"] not in interface_table):
		print("Unknown Interface!")
		exit(1)

	if(options["VALUE"] == None):
		if(options["-c"]):
			if(interface_table[options["<INTERFACE>"]]["type"] not in {"output_fifo", "input_fifo"}):
				print("The -c option can only be used with FIFO interfaces!")
				exit(1)
			cmd = b"ir"+ format(interface_table[options["<INTERFACE>"]]["address"]+1, 'x').encode("utf-8")+b"\n"
		else:
			cmd = b"ir"+ format(interface_table[options["<INTERFACE>"]]["address"], 'x').encode("utf-8")+b"\n"
		uart.write(cmd)
		response = uart.readline().decode("utf-8").strip()
		if (response.lower() == "error"):
			print("ERROR reading interface " + options["<INTERFACE>"])
			exit(1)
		print(f"0x{response} (0b{int(response, 16):b}) ({int(response, 16)})")
	else:
		cmd = b"iw"
		cmd += format(interface_table[options["<INTERFACE>"]]["address"], 'x').encode("utf-8") + b" "
		cmd += format(int(options["VALUE"],0), 'x').encode("utf-8")
		cmd += b"\n"
		uart.write(cmd)
		response = uart.readline().decode("utf-8").strip()
		if (response.lower() != "ok"):
			print("ERROR writing " + options["VALUE"] + " to " + options["<INTERFACE>"])
			exit(1)


if __name__ == "__main__":
	main()

