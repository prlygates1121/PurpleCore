.text

main:
    li x1, 0xDEADBEEF
#     add x3, x1, x0
#     add x4, x0, x1
#     add x3, x1, x1
    
    addi sp, sp, -16
    sw x1, 0(sp)
    addi x0, x0, 0
    lw x5, 0(sp)
    mv x6, x5
    mv x7, x6
    addi sp, sp, 16
    addi sp, sp, -16
    lw x8, 0(sp)
    lw x9, 0(sp)
    li x10, 0xFFFF
    addi sp, sp, 4
    sw x10, 0(sp)
    lw x11, 0(sp)
    mv x12, x11
    li x13, 0xEEEE
    sw x13, 4(sp)
    lw x14, 4(sp)
    
    
