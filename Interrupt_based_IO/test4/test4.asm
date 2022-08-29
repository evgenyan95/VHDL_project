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
		.word UartRX_ISR
		.word UartTX_ISR
	        .word BT_ISR
		.word KEY1_ISR
		.word KEY2_ISR
		.word KEY3_ISR

	N:	.word 0xB71B00
	
#---------------------- Code Segment --------------------------	
.text
main:	addi $sp,$zero,0x800 # $sp=0x800
	addi $t0,$zero,0x3F  
	sw   $t0,0x824       # BTIP=7, BTSSEL=3, BTHOLD=1
	sw   $0,0x828        # BTCNT=0
	sw   $0,0x82C        # IE=0
	sw   $0,0x82D        # IFG=0
	addi $t0,$zero,0x1F  
	sw   $t0,0x824       # BTIP=7, BTSSEL=3, BTHOLD=0
	addi $t0,$zero,0x09
	sw   $t0,0x820       # UTCL=0x09 (SWRST=1,115200 BR)
	lw   $t0,0x818       # read the state of PORT_SW[7-0]
	
	addi $t0,$zero,0x39  # BTIE,TXIE are disabled
	sw   $t0,0x82C       # IE=0x39
	ori  $k0,$k0,0x01    # EINT, $k0[0]=1 uses as GIE
	
L:	j    L		    # infinite loop
	
KEY1_ISR:
	sw   $t0,0x800 # write to PORT_LEDG[7-0]
	sw   $t0,0x804 # write to PORT_LEDR[7-0]
	
	lw   $t1,0x82D # read IFG
	andi $t1,$t1,0xFFF7 
	sw   $t1,0x82D # clr KEY1IFG
	jr   $k1       # reti
	
KEY2_ISR:
	sw   $t0,0x808  # write to PORT_HEX0[7-0]
	sw   $t0,0x80C  # write to PORT_HEX1[7-0]
	
	lw   $t1,0x82D  # read IFG
	andi $t1,$t1,0xFFEF 
	sw   $t1,0x82D  # clr KEY2IFG
	jr   $k1        # reti

KEY3_ISR:
	sw   $t0,0x810  # write to PORT_HEX2[7-0]
	sw   $t0,0x814  # write to PORT_HEX3[7-0]
	
	lw   $t1,0x82D  # read IFG
	andi $t1,$t1,0xFFDF 
	sw   $t1,0x82D  # clr KEY3IFG
	jr   $k1        # reti
		
BT_ISR:	addi $t0,$t0,1  # $t1=$t1+1
	sw   $t0,0x800  # write to PORT_LEDG[7-0]
        jr   $k1        # reti
        
UartRX_ISR:	
	lw   $t1,0x821  # read RXBUF
	sw   $t1,0x800  # write to PORT_LEDG[7-0]
	sw   $t1,0x822  # write to TXBUF - Echo operation
        jr   $k1        # reti        
         
