
if {[file isdirectory work]} {file delete -force work};
vlib work
vmap work work

vcom -work work -2008 ../../../template/common/delay_element/delay_element_async.vhd
vcom -work work -2008 ../../../template/common/delay_element/delay_element_pkg.vhd

vcom -work work -2008 ../src/Async-Click-Library-master/misc/defs.vhd

vcom -work work -2008 ../src/Async-Click-Library-master/components/decoup_hs.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/DEMUX.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/fork.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/join.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/MUX.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/reg_demux.vhdl
vcom -work work -2008 ../src/Async-Click-Library-master/components/merge.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/reg_fork.vhd

vcom -work work -2008 ../src/Async-Click-Library-master/funcblocks/add_block.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/funcblocks/sel_a_larger_b.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/funcblocks/sel_a_not_b.vhd


vcom -work work -2008 ../src/lcm.vhd
vcom -work work -2008 ../src/lcm_tb.vhd

vsim work.LCM_tb -t ps
