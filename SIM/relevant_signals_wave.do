onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_tb/clock
add wave -noupdate -divider CPU
add wave -noupdate -radix hexadecimal /mips_tb/PC
add wave -noupdate /mips_tb/Memwrite_out
add wave -noupdate /mips_tb/write_data_out
add wave -noupdate -radix hexadecimal /mips_tb/ALU_result_out
add wave -noupdate /mips_tb/Branch_out
add wave -noupdate -radix hexadecimal /mips_tb/Instruction_out
add wave -noupdate /mips_tb/Regwrite_out
add wave -noupdate -radix hexadecimal /mips_tb/read_data_1_out
add wave -noupdate /mips_tb/Zero_out
add wave -noupdate -radix hexadecimal /mips_tb/read_data_2_out
add wave -noupdate -radix hexadecimal /mips_tb/U_0/IO/CS
add wave -noupdate -divider all_relevant_sig
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/clock
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/reset
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/data
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/BTCTLbit
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/BTCNTbit
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/set_BTIFG
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/counter
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/BTHOLD
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/BTSSEL
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/BTIPX
add wave -noupdate -expand -group BT -radix hexadecimal /mips_tb/U_0/IO/BT/BTCTL
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/BTIFG
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/BTSSELout
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/MCLK2
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/MCLK4
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/MCLK8
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/BTIFG_REG
add wave -noupdate -expand -group BT /mips_tb/U_0/IO/BT/clkincreas
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/bus_width
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/datain
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/address
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/Swithes
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/KEYS
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/Global_IE_control
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/INTA
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/MemWrite
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/clk
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/MemRead
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/reset
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/type_io
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/INTR
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/HEX0
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/HEX1
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/HEX2
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/HEX3
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/LEDG
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/LEDR
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/dataout
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/out_IFG
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/keysout
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/SWout
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/LEDGout
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/LEDRout
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/hexout0
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/hexout1
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/hexout2
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/hexout3
add wave -noupdate -group IO_sig -radix hexadecimal /mips_tb/U_0/IO/CS
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/keyin
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/hexin0
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/hexin1
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/hexin2
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/hexin3
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/BTIFG
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/ifgWriteBit
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/ifgReadBit
add wave -noupdate -group IO_sig /mips_tb/U_0/IO/clkNot
add wave -noupdate -group control /mips_tb/U_0/CTL/reg_t
add wave -noupdate -group control /mips_tb/U_0/CTL/clock
add wave -noupdate -group control /mips_tb/U_0/CTL/reset
add wave -noupdate -group control /mips_tb/U_0/CTL/Opcode
add wave -noupdate -group control /mips_tb/U_0/CTL/INTR
add wave -noupdate -group control /mips_tb/U_0/CTL/Jr
add wave -noupdate -group control /mips_tb/U_0/CTL/K1_reg_in_use
add wave -noupdate -group control /mips_tb/U_0/CTL/RegWrite
add wave -noupdate -group control /mips_tb/U_0/CTL/BNE
add wave -noupdate -group control /mips_tb/U_0/CTL/ALUSrc
add wave -noupdate -group control /mips_tb/U_0/CTL/MemWrite
add wave -noupdate -group control /mips_tb/U_0/CTL/Branch
add wave -noupdate -group control /mips_tb/U_0/CTL/MemRead
add wave -noupdate -group control /mips_tb/U_0/CTL/INTA
add wave -noupdate -group control /mips_tb/U_0/CTL/Global_IE_control
add wave -noupdate -group control /mips_tb/U_0/CTL/Jump
add wave -noupdate -group control /mips_tb/U_0/CTL/MemtoReg
add wave -noupdate -group control /mips_tb/U_0/CTL/RegDst
add wave -noupdate -group control /mips_tb/U_0/CTL/ALUop
add wave -noupdate -group control /mips_tb/U_0/CTL/R_format
add wave -noupdate -group control /mips_tb/U_0/CTL/I_format
add wave -noupdate -group control /mips_tb/U_0/CTL/Lw
add wave -noupdate -group control /mips_tb/U_0/CTL/Jal
add wave -noupdate -group control /mips_tb/U_0/CTL/SW
add wave -noupdate -group control /mips_tb/U_0/CTL/Lui
add wave -noupdate -group control /mips_tb/U_0/CTL/Beq
add wave -noupdate -group control /mips_tb/U_0/CTL/Mul
add wave -noupdate -group control /mips_tb/U_0/CTL/INTAbit
add wave -noupdate -group control /mips_tb/U_0/CTL/REG_Writebit
add wave -noupdate -group control /mips_tb/U_0/CTL/reg_t
add wave -noupdate -group control /mips_tb/U_0/CTL/clock
add wave -noupdate -group control /mips_tb/U_0/CTL/reset
add wave -noupdate -group control /mips_tb/U_0/CTL/Opcode
add wave -noupdate -group control /mips_tb/U_0/CTL/INTR
add wave -noupdate -group control /mips_tb/U_0/CTL/Jr
add wave -noupdate -group control /mips_tb/U_0/CTL/K1_reg_in_use
add wave -noupdate -group control /mips_tb/U_0/CTL/RegWrite
add wave -noupdate -group control /mips_tb/U_0/CTL/BNE
add wave -noupdate -group control /mips_tb/U_0/CTL/ALUSrc
add wave -noupdate -group control /mips_tb/U_0/CTL/MemWrite
add wave -noupdate -group control /mips_tb/U_0/CTL/Branch
add wave -noupdate -group control /mips_tb/U_0/CTL/MemRead
add wave -noupdate -group control /mips_tb/U_0/CTL/INTA
add wave -noupdate -group control /mips_tb/U_0/CTL/Global_IE_control
add wave -noupdate -group control /mips_tb/U_0/CTL/Jump
add wave -noupdate -group control /mips_tb/U_0/CTL/MemtoReg
add wave -noupdate -group control /mips_tb/U_0/CTL/RegDst
add wave -noupdate -group control /mips_tb/U_0/CTL/ALUop
add wave -noupdate -group control /mips_tb/U_0/CTL/R_format
add wave -noupdate -group control /mips_tb/U_0/CTL/I_format
add wave -noupdate -group control /mips_tb/U_0/CTL/Lw
add wave -noupdate -group control /mips_tb/U_0/CTL/Jal
add wave -noupdate -group control /mips_tb/U_0/CTL/SW
add wave -noupdate -group control /mips_tb/U_0/CTL/Lui
add wave -noupdate -group control /mips_tb/U_0/CTL/Beq
add wave -noupdate -group control /mips_tb/U_0/CTL/Mul
add wave -noupdate -group control /mips_tb/U_0/CTL/INTAbit
add wave -noupdate -group control /mips_tb/U_0/CTL/REG_Writebit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {593552 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 240
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
WaveRestoreZoom {0 ps} {3752622 ps}
