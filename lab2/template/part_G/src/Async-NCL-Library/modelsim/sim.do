
if {[file isdirectory work]} {file delete -force work};
vlib work
vmap work work

vcom -work work -2008 ../misc/defs.vhd

vcom -work work -2008 ../components/c_element.vhd
vcom -work work -2008 ../components/c_element_3in.vhd
vcom -work work -2008 ../components/completion_detector.vhd
vcom -work work -2008 ../components/wchb_ncl.vhd
vcom -work work -2008 ../components/DEMUX.vhd
vcom -work work -2008 ../components/fork.vhd
vcom -work work -2008 ../components/join.vhd
vcom -work work -2008 ../components/MUX.vhd
vcom -work work -2008 ../components/merge.vhd
vcom -work work -2008 ../components/reg_demux.vhd
vcom -work work -2008 ../components/reg_merge.vhd
vcom -work work -2008 ../components/reg_fork.vhd
vcom -work work -2008 ../components/full_adder.vhd

vcom -work work -2008 ../funcblocks/add_block.vhd
vcom -work work -2008 ../funcblocks/sel_a_larger_b.vhd
vcom -work work -2008 ../funcblocks/sel_a_not_b.vhd

vcom -work work -2008 ../tb/c_element_tb.vhd
vcom -work work -2008 ../tb/c_element_3in_tb.vhd
vcom -work work -2008 ../tb/completion_detector_tb.vhd
vcom -work work -2008 ../tb/wchb_ncl_tb.vhd
vcom -work work -2008 ../tb/demux_tb.vhd
vcom -work work -2008 ../tb/mux_tb.vhd
vcom -work work -2008 ../tb/sel_a_not_b_tb.vhd
vcom -work work -2008 ../tb/sel_a_larger_b_tb.vhd
vcom -work work -2008 ../tb/merge_tb.vhd
vcom -work work -2008 ../tb/full_adder_tb.vhd
vcom -work work -2008 ../tb/add_block_tb.vhd

