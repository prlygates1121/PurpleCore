main:
    li a0, 0

    li s0, 1
    li s1, 2
    li s2, 3
    li s3, 4
    li s4, 5
    li s5, 6
    li s6, 7
    li s7, 8
    
    # multiply without dependency
    mul t0, s0, s1
    mul t1, s2, s3
    mul t2, s4, s5
    mul t3, s6, s7
    mul t4, s0, s1
    mul t5, s2, s3

    li a1, 2
    bne t0, a1, fail
    li a1, 12
    bne t1, a1, fail
    li a1, 30
    bne t2, a1, fail
    li a1, 56
    bne t3, a1, fail
    li a1, 2
    bne t4, a1, fail
    li a1, 12
    bne t5, a1, fail
    
    nop
    nop
    nop
    nop
    nop
    nop
    
    # multiply with dependency
    mul t0, s0, s1
    mul t1, t0, t0
    mul t2, t1, t1
    mul t3, t2, t2
    mul t4, t3, t3
    mul t5, t4, t3

    li a1, 2
    bne t0, a1, fail
    li a1, 4
    bne t1, a1, fail
    li a1, 16
    bne t2, a1, fail
    li a1, 256
    bne t3, a1, fail
    li a1, 65536
    bne t4, a1, fail
    li a1, 16777216
    bne t5, a1, fail
    
    nop
    nop
    nop
    nop
    nop
    nop
    
    # multiply / add without dependency
    mul t0, s1, s2
    add t1, s0, s1
    add t2, s1, s2
    add t3, s2, s3
    mul t4, s3, s4
    add t5, s4, s5

    li a1, 6
    bne t0, a1, fail
    li a1, 3
    bne t1, a1, fail
    li a1, 5
    bne t2, a1, fail
    li a1, 7
    bne t3, a1, fail
    li a1, 20
    bne t4, a1, fail
    li a1, 11
    bne t5, a1, fail
    
    nop
    nop
    nop
    nop
    nop
    nop
    
    # mixed
    mul t0, s0, s1
    add t1, s0, s1
    mul t2, s0, s1
    mul t3, s1, s2
    add t4, t2, t2
    add t5, t3, t3

    li a1, 2
    bne t0, a1, fail
    li a1, 3
    bne t1, a1, fail
    li a1, 2
    bne t2, a1, fail
    li a1, 6
    bne t3, a1, fail
    li a1, 4
    bne t4, a1, fail
    li a1, 12
    bne t5, a1, fail

    nop
    nop
    nop
    nop
    nop
    nop
    
    # mixed with write collision
    mul t0, s0, s1
    add t0, s0, s1
    add t0, s1, s2
    mul t0, s2, s3
    add t0, s3, s4
    add t1, t0, t0
    mul t2, s4, s5
    nop
    add t2, s0, s0
    add t3, t2, t2

    li a1, 9
    bne t0, a1, fail
    li a1, 18
    bne t1, a1, fail
    li a1, 2
    bne t2, a1, fail
    li a1, 4
    bne t3, a1, fail
    
    nop
    nop
    nop
    nop
    nop

end:
    j end

fail:
    li a0, 1
    j fail
    