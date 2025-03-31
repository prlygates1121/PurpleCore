.text

main:
    li a0, 1
    li a1, 2
    jal add_num
    addi t0, x0, 1
    addi t1, x0, 1
    j exit
    
add_num:
    add a0, a0, a1
    ret

filling:

exit:
    
    