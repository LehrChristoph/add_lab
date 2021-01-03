
sim:
	vsim -do "do sim.do; do cc_wave.do; run 800ns; wave zoom full"

sim_cl:
	vsim -c -do "do sim.do; run -all; quit"

clean:
	rm -f modelsim.ini
	rm -f vsim.wlf 
	rm -rf work
	rm -f transcript
