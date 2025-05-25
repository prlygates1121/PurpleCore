.text

main:
    li s0, 0x80800000   # UART address
    li s1, 0x00000200   # start of the loaded program
    li s4, 0x400        # timeout value to indicate the end of reception
    li s5, 0            # timeout counter
    li s6, 0            # becomes 1 once the first byte is received
    li s7, 0x80200000   # LED address
    li s8, 0            # becomes 2 once the second byte is received
    li s9, 0x80700000   # segment display address
    li s10, 0           # total instructions received
    li t1, 0

    li t0, 1
    sh t0, 2(s9)

get_inst:
    li s2, 4
    li s3, 0
get_byte:
    slli t1, t1, 8
    
polling:
    beq s6, zero, wait      # do not update the timeout counter if the first byte is not received
    addi s5, s5, 1
wait:
    lw t0, 4(s0)
    andi t0, t0, 1
    beq s5, s4, start       # if timeout, stop receiving bytes and start the user program
    beq t0, zero, polling   # if nothing is received, keep polling
    
    # a byte has just been received

    beq s6, zero, skip_calibration
    # if the first byte is received:
    bne s8, zero, skip_calibration
    # if the second byte is not received:
    slli s4, s5, 2          # set timeout value to be 4 times the final counter value between the reception of the first and second byte

first_byte:
    li s8, 1                # indicate the second byte is received
skip_calibration:
    li s6, 1                # indicate the first byte is received
    li s5, 0                # reset the timeout counter
    
    lw t0, 0(s0)            # get a byte from the UART buffer
    add t1, t1, t0          # get_inst the byte to the correct location of the instruction in t1
    
    addi s3, s3, 1          # update byte counter for instructions
    bne s3, s2, get_byte    # if not all 4 bytes in an instruction are received, prepare for the remaining bytes
    
    sw t1, 0(s1)            # put the received instruction at the correct address in pointer s1
    addi s1, s1, 4          # update the pointer s1

    addi s10, s10, 1
    sh s10, 0(s9)
    
    j get_inst              # continue to receive instructions

start:
    li t0, 2
    sh t0, 2(s9)

    li t0, 0xFF
    sb t0, 0(s7)
    li s1, 0x200
    jalr x0, s1, 0
    