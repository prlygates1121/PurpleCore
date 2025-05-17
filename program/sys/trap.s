.text

# ecall/interrupt/exception from user code traps here
# mscratch: trapframe address
.global m_trap
m_trap:
    # swap a0 and mscratch
    # a0 now holds trapframe address
    # mscratch now holds original a0
    csrrw a0, mscratch, a0

    # save user registers to trapframe
    sw ra,  12(a0)
    sw sp,  16(a0)
    sw gp,  20(a0)
    sw tp,  24(a0)
    sw t0,  28(a0)
    sw t1,  32(a0)
    sw t2,  36(a0)
    sw s0,  40(a0)
    sw s1,  44(a0)
    # skip a0
    sw a1,  52(a0)
    sw a2,  56(a0)
    sw a3,  60(a0)
    sw a4,  64(a0)
    sw a5,  68(a0)
    sw a6,  72(a0)
    sw a7,  76(a0)
    sw s2,  80(a0)
    sw s3,  84(a0)
    sw s4,  88(a0)
    sw s5,  92(a0)
    sw s6,  96(a0)
    sw s7,  100(a0)
    sw s8,  104(a0)
    sw s9,  108(a0)
    sw s10, 112(a0)
    sw s11, 116(a0)
    sw t3,  120(a0)
    sw t4,  124(a0)
    sw t5,  128(a0)
    sw t6,  132(a0)

    # save a0 to trapframe (with the help of t0)
    csrr t0, mscratch
    sw t0, 48(a0)

    # set up trap_sp
    lw sp, 0(a0)

    # jump to trap_handler
    lw t0, 4(a0)
    jalr zero, t0, 0

# traps return from handler to here
# a0: trapframe address
# mscratch: a0 from user code
.global m_ret
m_ret:
    # load original a0 to mscratch
    # (mscratch was loaded with user's original a0 in m_trap, yet there's
    #   no guarantee that it was not modified during trap handling)
    lw t0, 48(a0)
    csrw mscratch, t0

    # restore user registers from trapframe
    lw ra,  12(a0)
    lw sp,  16(a0)
    lw gp,  20(a0)
    lw tp,  24(a0)
    lw t0,  28(a0)
    lw t1,  32(a0)
    lw t2,  36(a0)
    lw s0,  40(a0)
    lw s1,  44(a0)
    # skip a0
    lw a1,  52(a0)
    lw a2,  56(a0)
    lw a3,  60(a0)
    lw a4,  64(a0)
    lw a5,  68(a0)
    lw a6,  72(a0)
    lw a7,  76(a0)
    lw s2,  80(a0)
    lw s3,  84(a0)
    lw s4,  88(a0)
    lw s5,  92(a0)
    lw s6,  96(a0)
    lw s7,  100(a0)
    lw s8,  104(a0)
    lw s9,  108(a0)
    lw s10, 112(a0)
    lw s11, 116(a0)
    lw t3,  120(a0)
    lw t4,  124(a0)
    lw t5,  128(a0)
    lw t6,  132(a0)

    # restore a0 from mscratch
    # a0 now holds original a0
    # mscratch now holds trapframe address
    csrrw a0, mscratch, a0

    mret


