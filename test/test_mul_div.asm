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
    li s8, 9
    li s9, 10
    li s10, 11
    li s11, 12
    
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
    
    ##########################################################
    ####               Here comes division                ####
    ##########################################################
    
    # divide without dependency
    div t0, s3, s0
    div t1, s3, s1
    div t2, s3, s3
    div t3, s7, s2
    div t4, s7, s3
    div t5, s7, s0
    
    li a1, 4
    bne t0, a1, fail
    li a1, 2
    bne t1, a1, fail
    li a1, 1
    bne t2, a1, fail
    li a1, 2
    bne t3, a1, fail
    li a1, 2
    bne t4, a1, fail
    li a1, 8
    bne t5, a1, fail
    
    # division with dependency
    li t0, 1024
    div t1, t0, s1
    div t2, t1, s1
    div t3, t2, s1
    div t4, t3, s1
    div t5, t4, s1
    div t6, t5, s1
    
    li a1, 512
    bne t1, a1, fail
    li a1, 256
    bne t2, a1, fail
    li a1, 128
    bne t3, a1, fail
    li a1, 64
    bne t4, a1, fail
    li a1, 32
    bne t5, a1, fail
    li a1, 16
    bne t6, a1, fail
    
    # division and others
    li t0, 3333
    div t1, t0, s1
    mul t2, s3, s8
    add t3, s0, s0
    add t2, s10, s0
    add t4, t2, t2
    add t1, t2, t3
    div t5, t1, s0
    mul t6, t1, t2
    
    li a1, 14
    bne t1, a1, fail
    li a1, 12
    bne t2, a1, fail
    li a1, 2
    bne t3, a1, fail
    li a1, 24
    bne t4, a1, fail
    li a1, 14
    bne t5, a1, fail
    li a1, 168
    bne t6, a1, fail
    
    mul t5, t1, t2
    div t3, t5, s2
    add t1, t5, t2
    add t2, t1, t5
    add t4, t1, t0
    mul t3, t1, t0
    mul t6, t0, t1
    add a2, t3, t3
    add a3, t0, t1
    mul a3, a3, s7
    div a4, a3, a2
    div a5, a4, a4
    add a6, t4, t2
    div a7, a4, a5
    
    li a1, 180
    bne t1, a1, fail
    li a1, 348
    bne t2, a1, fail
    li a1, 599940
    bne t3, a1, fail
    li a1, 3513
    bne t4, a1, fail
    li a1, 168
    bne t5, a1, fail
    li a1, 599940
    bne t6, a1, fail
    li a1, 1199880
    bne a2, a1, fail
    li a1, 28104
    bne a3, a1, fail
    li a1, 0
    bne a4, a1, fail
    li a1, -1
    bne a5, a1, fail
    li a1, 3861
    bne a6, a1, fail
    
# Group 1
    mul t1, s1, s2
    add t2, t1, s3
    div t3, t2, s4
    rem t4, t1, t3
    add t5, t0, t4
    mul t6, t5, s7
    div a2, t6, t2
    add a3, a2, t1
    mul a4, a3, t3
    rem a5, a4, s1
    div a6, a5, a2
    add a7, a6, t6
    
    li a1, 6
    bne t1, a1, fail
    li a1, 10
    bne t2, a1, fail
    li a1, 2
    bne t3, a1, fail
    li a1, 0
    bne t4, a1, fail
    li a1, 3333
    bne t5, a1, fail
    li a1, 26664
    bne t6, a1, fail
    li a1, 2666
    bne a2, a1, fail
    li a1, 2672
    bne a3, a1, fail
    li a1, 5344
    bne a4, a1, fail
    li a1, 0
    bne a5, a1, fail
    li a1, 0
    bne a6, a1, fail
    li a1, 26664
    bne a7, a1, fail

# Group 2
    add t1, s5, t1
    div t2, t1, s1
    rem t3, s3, t1
    mul t4, t2, t3
    add t5, a0, s6
    div t6, t5, t1
    rem a2, t6, s2
    mul a3, a2, t4
    add a4, a3, t5
    div a5, a7, a2
    mul a6, a5, t6
    add a7, a6, a3
    
    li a1, 12
    bne t1, a1, fail
    li a1, 6
    bne t2, a1, fail
    li a1, 4
    bne t3, a1, fail
    li a1, 24
    bne t4, a1, fail
    li a1, 7
    bne t5, a1, fail
    li a1, 0
    bne t6, a1, fail
    li a1, 0
    bne a2, a1, fail
    li a1, 0
    bne a3, a1, fail
    li a1, 7
    bne a4, a1, fail
    li a1, -1
    bne a5, a1, fail
    li a1, 0
    bne a6, a1, fail
    li a1, 0
    bne a7, a1, fail

# Group 3
    rem t1, t1, t4
    mul t2, t1, s0
    add t3, t2, t1
    div t4, t3, s4
    rem t5, t4, t1
    mul t6, s5, t5
    add a2, t6, t3
    div a3, a2, t4
    rem a4, a3, t1
    mul a5, a4, a2
    add a6, a5, t6
    div a7, a6, a3

    li a1, 12
    bne t1, a1, fail
    li a1, 12
    bne t2, a1, fail
    li a1, 24
    bne t3, a1, fail
    li a1, 4
    bne t4, a1, fail
    li a1, 4
    bne t5, a1, fail
    li a1, 24
    bne t6, a1, fail
    li a1, 48
    bne a2, a1, fail
    li a1, 12
    bne a3, a1, fail
    li a1, 0
    bne a4, a1, fail
    li a1, 0
    bne a5, a1, fail
    li a1, 24
    bne a6, a1, fail
    li a1, 2
    bne a7, a1, fail

# Group 4
    div t1, a3, a2
    add t2, t1, t0
    mul t3, t2, s1
    rem t4, t3, t1
    div t5, t4, s5
    add t6, t5, t2
    mul a2, t6, t3
    rem a3, a2, t4
    div a4, a3, t1
    add a5, a4, s7
    mul a6, a5, a2
    rem a7, a6, a3
    
    li a1, 0
    bne t1, a1, fail
    li a1, 3333
    bne t2, a1, fail
    li a1, 6666
    bne t3, a1, fail
    li a1, 6666
    bne t4, a1, fail
    li a1, 1111
    bne t5, a1, fail
    li a1, 4444
    bne t6, a1, fail
    li a1, 29623704
    bne a2, a1, fail
    li a1, 0
    bne a3, a1, fail
    li a1, -1
    bne a4, a1, fail
    li a1, 7
    bne a5, a1, fail
    li a1, 207365928
    bne a6, a1, fail
    li a1, 207365928
    bne a6, a1, fail
    
end:
    j end

fail:
    li a0, 1
    j fail
    