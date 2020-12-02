
sim:
	vsim -do "do sim.do; do cc_wave.do; run -all; wave zoom full"

sim_cl:
	vsim -c -do "do sim.do; run -all; quit"

clean:
	rm -f vsim.wlf modelsim.ini 
	rm -rf work
	rm -f transcript
