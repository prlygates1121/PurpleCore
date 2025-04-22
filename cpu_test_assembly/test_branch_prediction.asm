.text

main:
    li t0, 0
    li t1, 10
    
loop1:
    beq t0, t1, loop1_end
    addi t0, t0, 1
    j loop1
loop1_end:

end:

    