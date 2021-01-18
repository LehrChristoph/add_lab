onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -unsigned /LCM_tb/A /LCM_tb/B /LCM_tb/result /LCM_tb/req_AB /LCM_tb/ack_AB /LCM_tb/req_result /LCM_tb/ack_result



add wave -hex -group LCM_CALC /lcm_tb/lcm_calc/*

add wave -noupdate -group m1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataA\\
add wave -noupdate -group m1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataB\\
add wave -noupdate -group m1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|m1_dataC\\
add wave -noupdate -group fr1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataA\\
add wave -noupdate -group fr1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataB\\
add wave -noupdate -group fr1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr1_dataC\\
add wave -noupdate -group cmp1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp1_in_data\\
add wave -noupdate -group de1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataA\\
add wave -noupdate -group de1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataB\\
add wave -noupdate -group de1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de1_dataC\\
add wave -noupdate -group add1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataA\\
add wave -noupdate -group add1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataB\\
add wave -noupdate -group add1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add1_dataC\\
add wave -noupdate -group add2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataA\\
add wave -noupdate -group add2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataB\\
add wave -noupdate -group add2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|add2_dataC\\
add wave -noupdate -group mrg1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataA\\
add wave -noupdate -group mrg1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataB\\
add wave -noupdate -group mrg1 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|mrg1_dataC\\
add wave -noupdate -group fr2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataA\\
add wave -noupdate -group fr2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataB\\
add wave -noupdate -group fr2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|fr2_dataC\\
add wave -noupdate -group cmp2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|cmp2_in_data\\
add wave -noupdate -group de2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataA\\
add wave -noupdate -group de2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataB\\
add wave -noupdate -group de2 -radix hexadecimal /lcm_tb/lcm_calc/\\lcm_calc|de2_dataC\\


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
