
test_c_element:
	vsim -do "do sim.do; vsim work.c_element_tb -t ps; add wave -hex /c_element_tb/* ; do cc_wave.do;  run 110 ns; wave zoom full"

test_c_element_3in:
	vsim -do "do sim.do; vsim work.c_element_3in_tb -t ps; add wave -hex /c_element_3in_tb/* ; do cc_wave.do;  run 280 ns; wave zoom full"

test_completion_detector:
	vsim -do "do sim.do; vsim work.completion_detector_tb -t ps; add wave -hex /completion_detector_tb/* ; do cc_wave.do;  run 150 ns; wave zoom full"

test_wchb_ncl:
	vsim -do "do sim.do; vsim work.wchb_ncl_tb -t ps; add wave -hex /wchb_ncl_tb/* ; do cc_wave.do;  run 160 ns; wave zoom full"

test_demux:
	vsim -do "do sim.do; vsim work.demux_tb -t ps; add wave -hex /demux_tb/* ; do cc_wave.do;  run 100 ns; wave zoom full"

test_mux:
	vsim -do "do sim.do; vsim work.mux_tb -t ps; add wave -hex /mux_tb/* ; do cc_wave.do;  run 145 ns; wave zoom full"

test_sel_a_not_b:
	vsim -do "do sim.do; vsim work.sel_a_not_b_tb -t ps; add wave -hex /sel_a_not_b_tb/* ; do cc_wave.do;  run 90 ns; wave zoom full"

test_sel_a_larger_b:
	vsim -do "do sim.do; vsim work.sel_a_larger_b_tb -t ps; add wave -hex /sel_a_larger_b_tb/* ; do cc_wave.do;  run 90 ns; wave zoom full"

test_merge:
	vsim -do "do sim.do; vsim work.merge_tb -t ps; add wave -hex /merge_tb/* ; do cc_wave.do;  run 105 ns; wave zoom full"

test_full_adder:
	vsim -do "do sim.do; vsim work.full_adder_tb -t ps; add wave -hex /full_adder_tb/* ; do cc_wave.do;  run 105 ns; wave zoom full"

test_add_block:
	vsim -do "do sim.do; vsim work.add_block_tb -t ps; add wave -hex /add_block_tb/* ; do cc_wave.do;  run 190 ns; wave zoom full"

clean:
	rm -f modelsim.ini
	rm -f vsim.wlf 
	rm -rf work
	rm -f transcript
