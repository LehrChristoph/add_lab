if {[file isdirectory work]} {file delete -force work};
vlib work
vmap work work

vcom -work work -2008 ../quartus/simulation/modelsim/lcm.vho
vcom -work work -2008 ../src/lcm_tb_netlist.vhd
