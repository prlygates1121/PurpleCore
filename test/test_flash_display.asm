.text

main:
    li s0, 0xA0000000
    li s1, 0xA0028400
    mv t0, s0           # t0: write addr
    li t1, 1            # t1: color code
    li t2, 0x11111111   # t2: all the 8 color codes in a word
    li t4, 0
    li s2, 0x10
    li s3, 0x10
    
loop:
    sw t2, 0(t0)        # write 8 color codes
    addi t0, t0, 4      # update write addr
    
    beq t0, s1, reset_addr
    j loop
    
reset_addr:
    mv t0, s0
    addi t4, t4, 1
    beq t4, s3, update_color
    j fill_word
    
update_color:
    li t4, 0
    addi t1, t1, 1
    beq t1, s2, reset_color
    j fill_word

reset_color:
    li t1, 0
    li t2, 0
    j fill_word
    
fill_word:
    mv t2, t1
    slli t3, t2, 4
    or t2, t2, t3
    slli t3, t2, 8
    or t2, t2, t3
    slli t3, t2, 16
    or t2, t2, t3
    
    j loop
    