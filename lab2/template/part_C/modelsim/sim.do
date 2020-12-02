
if {[file isdirectory work]} {file delete -force work};
vlib work

vmap altera_mf ../../../template/common/altera_mf

vcom -work work -2008 -novopt ../src/lcm_tb.vhd

vsim work.LCM_tb -t fs -novopt
