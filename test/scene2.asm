.globl  main
.text
main:
        li      s6, 0
        li      t6, 0               # Determine the current floating-point number that needs to be stored
        li      a7, 0
loop:
        mv      a7,a1
        li      a0, 0x80600000      # check center button
        lbu      a1, 0(a0)
        srli     a1,a1,4
        beqz    a1, loop
        bnez    a7, loop
       
        li      a0, 0x80300000      # load test code
        lbu      a2, 0(a0)    
        
        li      a0,0               # check test code
        beq     a0,a2,sample0
        li      a0,1      
        beq     a0,a2,sample1
        li      a0,2      
        beq     a0,a2,sample2
        li      a0,3      
        beq     a0,a2,sample3
        li      a0,4      
        beq     a0,a2,sample4
        li      a0,5     
        beq     a0,a2,sample5
        li      a0,6      
        beq     a0,a2,sample6
        li      a0,7      
        beq     a0,a2,sample7
        
        j loop
sample0:          
        li      t0, 0x80300001      # load input_addr
        lbu      t1, 0(t0)           
        
        li      t0,0
        li      t4,8
        li   	t3,0
        smallloop0:
        andi   t2,t1,1
        srli t1,t1,1
        slli t3,t3,1
        add t3,t3,t2
        addi t0,t0,1
        blt    t0,t4,smallloop0
          
        mv   	 t1,t3
        li      t0, 0x80200001      # load output_addr
        sb      t1, 0(t0)            

        j       loop

sample1:
        li      t0, 0x80300001      # load input_addr
        lbu      t1, 0(t0)           

        li      t0, 0x80700000      # show on 7SEG
        sb      t1, 0(t0)
	
	 mv      t5,t1               
        li      t0,0
        li      t4,8
        li      t3,0
smallloop1:
        andi   t2,t1,1
        srli t1,t1,1
        slli t3,t3,1
        add t3,t3,t2
        addi t0,t0,1
        blt    t0,t4,smallloop1
        
        beq    t5,t3,ispal     # it is a palindrome
        
        li      t1,0x00000000
        li      t0, 0x80200001      # load output_addr
        sb      t1,0(t0)     
        j 	 loop
        ispal:
        li      t1,0x00000001         # Turn on a light
        li      t0, 0x80200001      # load output_addr
        sb      t1,0(t0)     
        j       loop

sample2:
        
        li      t0, 0x80300001      # load input_addr
        lbu      t1, 0(t0)           

        li      t2, 4
        srl     t4, t1, t2
        
        li      t2, 3
        srl     s11,t4,t2
        #todo:   show minus
        
        
        li      t3, 7
        and     t3, t3, t4           #exponent
        
        li      t4,15
        and     t4,t1,t4              
        
        slli     t4,t4,4
        
        li      t2, 3               #Bias value            
        sub     t3,t3,t2
        
        sll     t4,t4,t3
        
        mv      t5,t4
        li      t4,0
        li      a4,12
        li      a5,1
        li      s0,5
        li      s1,15
smallloop4:
	srl     a3,t5,a4
	and     a6,a5,a3
	sll     t4,t4,a5
	add     t4,t4,a6
first4:	
	and     s2,t4,s1	
	blt     s2,s0,second4
	add     t4,t4,t2
second4:
	srli     s3,t4,4
	and     s2,s3,s1	
	blt     s2,s0,third4
	slli     t2,t2,4
	add     t4,t4,t2
	srli     t2,t2,4
third4:
	srli     s3,s3,4
	and     s2,s3,s1	
	blt     s2,s0,checkloop
	slli     t2,t2,8
	add     t4,t4,t2
	srli     t2,t2,8	
checkloop:
	sub     a4,a4,a5
	bnez    a4,smallloop4	       	                      	                      
        
        slli    t4,t4,1
        li      t0, 0x80700000      # show on 7SEG
        sw      t4, 0(t0)


        li      t0, 0x80700007      
        sb      s11,0(t0)
        
        beqz   t6,savef1
        sb      t1, -8(sp)    # Specify another storage location   
        not    t6,t6
        j       loop
savef1:        
        sb      t1, -4(sp)    # Specify another storage location   
        not    t6,t6
        j       loop

