onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_logic/Y_Logic_i
add wave -noupdate /tb_logic/X_Logic_i
add wave -noupdate /tb_logic/Logic_o
add wave -noupdate /tb_logic/ALUFN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1599146 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {1599050 ps} {1600050 ps}
