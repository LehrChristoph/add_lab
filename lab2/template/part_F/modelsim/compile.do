if {[file isdirectory work]} {file delete -force work};
vlib work
vmap work work

vcom -work work -2008 ../../../template/common/delay_element/delay_element_async.vhd
vcom -work work -2008 ../../../template/common/delay_element/delay_element_pkg.vhd
vcom -work work -2008 ../workcraft/workcraft_pkg.vhd
vcom -work work -2008 ../workcraft/C2_r_lut.vhd
vcom -work work -2008 ../workcraft/C2_r.vhd
vcom -work work -2008 ../workcraft/C2_s_lut.vhd
vcom -work work -2008 ../workcraft/C2_s.vhd
vcom -work work -2008 ../workcraft/C2_lut.vhd
vcom -work work -2008 ../workcraft/C2.vhd

vcom -work work -2008 ../src/Async-Click-Library-master/misc/defs.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/handshake.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/handshake_dual_input.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/handshake_dual_output.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/decoup_hs.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/DEMUX.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/fork.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/MUX.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/merge.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/components/reg_fork.vhd


vcom -work work -2008 ../src/Async-Click-Library-master/funcblocks/add_block.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/funcblocks/sel_a_larger_b.vhd
vcom -work work -2008 ../src/Async-Click-Library-master/funcblocks/sel_a_not_b.vhd


vcom -work work -2008 ../src/lcm.vhd
vcom -work work -2008 ../src/lcm_tb.vhd
