.text

main:
    li s0, 0
    li s1, 0x80700000       # address for segment display
    li s7, 0x80600000       # address for buttons
    li s9, 5
    addi sp, sp, -24
    
display_seg:
    li s8, 0
    lw t0, 0(s7)            # retrieve all button states
bt_loop:
    # prepare the address of the record of each button
    slli t2, s8, 2
    add t3, sp, t2
    
    mv t1, t0
    srl t1, t1, s8          # shift right all button states to get this button's state
    andi t1, t1, 1
    bne t1, zero, down      # check if the button is now pressed
    
    # if not pressed, just register that the button is not pressed and end
    sw t1, 0(t3)
    j end
    
down:
    lw t4, 0(t3)            # check if the button has been pressed already
    sw t1, 0(t3)            # register that the button is now pressed
    beq t4, zero, first     # if it's the first time the button is pressed
    j end
    
first:
    li t5, 0x01000000
    add s0, s0, t5
    li t6, 3
    blt s8, t6, incr
    addi s0, s0, -1
    j end
incr:
    addi s0, s0, 1

end:
    addi s8, s8, 1
    bne s8, s9, bt_loop
    
    sw s0, 0(s1)
    j display_seg

