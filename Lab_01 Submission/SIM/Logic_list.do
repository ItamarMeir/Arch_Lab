onerror {resume}
add list -width 15 /tb/Y_Logic_i
add list /tb/X_Logic_i
add list /tb/Logic_o
add list /tb/ALUFN
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
