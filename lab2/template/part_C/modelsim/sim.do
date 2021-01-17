
if {[file isdirectory work]} {file delete -force work};
vlib work
vmap work work

vcom -work work -2008 ../../../template/common/delay_element/delay_element_async.vhd
vcom -work work -2008 ../../../template/common/delay_element/delay_element_pkg.vhd

vcom -work work -2008 ../../../template/part_A/src/Async-Click-Library-master/misc/defs.vhd
vcom -work work -2008 ../src/lcm.vhd
vcom -work work -2008 -novopt ../src/lcm_tb.vhd

vsim work.LCM_tb -t fs -novopt
