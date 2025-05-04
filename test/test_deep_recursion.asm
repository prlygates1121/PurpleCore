.text

main:
    li a0, 255
    call fn1
    j exit
    
fn1:
    li t0, 1
    beq a0, t0, is1
    addi t0, t0, 1
    beq a0, t0, is2
    
    addi sp, sp, -4
    sw ra, 0(sp)
    addi a0, a0, -1
    call fn1
    addi a0, a0, 1
    
    lw ra, 0(sp)
    addi sp, sp, 4
    
    ret
is1:
    li a0, 1
    ret
is2:
    li a0, 2
    ret
    
exit: