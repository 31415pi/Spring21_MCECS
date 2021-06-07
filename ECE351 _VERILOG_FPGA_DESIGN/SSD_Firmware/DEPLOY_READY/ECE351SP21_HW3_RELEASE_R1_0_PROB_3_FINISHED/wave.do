onerror {resume}
quietly virtual function -install /tb_hw3_prob3 -env /tb_hw3_prob3 { &{/tb_hw3_prob3/disply, /tb_hw3_prob3/disply[15], /tb_hw3_prob3/disply[14], /tb_hw3_prob3/disply[13], /tb_hw3_prob3/disply[12], /tb_hw3_prob3/disply[11], /tb_hw3_prob3/disply[10], /tb_hw3_prob3/disply[9], /tb_hw3_prob3/disply[8] }} Disp1_Left
quietly virtual function -install /tb_hw3_prob3 -env /tb_hw3_prob3 { &{/tb_hw3_prob3/disply[7], /tb_hw3_prob3/disply[6], /tb_hw3_prob3/disply[5], /tb_hw3_prob3/disply[4], /tb_hw3_prob3/disply[3], /tb_hw3_prob3/disply[2], /tb_hw3_prob3/disply[1], /tb_hw3_prob3/disply[0] }} Displ_Right
quietly virtual function -install /tb_hw3_prob3 -env /tb_hw3_prob3 { &{/tb_hw3_prob3/disply[15], /tb_hw3_prob3/disply[14], /tb_hw3_prob3/disply[13], /tb_hw3_prob3/disply[12], /tb_hw3_prob3/disply[11], /tb_hw3_prob3/disply[10], /tb_hw3_prob3/disply[9], /tb_hw3_prob3/disply[8] }} Displ_Left
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_hw3_prob3/sysclk
add wave -noupdate /tb_hw3_prob3/sysreset
add wave -noupdate -radix ascii -childformat {{{/tb_hw3_prob3/disply[15]} -radix ascii} {{/tb_hw3_prob3/disply[14]} -radix ascii} {{/tb_hw3_prob3/disply[13]} -radix ascii} {{/tb_hw3_prob3/disply[12]} -radix ascii} {{/tb_hw3_prob3/disply[11]} -radix ascii} {{/tb_hw3_prob3/disply[10]} -radix ascii} {{/tb_hw3_prob3/disply[9]} -radix ascii} {{/tb_hw3_prob3/disply[8]} -radix ascii} {{/tb_hw3_prob3/disply[7]} -radix ascii} {{/tb_hw3_prob3/disply[6]} -radix ascii} {{/tb_hw3_prob3/disply[5]} -radix ascii} {{/tb_hw3_prob3/disply[4]} -radix ascii} {{/tb_hw3_prob3/disply[3]} -radix ascii} {{/tb_hw3_prob3/disply[2]} -radix ascii} {{/tb_hw3_prob3/disply[1]} -radix ascii} {{/tb_hw3_prob3/disply[0]} -radix ascii}} -subitemconfig {{/tb_hw3_prob3/disply[15]} {-radix ascii} {/tb_hw3_prob3/disply[14]} {-radix ascii} {/tb_hw3_prob3/disply[13]} {-radix ascii} {/tb_hw3_prob3/disply[12]} {-radix ascii} {/tb_hw3_prob3/disply[11]} {-radix ascii} {/tb_hw3_prob3/disply[10]} {-radix ascii} {/tb_hw3_prob3/disply[9]} {-radix ascii} {/tb_hw3_prob3/disply[8]} {-radix ascii} {/tb_hw3_prob3/disply[7]} {-radix ascii} {/tb_hw3_prob3/disply[6]} {-radix ascii} {/tb_hw3_prob3/disply[5]} {-radix ascii} {/tb_hw3_prob3/disply[4]} {-radix ascii} {/tb_hw3_prob3/disply[3]} {-radix ascii} {/tb_hw3_prob3/disply[2]} {-radix ascii} {/tb_hw3_prob3/disply[1]} {-radix ascii} {/tb_hw3_prob3/disply[0]} {-radix ascii}} /tb_hw3_prob3/disply
add wave -noupdate -divider -height 25 {Left Digit}
add wave -noupdate -radix ascii /tb_hw3_prob3/Displ_Left
add wave -noupdate /tb_hw3_prob3/dig_enable
add wave -noupdate -radix binary /tb_hw3_prob3/ccd1
add wave -noupdate -divider {Right Digit}
add wave -noupdate /tb_hw3_prob3/dig_enable_n
add wave -noupdate -radix binary /tb_hw3_prob3/ccd0
add wave -noupdate -radix ascii -childformat {{(7) -radix ascii} {(6) -radix ascii} {(5) -radix ascii} {(4) -radix ascii} {(3) -radix ascii} {(2) -radix ascii} {(1) -radix ascii} {(0) -radix ascii}} -subitemconfig {{/tb_hw3_prob3/disply[7]} {-radix ascii} {/tb_hw3_prob3/disply[6]} {-radix ascii} {/tb_hw3_prob3/disply[5]} {-radix ascii} {/tb_hw3_prob3/disply[4]} {-radix ascii} {/tb_hw3_prob3/disply[3]} {-radix ascii} {/tb_hw3_prob3/disply[2]} {-radix ascii} {/tb_hw3_prob3/disply[1]} {-radix ascii} {/tb_hw3_prob3/disply[0]} {-radix ascii}} /tb_hw3_prob3/Displ_Right
add wave -noupdate -divider -height 35 {Segment Outputs}
add wave -noupdate -radix binary /tb_hw3_prob3/dig1_segs
add wave -noupdate -radix binary /tb_hw3_prob3/dig0_segs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {49 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
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
WaveRestoreZoom {0 ns} {1744 ns}
