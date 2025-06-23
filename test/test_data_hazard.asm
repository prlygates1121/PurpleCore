.text

main:
    li a0, 0
    li s1, 1
    li s2, 2
    li s3, 3
    li s4, 4

    # test forwarding
    add t0, s1, s2
    add t1, t0, t0
    add t2, t0, t0 
    add t3, t1, t2
    add t4, t1, t3
    add t5, t2, t4

    li a1, 3
    bne t0, a1, fail
    li a1, 6
    bne t1, a1, fail
    li a1, 6
    bne t2, a1, fail
    li a1, 12
    bne t3, a1, fail
    li a1, 18
    bne t4, a1, fail
    li a1, 24
    bne t5, a1, fail


    # test forwarding + stall
    addi t0, s1, 11
    sw t0, -4(sp)
    lw t1, -4(sp)
    add t2, t0, t1
    add t3, t2, t1
    sw t3, -8(sp)
    add t4, t3, t2
    lw t5, -8(sp)

    li a1, 12
    bne t0, a1, fail
    li a1, 12
    bne t1, a1, fail
    li a1, 24
    bne t2, a1, fail
    li a1, 36
    bne t3, a1, fail
    li a1, 60
    bne t4, a1, fail
    li a1, 36
    bne t5, a1, fail

    # many store & loads
    sw s1, -12(sp)
    sw s2, -16(sp)
    sw s3, -20(sp)
    sw s4, -24(sp)
    lw t4, -24(sp)
    lw t3, -20(sp)
    lw t2, -16(sp)
    lw t1, -12(sp)
    
    li a1, 1
    bne t1, a1, fail
    li a1, 2
    bne t2, a1, fail
    li a1, 3
    bne t3, a1, fail
    li a1, 4
    bne t4, a1, fail
   
end:
    j end

fail:
    li a0, 1
    j fail