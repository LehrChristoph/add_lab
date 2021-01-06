
if {[file isdirectory work]} {file delete -force work};
vlib work


vcom -work work -2008 ../src/lcm.vhd
vcom -work work -2008 ../src/lcm_tb.vhd

vsim work.LCM_tb -t ns
