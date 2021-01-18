onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /lcm_tb/A
add wave -noupdate -radix unsigned /lcm_tb/B
add wave -noupdate -radix unsigned /lcm_tb/result
add wave -noupdate -radix unsigned /lcm_tb/req_AB
add wave -noupdate -radix unsigned /lcm_tb/ack_AB
add wave -noupdate -radix unsigned /lcm_tb/req_result
add wave -noupdate -radix unsigned /lcm_tb/ack_result
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/clk
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/res_n
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/A
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/B
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/A_deb
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/B_deb
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/req_AB
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ack_AB
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/result
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/req_result
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ack_result
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/gnd
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/vcc
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/unknown
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/devoe
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/devclrn
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/devpor
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_devoe
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_devclrn
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_devpor
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_clk
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_res_n
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_A
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_B
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_A_deb
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_B_deb
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_req_AB
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_ack_AB
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_result
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_req_result
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/ww_ack_result
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\clk~inputclkctrl_INCLK_bus\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|handshake_in|c_elem|C2_r_inst|Q_lut_output~1clkctrl_INCLK_bus\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|en~clkctrl_INCLK_bus\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|handshake_in|c_elem|C2_r_inst|Q_lut_output~1clkctrl_INCLK_bus\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|en~clkctrl_INCLK_bus\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|en~clkctrl_INCLK_bus\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|en~clkctrl_INCLK_bus\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|data_out~clkctrl_INCLK_bus\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\A_deb\[0\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\A_deb\[1\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\A_deb\[2\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\A_deb\[3\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\B_deb\[0\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\B_deb\[1\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\B_deb\[2\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\B_deb\[3\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_AB~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\result\[0\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\result\[1\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\result\[2\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\result\[3\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\result\[4\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\result\[5\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\result\[6\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\result\[7\]~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_result~output_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\A\[0\]~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\A\[1\]~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\A\[2\]~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\A\[3\]~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\B\[0\]~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\B\[1\]~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\B\[2\]~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\B\[3\]~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_ackSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|r1_out_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|en~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|en~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|en~clkctrl_outclk\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|en~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|en~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|en~clkctrl_outclk\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|handshake_in|c_elem|C2_r_inst|Q_lut_output~1clkctrl_outclk\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|en~clkctrl_outclk\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_ackB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_ackC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\clk~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\clk~inputclkctrl_outclk\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\res_n~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|input_sync_last~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|input_sync_last~q\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|counter_reset~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|counter\[0\]~3_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|counter\[1\]~2_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|Add0~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|counter\[2\]~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|counter~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|data_out~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|data_out~q\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_ackB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|comb~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_reqC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_reqA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|f1_reqC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_reqSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|input_sync_last~q\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|counter_reset~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|counter\[0\]~3_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|counter\[1\]~2_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|Add0~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|counter\[2\]~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|counter~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|data_out~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|data_out~q\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|handshake_in|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|handshake_in|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|handshake_in|c_elem|C2_r_inst|Q_lut_output~1clkctrl_outclk\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|en~clkctrl_outclk\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~21_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|data_out~clkctrl_outclk\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~21_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[0\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~9_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[0\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[0\]~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~9_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[1\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~8_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[1\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~20_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~20_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[0\]~1\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[1\]~2_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~8_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[8\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[8\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~16_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~16_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[0\]~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[9\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~17_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~17_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[0\]~1\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[1\]~2_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|Equal0~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~22_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~22_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[3\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~10_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[3\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~23_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~23_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[1\]~3\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[2\]~4_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~11_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[2\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~11_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[2\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[2\]~5\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[3\]~6_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~10_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[10\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~2_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[10\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~18_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~18_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[1\]~3\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[2\]~4_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~2_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~19_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~19_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~3_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[11\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[2\]~5\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[3\]~6_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~3_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|Equal0~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[5\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~12_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[5\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[3\]~7\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[4\]~8_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~13_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[4\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~13_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[4\]~9\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[5\]~10_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~12_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[12\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~4_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[12\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[3\]~7\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[4\]~8_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~4_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[13\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~5_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[4\]~9\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[5\]~10_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~5_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|Equal0~2_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[14\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~6_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[14\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[5\]~11\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[6\]~12_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~6_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[7\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~14_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[7\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[5\]~11\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[6\]~12_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~15_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~15_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[6\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[6\]~13\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[7\]~14_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~14_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[6\]~13\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[7\]~14_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~7_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|Equal0~3_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_out_data~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|r1_in_data~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|r1_out_data~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[15\]~feeder_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~7_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~1_cout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~3_cout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~5_cout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~7_cout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~9_cout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~11_cout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~13_cout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~14_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_out_data~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_reqB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_in_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:0:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:1:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:2:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:3:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:4:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:5:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:6:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:7:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:8:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:9:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:10:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:11:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:12:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:13:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:14:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:15:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:16:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:17:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:18:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:19:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:20:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:21:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:22:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:23:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:24:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_out_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_reqB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|inA_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_ackA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_ackC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|handshake_B|c_elem_reset:c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_ackB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_out_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_in_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_ackB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_ackA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_out_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_in_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_ackC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|comb~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_reqC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_reqA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outB_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_reqB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_in_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:0:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:1:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:2:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:3:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:4:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:5:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:6:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:7:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:8:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:9:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:10:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:11:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:12:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:13:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:14:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:15:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:16:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:17:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:18:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:19:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:20:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:21:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:22:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:23:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:24:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_out_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_reqSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|handshake_in|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|handshake_in|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_reqC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_in_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:0:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:1:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:2:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:3:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:4:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:5:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:6:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:7:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:8:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:9:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:10:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:11:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:12:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:13:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:14:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:15:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:16:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:17:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:18:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:19:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:20:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:21:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:22:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:23:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:24:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_out_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_reqA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|handshake_A|c_elem_reset:c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_reqC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_reqA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|inA_req~buf0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|f1_ackA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_out_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_in_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_ackB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outB_ack~buf0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_ackA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_ackC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_ack~buf0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|handshake|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|handshake|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outB_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_reqB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_in_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:0:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:1:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:2:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:3:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:4:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:5:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:6:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:7:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:8:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:9:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:10:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:11:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:12:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:13:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:14:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:15:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:16:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:17:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:18:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:19:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:20:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:21:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:22:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:23:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:24:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:25:cmp_LUT~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_out_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|f1_reqA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|r1_in_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|f1_ackB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_ackSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|f1_ackC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|f1_fork_select_in_output|handshake_inst|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|f1_fork_select_in_output|handshake_inst|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|f1_reqB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|r1_in_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|r1_buffer_input_sel|handshake_inst|c_elem_set:c_elem|C2_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|r1_out_req~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_reqSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_reqC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_reqB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|handshakeB|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|handshakeB|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_reqC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_reqA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|inA_req~buf0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_ackA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_ackC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_ack~buf0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_ackSel~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_out_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_in_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_ackB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outB_ack~buf0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|handshake|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|handshake|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|inA_ack~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_ackA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_ackC~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB~input_o\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|input_sync_last~q\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|counter_reset~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|counter\[0\]~3_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|counter\[1\]~2_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|Add0~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|counter\[2\]~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|counter~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|data_out~0_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|data_out~q\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_reqA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|handshakeA|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|handshakeA|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_ackA~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_reqB~combout\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataC\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataA\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataA\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataB\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataA\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataC\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataA\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataB\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataB\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataC\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataB\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataA\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|counter\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataC\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outB_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataC\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataB\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_in_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|sync_inst|sync\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|outB_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataA\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|counter\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|outC_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\req_AB_sync|sync_inst|sync\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataC\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|outB_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_in_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataC\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataB\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|r1_buffer_input_sel|out_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataB\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataB\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outB_data\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\ack_result_sync|counter\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataA\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataC\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\sys_reset_sync|sync_inst|sync\\
add wave -noupdate -group LCM_CALC -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\A\[0\]~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\A\[1\]~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\A\[2\]~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\A\[3\]~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\A_deb\[0\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\A_deb\[1\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\A_deb\[2\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\A_deb\[3\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_AB~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|Add0~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|counter\[0\]~3_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|counter\[1\]~2_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|counter\[2\]~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|counter\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|counter_reset~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|counter~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|data_out~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|data_out~q\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|input_sync_last~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|input_sync_last~q\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result_sync|sync_inst|sync\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\ack_result~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\B\[0\]~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\B\[1\]~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\B\[2\]~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\B\[3\]~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\B_deb\[0\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\B_deb\[1\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\B_deb\[2\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\B_deb\[3\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\clk~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\clk~inputclkctrl_INCLK_bus\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\clk~inputclkctrl_outclk\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:0:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:1:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:2:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:3:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:4:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:5:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:6:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:7:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:8:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:9:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:10:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:11:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:12:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:13:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:14:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:15:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:16:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:17:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:18:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:19:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:20:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:21:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:22:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:23:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|delay_req|g_luts:24:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[0\]~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[0\]~1\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[1\]~2_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[1\]~3\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[2\]~4_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[2\]~5\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[3\]~6_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[3\]~7\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[4\]~8_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[4\]~9\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[5\]~10_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[5\]~11\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[6\]~12_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[6\]~13\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_A_sumA|outC_data\[7\]~14_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_dataB\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_dataC\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_in_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_in_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_out_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add1_out_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:0:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:1:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:2:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:3:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:4:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:5:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:6:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:7:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:8:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:9:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:10:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:11:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:12:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:13:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:14:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:15:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:16:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:17:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:18:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:19:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:20:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:21:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:22:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:23:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|delay_req|g_luts:24:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[0\]~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[0\]~1\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[1\]~2_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[1\]~3\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[2\]~4_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[2\]~5\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[3\]~6_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[3\]~7\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[4\]~8_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[4\]~9\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[5\]~10_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[5\]~11\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[6\]~12_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[6\]~13\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_B_sumB|outC_data\[7\]~14_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_dataB\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_dataC\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_in_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_in_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_out_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|add2_out_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_in_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_in_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_in_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_out_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_out_data~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_out_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:0:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:1:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:2:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:3:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:4:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:5:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:6:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:7:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:8:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:9:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:10:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:11:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:12:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:13:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:14:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:15:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:16:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:17:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:18:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:19:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:20:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:21:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:22:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:23:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|delay_req|g_luts:24:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~1_cout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~3_cout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~5_cout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~7_cout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~9_cout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~11_cout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~13_cout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp1_sA_g_sB|LessThan0~14_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_in_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_in_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_in_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_out_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_out_data~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_out_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:0:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:1:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:2:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:3:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:4:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:5:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:6:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:7:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:8:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:9:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:10:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:11:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:12:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:13:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:14:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:15:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:16:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:17:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:18:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:19:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:20:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:21:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:22:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:23:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:24:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|DELAY_REQ|g_luts:25:cmp_LUT~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|Equal0~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|Equal0~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|Equal0~2_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|cmp2_sA_ne_sB|Equal0~3_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_ackA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_ackB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_ackC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_ackSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|comb~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|handshake_in|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|handshake_in|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|handshake_in|c_elem|C2_r_inst|Q_lut_output~1clkctrl_INCLK_bus\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|handshake_in|c_elem|C2_r_inst|Q_lut_output~1clkctrl_outclk\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_choose_sum|outB_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_dataB\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_dataC\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_dataSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_reqA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_reqB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_reqC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de1_reqSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_ackA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_ackB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_ackC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_ackSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|comb~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|handshake_in|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|handshake_in|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|handshake_in|c_elem|C2_r_inst|Q_lut_output~1clkctrl_INCLK_bus\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|handshake_in|c_elem|C2_r_inst|Q_lut_output~1clkctrl_outclk\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|outB_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_choose_result|outC_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_dataB\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_dataC\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_dataSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_reqA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_reqB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_reqC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|de2_reqSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|f1_ackA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|f1_ackB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|f1_ackC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|f1_fork_select_in_output|handshake_inst|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|f1_fork_select_in_output|handshake_inst|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|f1_reqA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|f1_reqB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|f1_reqC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_ackA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_ackB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_ackC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataB\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataC\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|en~clkctrl_INCLK_bus\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|en~clkctrl_outclk\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|en~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|handshake|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|handshake|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|inA_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|inA_req~buf0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outB_ack~buf0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outB_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outB_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_ack~buf0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[0\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[1\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[2\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[3\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[5\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[6\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[7\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[8\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[9\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[10\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[11\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[12\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\[14\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_fork_reg|outC_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_reqA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_reqB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr1_reqC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_ackA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_ackB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_ackC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataB\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataC\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|en~clkctrl_INCLK_bus\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|en~clkctrl_outclk\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|en~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|handshake|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|handshake|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|inA_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|inA_req~buf0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outB_ack~buf0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outB_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outB_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_ack~buf0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[0\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[1\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[2\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[3\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[4\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[5\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[7\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[8\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[10\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[12\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[13\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[14\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\[15\]~feeder_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_fork_reg|outC_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_reqA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_reqB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|fr2_reqC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_ackA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_ackB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_ackC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_ackSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_dataB\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_dataC\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_dataSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_reqA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_reqB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_reqC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_reqSel~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|en~clkctrl_INCLK_bus\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|en~clkctrl_outclk\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|en~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|handshakeA|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|handshakeA|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|handshakeB|c_elem1|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|handshakeB|c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~2_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~3_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~4_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~5_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~6_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~7_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~8_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~9_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~10_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~11_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~12_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~13_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~14_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~15_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~16_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~17_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~18_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~19_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~20_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~21_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~22_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|m1_select_input|outC_data~23_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_ackA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_ackB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_ackC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataA\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataB\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataC\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|en~clkctrl_INCLK_bus\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|en~clkctrl_outclk\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|en~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|handshake_A|c_elem_reset:c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|handshake_B|c_elem_reset:c_elem|C2_r_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~2_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~3_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~4_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~5_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~6_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~7_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~8_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~9_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~10_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~11_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~12_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~13_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~14_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~15_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~16_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~17_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~18_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~19_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~20_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~21_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~22_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_merge_sums|outC_data~23_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_reqA~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_reqB~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|mrg1_reqC~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|r1_buffer_input_sel|handshake_inst|c_elem_set:c_elem|C2_inst|Q_lut_output~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|r1_buffer_input_sel|out_data\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|r1_in_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|r1_in_data~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|r1_in_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|r1_out_ack~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|r1_out_data~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\lcm_calc|r1_out_req~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|Add0~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|counter\[0\]~3_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|counter\[1\]~2_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|counter\[2\]~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|counter\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|counter_reset~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|counter~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|data_out~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|data_out~q\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|input_sync_last~q\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB_sync|sync_inst|sync\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_AB~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\req_result~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\res_n~input_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\result\[0\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\result\[1\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\result\[2\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\result\[3\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\result\[4\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\result\[5\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\result\[6\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\result\[7\]~output_o\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|Add0~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|counter\[0\]~3_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|counter\[1\]~2_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|counter\[2\]~1_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|counter\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|counter_reset~combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|counter~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|data_out~0_combout\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|data_out~clkctrl_INCLK_bus\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|data_out~clkctrl_outclk\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|data_out~q\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|input_sync_last~q\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/\\sys_reset_sync|sync_inst|sync\\
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/A
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/A_deb
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ack_AB
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ack_result
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/B
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/B_deb
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/clk
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/devclrn
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/devoe
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/devpor
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/gnd
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/req_AB
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/req_result
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/res_n
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/result
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/unknown
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/vcc
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_A
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_A_deb
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_ack_AB
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_ack_result
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_B
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_B_deb
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_clk
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_devclrn
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_devoe
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_devpor
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_req_AB
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_req_result
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_res_n
add wave -noupdate -group lcm_top /lcm_tb/lcm_calc/ww_result
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataA\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataB\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataC\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataA\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataB\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataC\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataA\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataB\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataC\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataA\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataB\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataC\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataA\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataB\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataC\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataA\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataB\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataC\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_in_data\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_in_data\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataA\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataB\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataC\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataA\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataB\\
add wave -noupdate -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataC\\
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1264993 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 262
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {8400 ns}
