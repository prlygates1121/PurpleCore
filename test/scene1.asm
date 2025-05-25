.text
main:
        li      a7,0    
loop:
        
        mv    a7,a1
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
        
sample0:          
        li      t0, 0x80300001      # left switch
        lbu      t1, 0(t0)           

        li      t0, 0x80200001      # left led
        sb      t1, 0(t0)            

        j       loop

sample1:
        li      t0, 0x80300001      # left switch
        lb      t1, 0(t0)           

        li      t0, 0x80700000      # 7 segment
        sw      t1, 0(t0)
        
        sw      t1, -4(sp)

        j       loop

sample2:
        li      t0, 0x80300001      # left switch
        lbu      t1, 0(t0)           

        li      t0, 0x80700000      # 7 segment
        sw      t1, 0(t0)
        
        sw      t1, -8(sp)    # Specify another storage location   

        j       loop

sample3:                
                           # get a
        lw      t1, -4(sp)
                          # get b
        lw      t2, -8(sp)

        beq     t1,t2,beqsuc
        
        li      t1,0x00000000
        li      t0, 0x80200001      # load output_addr
        sb      t1, 0(t0)     
        
        j       loop
        
	beqsuc:
	
	li      t1,0x000000FF       #bright
	li      t0, 0x80200001      # load output_addr
	sb      t1, 0(t0)     
	j       loop
		        
sample4:                  # get a
        lw      t1, -4(sp)
                          # get b
        lw      t2, -8(sp)


        blt     t1,t2,bltsuc
        
        li      t1,0x00000000
        li      t0, 0x80200001      # load output_addr
        sb      t1, 0(t0)     
        
        j       loop
        
	bltsuc:
	
	li      t1,0x000000FF       #bright
	li      t0, 0x80200001      # load output_addr
	sb      t1, 0(t0)     
	j       loop

sample5:                    # get a
        lw      t1, -4(sp)
                          # get b
        lw      t2, -8(sp)


        bltu     t1,t2,bltusuc
        
        li      t1,0x00000000
        li      t0, 0x80200001      # load output_addr
        sb      t1, 0(t0)     
        
        j       loop
        
	bltusuc:
	
	li      t1,0x000000FF       #bright
	li      t0, 0x80200001      # load output_addr
	sb      t1, 0(t0)     
	j       loop
	
sample6:
                           # get a
        lw      t1, -4(sp)
                          # get b
        lw      t2, -8(sp)

        li      t3,0
        slt     t3,t1,t2
        beqz    t3,sltfail
        
        li      t1,0x00000001		#bright
        li      t0, 0x80200001      # load output_addr
        sb      t1, 0(t0)     
        
        j       loop
        
	sltfail:
	
	li      t1,0x00000000       
	li      t0, 0x80200001      # load output_addr
	sb      t1, 0(t0)     
	j       loop
	
sample7:
                        # get a
        lw      t1, -4(sp)
                          # get b
        lw      t2, -8(sp)

        li      t3,0
        sltu     t3,t1,t2
        beqz     t3,sltufail
        
        li      t1,0x00000001		#bright
        li      t0, 0x80200001      # load output_addr
        sb      t1, 0(t0)     
        
        j       loop
        
	sltufail:
	
	li      t1,0x00000000       
	li      t0, 0x80200001      # load output_addr
	sb      t1, 0(t0)     
	j       loop

