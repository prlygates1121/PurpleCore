.text

main:
    li t0, 0xFFF10000 # switches
    li t1, 0xFFF00000 # LEDs
loop:
    # read from switches
    lw t2, 0(t0)
    
    # write to LEDs
    add t3, t1, t2
    sw t2, 0(t3)
    j loop


