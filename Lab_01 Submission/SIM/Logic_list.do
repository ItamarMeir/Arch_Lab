onerror {resume}
add list -width 21 /tb_logic/Y_Logic_i
add list /tb_logic/X_Logic_i
add list /tb_logic/Logic_o
add list /tb_logic/ALUFN
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
