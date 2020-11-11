## Generated SDC file "C:/Users/tom/Projects/ltd_d_ff/src/quartus/ltd_d_ff_top_de2_115.sdc"

## Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus II License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 14.0.0 Build 200 06/17/2014 SJ Full Version"

## DATE    "Fri Feb 06 13:40:30 2015"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]
create_clock -name {data_in} -period 35.714 -waveform { 0.000 17.857 } [get_ports {data_in}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 3 -master_clock {clk} [get_pins {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 3 -master_clock {clk} [get_pins {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]} -source [get_pins {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 3 -master_clock {clk} [get_pins {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] 
create_generated_clock -name {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {data_in} [get_pins {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] 

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {data_in}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {data_in}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {data_in}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {data_in}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {data_in}] -rise_to [get_clocks {data_in}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {data_in}] -fall_to [get_clocks {data_in}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {data_in}] -rise_to [get_clocks {data_in}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {data_in}] -fall_to [get_clocks {data_in}]  0.020 

#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {**}] -to [get_keepers {*phasedone_state*}]
set_false_path -from [get_keepers {**}] -to [get_keepers {*internal_phasestep*}]

set_false_path  -from  [get_clocks {clk}]  -to  [get_clocks {data_in}]
set_false_path  -from  [get_clocks {data_in}]  -to  [get_clocks {clk}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {data_in}]
set_false_path  -from  [get_clocks {data_in}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  -to  [get_clocks {data_in}]
set_false_path  -from  [get_clocks {data_in}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  -to  [get_clocks {data_in}]
set_false_path  -from  [get_clocks {data_in}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]
set_false_path  -from  [get_clocks {clk}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {clk}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|data_mul_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {top_inst|ltd_d_ff_inst|delay_line_inst|clk_mul_inst|altpll_component|auto_generated|pll1|clk[2]}]

#**************************************************************
# Set Multicycle Path
#**************************************************************


#**************************************************************
# Set Maximum Delay
#**************************************************************
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|d_ff:uut|q}]                               -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|d_ff:ref_inst|q}]             1.011
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|d_ff:uut|q}]                               -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|d_ff:det_inst|q}]             1.200
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|d_ff:ref_inst|q}]             -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:ref_sync1_inst|sync[1]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:ref_sync1_inst|sync[1]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:ref_sync1_inst|sync[2]}] 1.040
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:ref_sync1_inst|sync[2]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:ref_sync1_inst|sync[3]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:ref_sync1_inst|sync[3]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:ref_sync2_inst|sync[1]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|d_ff:det_inst|q}]             -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync1_inst|sync[1]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync1_inst|sync[1]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync1_inst|sync[2]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync1_inst|sync[2]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync1_inst|sync[3]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync1_inst|sync[3]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync2_inst|sync[1]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync2_inst|sync[1]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync2_inst|sync[2]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync2_inst|sync[2]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync2_inst|sync[3]}] 1.000
set_max_delay -from [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync2_inst|sync[3]}] -to [get_registers {ltd_d_ff_top:top_inst|ltd_d_ff:ltd_d_ff_inst|ltd:ltd_inst|sync:det_sync2_inst|sync[4]}] 1.000



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************
