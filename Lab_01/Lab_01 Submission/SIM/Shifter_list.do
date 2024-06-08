onerror {resume}
add list -width 25 /tb_shifter/X_Shifter_i
add list /tb_shifter/Y_Shifter_i
add list /tb_shifter/Shifter_o
add list /tb_shifter/ALUFN
add list /tb_shifter/Shifter_cout
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