sample3:                                # get a
        lbu      t1, -4(sp) 

	li      t2, 4
        srl     t4, t1, t2
        
        li      t2, 3
        srl     s4,t4,t2
        #remember minus

        
        li      t3, 7
        and     t3, t3, t4           #exponent
        
        li      t4,15
        and     t4,t1,t4              
        
        slli     t4,t4,4
        
        li      t2, 3               #Bias value            
        sub     t3,t3,t2
        
        sll     t4,t4,t3
                           # get b
        lbu      t1, -8(sp)

 	li      t2, 4
        srl     t5, t1, t2
        
        li      t2, 3
        srl     s5,t5,t2
        #remember minus
        
        li      t3, 7
        and     t3, t3, t5           #exponent
        
        li      t5,15
        and     t5,t1,t5              
        
        slli     t5,t5,4
        
        li      t2, 3               #Bias value            
        sub     t3,t3,t2
        
        sll     t5,t5,t3
        
        beqz    s4,notminust4
        neg     t4,t4
notminust4:        
        beqz    s5,notminust5
        neg     t5,t5
notminust5:        
        
        add     t5,t5,t4
        
        srli    s11,t5,31
        beqz    s11,notminustsum
	    neg     t5,t5
notminustsum: 
	#todo:show minus	       
        
        li      t4,0
        li      a4,12
        li      a5,1
        li      s0,5
        li      s1,15
smallloop5:
	srl     a3,t5,a4
	and     a6,a5,a3
	sll     t4,t4,a5
	add     t4,t4,a6
first41:	
	and     s2,t4,s1	
	blt     s2,s0,second41
	add     t4,t4,t2
second41:
	srli     s3,t4,4
	and     s2,s3,s1	
	blt     s2,s0,third41
	slli     t2,t2,4
	add     t4,t4,t2
	srli     t2,t2,4
third41:
	srli     s3,s3,4
	and     s2,s3,s1	
	blt     s2,s0,forth41
	slli     t2,t2,8
	add     t4,t4,t2
	srli     t2,t2,8	
forth41:
	srli     s3,s3,4
	and     s2,s3,s1	
	blt     s2,s0,checkloop1
	slli     t2,t2,8
	add     t4,t4,t2
	srli     t2,t2,8		
checkloop1:
	sub     a4,a4,a5
	bnez    a4,smallloop5	       	                      	                      
        
        slli    t4,t4,1
        li      t0, 0x80700000      # show on 7SEG
        sw      t4, 0(t0)

        li      t0, 0x80700007      
        sb      s11,0(t0)
        
	j       loop
sample4:
        li      t0, 0x80300001      # load input_addr
        lbu      t1, 0(t0)
        li      t3,1
        li      t5,19
        li      t4,16
        li      t2,4      
smallloop2:       
        sub     t2,t2,t3
        sll     t1, t1,t3
        beqz    t2,break2
        blt     t1,t4,smallloop2
break2:           
        xor     t1, t1,t5
        bnez    t2,smallloop2   
        
        mv      t3,t1
        lbu      t1, 0(t0)
        li      t2,4
        sll     t1,t1,t2
        add     t1,t1,t3
        
        li      t0, 0x80200001      # load output_addr
        sb      t1, 0(t0)       
        
        j       loop
        

sample5:
	 li      t0, 0x80300001      # load input_addr
        lbu      t1, 0(t0)
        li      t4,16
        li      t2,4
        mv      s1,t1
        li      s2,1
        srl     t1,t1,t2 
        li      s3,0
smallloop3:       
        addi     t2,t2,-1
        slli     t1, t1,1
        srl     s0,s1,t2
        and     s3,s2,s0
        add     t1,t1,s3
        beqz    t2,break3
        blt     t1,t4,smallloop3     
break3:         
        xori     t1, t1,19
        bnez    t2,smallloop3
        beqz   t1,iszero
	 li     t1,0x00000000         
        li      t0,0x80200001      # load output_addr
        sb      t1,0(t0)     
	j       loop
iszero:        
        li      t1,0x00000001         #turn on
        li      t0,0x80200001      # load output_addr
        sb      t1,0(t0)     
	j       loop
	
sample6:
        lui     t1, 0xFFFFF
        
        li      t0, 0x80700000      # show on 7SEG
        sw      t1, 0(t0)
        j       loop
        
	
sample7:
	beqz   s6,case2
case1:
	not    s6,s6 
	li t1,0x000000F0
	la  t2,Testjalr_success               
    	jalr  t3,t2,0 
    	 li t1,0x00000000                    

Testjalr_success:			# if it success
                           
        li      t0,0x80200001      # load output_addr
        sb      t1,0(t0)              
        
	j       loop
        
case2:           
        not    s6,s6 
        li t1,0x0000000F                   
    	jal Testjal_success       
    	 li t1,0x00000000                    

Testjal_success:			# if it success
                           
        li      t0,0x80200001      # load output_addr
        sb      t1,0(t0)    
         j       loop       
