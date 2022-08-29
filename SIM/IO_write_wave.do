onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_tb/clock
add wave -noupdate -divider CPU
add wave -noupdate -radix hexadecimal /mips_tb/PC
add wave -noupdate /mips_tb/Memwrite_out
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IO/CS
add wave -noupdate -divider IO
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IO/CS
add wave -noupdate /mips_tb/Swithes
add wave -noupdate /mips_tb/LEDG
add wave -noupdate /mips_tb/LEDR
add wave -noupdate /mips_tb/HEX0
add wave -noupdate /mips_tb/HEX1
add wave -noupdate /mips_tb/HEX2
add wave -noupdate /mips_tb/HEX3
add wave -noupdate /mips_tb/KEYS
add wave -noupdate /mips_tb/mw_U_2pulse
add wave -noupdate -divider CPU2
add wave -noupdate /mips_tb/write_data_out
add wave -noupdate -radix hexadecimal /mips_tb/ALU_result_out
add wave -noupdate /mips_tb/Branch_out
add wave -noupdate -radix hexadecimal /mips_tb/Instruction_out
add wave -noupdate /mips_tb/Regwrite_out
add wave -noupdate -radix hexadecimal /mips_tb/read_data_1_out
add wave -noupdate /mips_tb/Zero_out
add wave -noupdate -radix hexadecimal /mips_tb/read_data_2_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {650000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
configure wave -valuecolwidth 40
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
configure wave -timelineunits ps
update
WaveRestoreZoom {3731331 ps} {7743939 ps}
