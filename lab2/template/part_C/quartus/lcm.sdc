
create_clock -name "clk" -period 20.0000ns [get_ports {clk}]

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
