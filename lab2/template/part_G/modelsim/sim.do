
if {[file isdirectory work]} {file delete -force work};
vlib work
vmap work work

vcom -work work -2008 ../src/Async-NCL-Library/misc/defs.vhd

vcom -work work -2008 ../src/Async-NCL-Library/components/c_element.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/c_element_3in.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/completion_detector.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/wchb_ncl.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/DEMUX.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/fork.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/join.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/MUX.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/merge.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/reg_demux.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/reg_merge.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/reg_fork.vhd
vcom -work work -2008 ../src/Async-NCL-Library/components/full_adder.vhd

vcom -work work -2008 ../src/Async-NCL-Library/funcblocks/add_block.vhd
vcom -work work -2008 ../src/Async-NCL-Library/funcblocks/sel_a_larger_b.vhd
vcom -work work -2008 ../src/Async-NCL-Library/funcblocks/sel_a_not_b.vhd

vcom -work work -2008 ../src/lcm.vhd
vcom -work work -2008 ../src/lcm_tb.vhd

vsim work.LCM_tb -t ps
