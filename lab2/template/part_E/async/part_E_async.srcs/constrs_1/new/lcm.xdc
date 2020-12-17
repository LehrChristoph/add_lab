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

create_clock -add -name clk -period 8.00 [get_ports { clk }];#set

#derive_pll_clocks -create_base_clocks
#derive_clock_uncertainty
