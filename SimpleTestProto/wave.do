onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /snn_core_tb2/iDUT/hidden
add wave -noupdate /snn_core_tb2/iDUT/hUnit
add wave -noupdate /snn_core_tb2/iDUT/clk
add wave -noupdate /snn_core_tb2/iDUT/rst_n
add wave -noupdate /snn_core_tb2/iDUT/start
add wave -noupdate /snn_core_tb2/iDUT/q_input
add wave -noupdate /snn_core_tb2/iDUT/addr_input_unit
add wave -noupdate /snn_core_tb2/iDUT/digit
add wave -noupdate /snn_core_tb2/iDUT/done
add wave -noupdate /snn_core_tb2/iDUT/MAC_RESULT
add wave -noupdate /snn_core_tb2/iDUT/clr_784
add wave -noupdate /snn_core_tb2/iDUT/clr_32
add wave -noupdate /snn_core_tb2/iDUT/clr_10
add wave -noupdate /snn_core_tb2/iDUT/doCnt_784
add wave -noupdate /snn_core_tb2/iDUT/doCnt_32
add wave -noupdate /snn_core_tb2/iDUT/store
add wave -noupdate /snn_core_tb2/iDUT/comp
add wave -noupdate /snn_core_tb2/iDUT/doCnt_10
add wave -noupdate /snn_core_tb2/iDUT/clr_mac_n
add wave -noupdate /snn_core_tb2/iDUT/stage
add wave -noupdate /snn_core_tb2/iDUT/layer
add wave -noupdate /snn_core_tb2/iDUT/we_h
add wave -noupdate /snn_core_tb2/iDUT/we_o
add wave -noupdate /snn_core_tb2/iDUT/addr_f_act
add wave -noupdate /snn_core_tb2/iDUT/addr_h_u
add wave -noupdate /snn_core_tb2/iDUT/addr_o_u
add wave -noupdate /snn_core_tb2/iDUT/nxt_val
add wave -noupdate /snn_core_tb2/iDUT/val
add wave -noupdate /snn_core_tb2/iDUT/nxt_digit
add wave -noupdate /snn_core_tb2/iDUT/A
add wave -noupdate /snn_core_tb2/iDUT/B
add wave -noupdate /snn_core_tb2/iDUT/w_h
add wave -noupdate /snn_core_tb2/iDUT/w_o
add wave -noupdate /snn_core_tb2/iDUT/f_act
add wave -noupdate /snn_core_tb2/iDUT/q_output
add wave -noupdate /snn_core_tb2/iDUT/q_hidden
add wave -noupdate /snn_core_tb2/iDUT/q_input_l
add wave -noupdate /snn_core_tb2/iDUT/OF
add wave -noupdate /snn_core_tb2/iDUT/UF
add wave -noupdate /snn_core_tb2/iDUT/mac_res
add wave -noupdate /snn_core_tb2/iDUT/addr_w_h
add wave -noupdate /snn_core_tb2/iDUT/addr_w_o
add wave -noupdate /snn_core_tb2/iDUT/state
add wave -noupdate /snn_core_tb2/iDUT/nxt_state
add wave -noupdate /snn_core_tb2/iDUT/act_input
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4035 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 226
configure wave -valuecolwidth 80
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {250062 ns}
