set_property PACKAGE_PIN K17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN M14 [get_ports error_led]
set_property IOSTANDARD LVCMOS33 [get_ports error_led]

set_property PACKAGE_PIN D18 [get_ports heartbeat_led]
set_property IOSTANDARD LVCMOS33 [get_ports heartbeat_led]

set_property PACKAGE_PIN K18 [get_ports res]
set_property IOSTANDARD LVCMOS33 [get_ports res]

set_property PACKAGE_PIN W6 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]

set_property PACKAGE_PIN V6 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]

create_clock -period 8.000 -name clk -add [get_ports clk]

#derive_pll_clocks -create_base_clocks
#derive_clock_uncertainty

set_property PACKAGE_PIN G14 [get_ports dbg_led1]
set_property PACKAGE_PIN M15 [get_ports dbg_led2]
set_property IOSTANDARD LVCMOS33 [get_ports dbg_led1]
set_property IOSTANDARD LVCMOS33 [get_ports dbg_led2]


set_property PACKAGE_PIN T16 [get_ports start_switch]
set_property IOSTANDARD LVCMOS33 [get_ports start_switch]
