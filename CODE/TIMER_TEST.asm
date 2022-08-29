.data 
	N: .word 0xB71B00
	ID: .word 4,3,8,2,7,2,9,3
	IDsize: .word 8
.text

main:
	# BTCTL 
	# 1 = 00000001, BTIP = Q3 1000, BTSSEL = CLOCK, BTHOLD = 0 MEANS ENABLE COUNTER
	addi $a1,$zero,1
	sw  $a1,0x824
	
	addi $a2,$zero,16
	# BTCNT = 15.. 
	sw  $a2,0x828
