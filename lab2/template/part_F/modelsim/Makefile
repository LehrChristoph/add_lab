
sim:
	vsim -do "do sim.do; do cc_wave.do; run -all; wave zoom full"

sim_cl:
	vsim -c -do "do sim.do; run -all; quit"

sim_netlist:
	vsim -do "do sim_netlist.do; do cc_wave_netlist.do; run 8000 ns; wave zoom full"

sim_netlist_cl:
	vsim -c -do "do sim_netlist.do; run -all; quit"

clean:
	rm -f modelsim.ini
	rm -f vsim.wlf
	rm -rf work
	rm -f transcript
