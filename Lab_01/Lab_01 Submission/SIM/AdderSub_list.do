onerror {resume}
add list -width 16 /tb_addersub/x
add list /tb_addersub/y
add list /tb_addersub/Sout
add list /tb_addersub/FN
add list /tb_addersub/Cout
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
