
if {[file isdirectory work]} {file delete -force work};
vlib work


vcom -work work -2008 ../src/utils/add_block.vhd
vcom -work work -2008 ../src/utils/demux_1to2.vhd
vcom -work work -2008 ../src/utils/mux_2to1.vhd
vcom -work work -2008 ../src/utils/reg.vhd
vcom -work work -2008 ../src/utils/reg_ena_done.vhd
vcom -work work -2008 ../src/utils/sel_a_larger_b.vhd
vcom -work work -2008 ../src/utils/sel_a_not_b.vhd
vcom -work work -2008 ../src/utils/utils_pkg.vhd

vcom -work work -2008 ../src/lcm.vhd
vcom -work work -2008 ../src/lcm_tb.vhd

vsim work.LCM_tb -t ns -novopt
