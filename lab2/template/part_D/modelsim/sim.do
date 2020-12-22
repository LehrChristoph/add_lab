
if {[file isdirectory work]} {file delete -force work};
vlib work
vmap work work

vcom -work work -2008 ../src/entities.vhd
vcom -work work -2008 ../src/delay_element.vhd
vcom -work work -2008 ../src/lcm.vhd
vcom -work work -2008 -novopt ../src/lcm_tb.vhd

vsim work.LCM_tb -t fs -novopt
