

VCOM_ARGS=-2008 -work work -suppress 1236
VSIM_ARGS=-msgmode both

# The order is important!
VHDL_FILES = \
	math_pkg.vhd\
	./sync/sync_pkg.vhd\
	./sync/sync.vhd\
	./debounce/debounce_pkg.vhd\
	./debounce/debounce.vhd\
	./debounce/debounce_fsm.vhd\
	./ram/ram_pkg.vhd\
	./ram/dp_ram_1c1r1w.vhd\
	./ram/fifo_1c1r1w.vhd\
	./ram/fifo_2c1r1w.vhd\
	./serial_port/serial_port_pkg.vhd\
	./serial_port/serial_port.vhd\
	./serial_port/serial_port_receiver.vhd\
	./serial_port/serial_port_transmitter.vhd\
	./mainbus/reg_pkg.vhd\
	./mainbus/mainbus_coupling_pkg.vhd\
	./mainbus/serial_mainbus_pkg.vhd\
	./mainbus/mainbus_pkg.vhd\
	./mainbus/mainbus_coupling_no_local_address_1cyc.vhd\
	./mainbus/mainbus_coupling_readonly.vhd\
	./mainbus/mainbus_coupling.vhd\
	./mainbus/mainbus_coupling_string.vhd\
	./mainbus/mainbus_coupling_constant.vhd\
	./mainbus/reg_1rw_1c.vhd\
	./mainbus/mainbus_coupling_rom.vhd\
	./mainbus/mainbus.vhd\
	./mainbus/serial_mainbus.vhd\
	./mainbus/mainbus_coupling_value_1cyc.vhd\
	./ltd/ltd_d_ff_pkg.vhd\
	./ltd/ltd_pkg.vhd\
	./ltd/d_ff_pkg.vhd\
	./ltd/fast_cnt_pkg.vhd\
	./ltd/ltd_d_ff_top_pkg.vhd\
	./ltd/fast_cnt_capture_pkg.vhd\
	./ltd/fast_cnt_capture.vhd\
	./ltd/ltd_d_ff_top.vhd\
	./ltd/fast_cnt.vhd\
	./ltd/cal_data_gen.vhd\
	./ltd/controller.vhd\
	./ltd/ltd_d_ff_top_de2_115.vhd\
	./ltd/counter_unit.vhd\
	./ltd/delay_line_de2_115.vhd\
	./ltd/d_ff.vhd\
	./ltd/ltd_d_ff.vhd\
	./ltd/ltd.vhd


TB_FILES = 

TIME_RESOLUTION = 1ps
TB = 

# For the simulation time -all can also be selected. Questa then simulates until no more singal changes occour.
SIM_TIME = 1 us
WAVE_FILE = 

compile: log 

log: $(VHDL_FILES) $(TB_FILES)
	rm -f log
	vlib work | tee log
	for i in $(VHDL_FILES); do \
		vcom $(VCOM_ARGS) $$i | tee -a log;\
	done;
	for i in $(TB_FILES); do \
		vcom $(VCOM_ARGS) $$i | tee -a log;\
	done;
	@echo "--------------------------------------------------------------"
	@echo "--              Error and Warning Summary                   --"
	@echo "--------------------------------------------------------------"
	@cat log | grep 'Warning\|Error'
	@if [[ $$(grep "Error:" -m 1 log) ]]; then \
		echo "Compilation had errors!" \
		exit 1; \
	fi;

list_sources:
	@for i in $(VHDL_FILES) $(TB_FILES); do \
		echo $$i;\
	done;

sim_gui: compile
	vsim -do "vsim $(TB) -t $(TIME_RESOLUTION) $(VSIM_ARGS); do $(WAVE_FILE);run $(SIM_TIME)" 

sim: compile
	vsim -c -do "vsim $(TB) -t $(TIME_RESOLUTION) $(VSIM_ARGS); run $(SIM_TIME);quit"

clean:
	rm -f transcript
	rm -f vsim.wlf
	rm -f log
	rm -fr work

.PHONY: clean
.PHONY: compile
.PHONY: sim
.PHONY: sim_gui



