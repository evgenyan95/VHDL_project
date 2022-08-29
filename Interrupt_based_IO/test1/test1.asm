#-------------------- MEMORY Mapped I/O -----------------------
#define PORT_LEDG[7-0] 0x800 - LSB byte (Output Mode)
#define PORT_LEDR[7-0] 0x804 - LSB byte (Output Mode)
#define PORT_HEX0[7-0] 0x808 - LSB byte (Output Mode)
#define PORT_HEX1[7-0] 0x80C - LSB byte (Output Mode)
#define PORT_HEX2[7-0] 0x810 - LSB byte (Output Mode)
#define PORT_HEX3[7-0] 0x814 - LSB byte (Output Mode)
#define PORT_SW[7-0]   0x818 - LSB byte (Input Mode)
#define PORT_KEY[3-1]  0x81C - LSB nibble (3 push-buttons - Input Mode)
#--------------------------------------------------------------
#define UCTL           0x820 - Byte 
#define RXBF           0x821 - Byte 
#define TXBF           0x822 - Byte 
#--------------------------------------------------------------
#define BTCTL          0x824 - LSB byte 
#define BTCNT          0x828 - Word 
#--------------------------------------------------------------
#define IE             0x82C - LSB byte 
#define IFG            0x82D - LSB byte
#define TYPE           0x82E - LSB byte
#---------------------- Data Segment --------------------------
.data 
	IV: 	.word main            # Start of Interrupt Vector Table
		.word UartRX_ISR
		.word UartTX_ISR
	        .word BT_ISR
		.word KEY1_ISR
		.word KEY2_ISR
		.word KEY3_ISR

	x: 	.word 0x09
	y: 	.word 0x10
	N: 	.word 0xFFFF
.text
main:	addi $sp,$zero,0x800  # $sp=0x800
	lw   $t1,N
	lw   $a0,x
	lw   $a1,y
	jal  func
	sw   $v0,0x800 # write to PORT_LEDG[7-0]
L:	j L            # infinite loop
	
func:	addi $sp,$sp,-8
	sw   $ra,0($sp) 	
	add  $t0,$a0,$a1
	sw   $t0,4($sp)
	jal  calc 
	slt  $t0,$0,$v0 
	bne  $t0,$0,exit
	lw   $v0,4($sp)
exit:	lw   $ra,0($sp) 
	addi $sp,$sp,8	 
	jr   $ra        # ret
	
calc:	addi $v0,$t0,-4	
	jr   $ra	       # ret	
	
	
UartRX_ISR: nop
UartTX_ISR: nop
       
         
