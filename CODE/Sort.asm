.data 
	N: .word 0xB71B00
	ID: .word 4,3,8,2,7,2,9,3
	IDsize: .word 8
.text

main:
	addi $a1,$zero,1
	sw  $a1,0x800
   	lw $t8,N
   	la $a0, ID
   	lw $t0, IDsize   
   	jal sort
   	ori $a1,$a1,2
   	sw $a1,0x800
    
Loop1:
	xori $a1,$a1,8
   	sw $a1,0x800
 	addi $t3, $0, 0 #i
 	la $a0, ID     
 Loop2:
	xori $a1,$a1,16
   	sw $a1,0x800
  	lw  $t7, 0($a0) 
  	sw  $t7, 0x808   
  	srl $t7,$t7,4    
  	sw  $t7, 0x80c   
  	srl $t7,$t7,4    
	sw  $t7,0x810    
	srl $t7,$t7,4    
	sw  $t7,0x814    
  	jal    delay     
        addi $a0, $a0, 4	
	addi $t3, $t3, 1  
	sub  $t6, $t0, $t3
	bne  $t6, $zero,  Loop2  
	j    Loop1
	
sort:	# bubble sort
	xori $a1,$a1,4
   	sw $a1,0x800
	move $t2, $0    
sort_Loop1:             
    	addi $t7, $0, 1
    	la $a0, ID
sort_Loop2:                  
    	lw  $t1, 0($a0) 
    	lw  $t3, 4($a0)
    	slt $t4, $t3, $t1       
    	bne $t4, $0, swap  
c:   	addi $a0, $a0, 4           
    	addi $t7, $t7, 1     
    	bne  $t7, $t0, sort_Loop2
    	addi $t2, $t2, 1
    	bne  $t2, $t0, sort_Loop1  
	jr $ra
	
swap:   sw  $t1, 4($a0)         
    	sw  $t3, 0($a0)
    	j   c
 	
delay:	move $t6,$zero
L:	addi $t6,$t6,1 
	slt  $t5,$t6,$t8      
	beq  $t5,$zero,back  
	j    L
back: jr $ra  
