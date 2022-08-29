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
#----------------------- Registers  ---------------------------
# s0 - RXBUF
# s1 - Counter option 1
# s2 - Counter option 2
# s3 - Address next char to send
# s4 - How many char sent
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

	N:	.word 0x071B00
	Func3_Text:
		.word 'I',' ',' ',' ','l',' ','o',' ','v',' ','e',' ',' ',' ','m',' ','y',' ',' ',' ','N',' ','e',' ','g',' ','e',' ','v',' '
	#I love my Negev
	#
	#___o_e_m_ _e_
#---------------------- Code Segment --------------------------	
.text
main:	addi $sp,$zero,0x800 # $sp=0x800
	addi $t1,$zero,0x20  
	sw   $t1,0x824       # BTHOLD (disable BT)
	sw   $zero,0x828        # BTCNT=0
	sw   $zero,0x82C        # IE=0
	sw   $zero,0x82D        # IFG=0
	addi $t1,$zero,0x09
	sw   $t1,0x820       # UTCL=0x09 (SWRST=1, 115200 BR)
	addi $t1,$zero,0x01     # RXIE
	sw   $t1,0x82C       # IE=0x01

	# reset reg values
	addi  $s0,$zero,0	
	addi  $s1,$zero,0
	addi  $s2,$zero,0
	addi  $s3,$zero,0
	addi  $s4,$zero,0

	ori  $k0,$k0,0x01    # EINT, $k0[0]=1 uses as GIE
	
L:	j    L		    # infUart_Strte loop
	
KEY1_ISR:
	la   $s3,Func3_Text
	lw   $t1,0($s3)	
	addi $t6,$zero,7
	sw   $t6, 0x800
	sw   $t1,0x822
	lw   $t0,0x82D
	andi $t0,$t0,0xFFF7 
	add  $s4,$zero,$zero
	sw   $t0,0x82D
	lw    $t3,0x82C
	ori  $t3,$t3,0x02
	sw    $t3,0x82C
	jr   $k1
	
KEY2_ISR:
	jr   $k1

KEY3_ISR:
	jr   $k1
		
BT_ISR:	addi $t1,$zero,'1'		
	beq  $s0,$t1,Func1_BT
	addi $t1,$zero,'2'	
	beq  $s0,$t1,Func2_BT
RETI: jr   $k1
        
UartRX_ISR:
	addi $t1,$zero,0x20
	sw   $t1,0x824
	lw   $s0,0x821
	sw   $zero,0x828
	sw   $zero,0x82C
	sw   $zero,0x82D
	addi $t0,$zero,'4'		
	beq  $s0,$t0,Func4
	addi $t0,$zero,'3'		
	beq  $s0,$t0,Func3
	addi $t0,$zero,'2'
	beq  $s0,$t0,Func2			
	addi $t0,$zero,'1'		
	beq  $s0,$t0,Func1
	
        jr   $k1

UartTX_ISR:
	addi	$s4, $s4, 1
	addi	$t1,$zero,30	
	beq	$s4,$t1,End_TX
	addi    $t1,$zero,0
	lw   	$t1,0($s3)
	addi	$s3, $s3, 4
	sw   	$t1,0x822
	jr   	$k1
End_TX:
	la    $s3,Func3_Text
	lw    $t3,0x82C
	andi  $t3,$t3,0x3D
	sw    $t3,0x82C
	addi  $s4, $zero, 0
	jr    $k1
	
Func1:
	
	sw   $s1,0x800 
	addi $t1,$zero,0x26  
	sw   $t1,0x824  
	addi $t1,$zero,0x1460
	lui  $t1, 0x0024
	sw   $t1,0x828    
	addi $t1,$zero,0x06  
	sw   $t1,0x824   
	addi $t1,$zero,0x05 
	sw   $t1,0x82C  
	j    RETI
	
Func1_BT:
	addi $s1,$s1,1
	sw   $s1,0x800
	j    RETI
	
Func2:
	sw   $s2,0x804
	addi $t1,$zero,0x26  
	sw   $t1,0x824     # Hold=1
	addi $t1,$zero,0x1460
	lui  $t1, 0x0024
	sw   $t1,0x828
	addi $t1,$zero,0x06  
	sw   $t1,0x824     # Hold=0   
	addi $t1,$zero,0x05 
	sw   $t1,0x82C        
	j    RETI
	
Func2_BT:
	addi $s2,$s2,-1
	sw   $s2,0x804  
	j    RETI
	
Func3:
	addi $t1,$zero,0x0B
	la   $s3,Func3_Text
	sw   $t1,0x82C
	j    RETI

Func4:
	addi $t1,$zero,0x01
	sw   $t1,0x82C
	add  $s1,$zero,$zero
	add  $s2,$zero,$zero
	sw   $zero,0x804
	sw   $zero,0x800
	j    RETI