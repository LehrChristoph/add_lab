

all:
	./cig.py --vhdl_out=control_port.vhd --python_out=control.py partE.yml

async:
	./cig.py partE.yml --vhdl_out ../async/part_E_async.srcs/sources_1/control_port.vhd  --python_out control.py

clean:
	rm -f control_port.vhd
	rm -f control.py
