.equ VGA_BASE,              0x80300000
.equ DISPLAY_WIDTH,         640
.equ DISPLAY_HEIGHT,        480
.equ bits_4,                0b11110000

.equ ASCII_BASE,            0x80400000
.equ SPACE    , 0 
.equ EX_MARK  , 1 
#   .equ "              , 2 
#   .equ #              , 3 
#   .equ $              , 4 
#   .equ %              , 5 
#   .equ &              , 6 
#   .equ '              , 7 
#   .equ (              , 8 
#   .equ )              , 9 
#   .equ *              , 10
#   .equ +              , 11
.equ COMMA              , 12
#   .equ -              , 13
.equ PERIOD              , 14
#   .equ /              , 15
.equ ZERO           , 16
.equ ONE              , 17
.equ TWO              , 18
.equ THREE              , 19
.equ FOUR              , 20
.equ FIVE              , 21
.equ SIX              , 22
.equ SEVEN              , 23
.equ EIGHT              , 24
.equ NINE              , 25
#   .equ :              , 26
#   .equ ;              , 27
#   .equ <              , 28
#   .equ =              , 29
#   .equ >              , 30
.equ QUES_MARK              , 31
#   .equ @              , 32
.equ A              , 33
.equ B              , 34
.equ C              , 35
.equ D              , 36
.equ E              , 37
.equ F              , 38
.equ G              , 39
.equ H              , 40
.equ I              , 41
.equ J              , 42
.equ K              , 43
.equ L              , 44
.equ M              , 45
.equ N              , 46
.equ O              , 47
.equ P              , 48
.equ Q              , 49
.equ R              , 50
.equ S              , 51
.equ T              , 52
.equ U              , 53
.equ V              , 54
.equ W              , 55
.equ X              , 56
.equ Y              , 57
.equ Z              , 58
#    .equ [              , 59
#    .equ \              , 60
#    .equ ]              , 61
#    .equ ^              , 62
.equ _              , 63
#    .equ `              , 64
.equ a              , 65
.equ b              , 66
.equ c              , 67
.equ d              , 68
.equ e              , 69
.equ f              , 70
.equ g              , 71
.equ h              , 72
.equ i              , 73
.equ j              , 74
.equ k              , 75
.equ l              , 76
.equ m              , 77
.equ n              , 78
.equ o              , 79
.equ p              , 80
.equ q              , 81
.equ r              , 82
.equ s              , 83
.equ t              , 84
.equ u              , 85
.equ v              , 86
.equ w              , 87
.equ x              , 88
.equ y              , 89
.equ z              , 90
#.equ {              , 91
#.equ |              , 92
#.equ }              , 93
#.equ ~              , 94
.equ bksp           , 97

.equ BLACK              , 0b0000
.equ WHITE              , 0b0001
.equ RED                , 0b0010
.equ ORANGE             , 0b0011
.equ YELLOW             , 0b0100
.equ LIGHT_GREEN        , 0b0101
.equ GREEN              , 0b0110
.equ SPRING_GREEN       , 0b0111
.equ CYAN               , 0b1000
.equ SKY_BLUE           , 0b1001
.equ BLUE               , 0b1010
.equ PURPLE             , 0b1011
.equ PINK               , 0b1100
.equ ROSE               , 0b1101
.equ SUPERNOVA          , 0b1110
.equ GRAY               , 0b1111

.equ KEYBOARD_BASE      , 0x80500000
.equ KEYBOARD_TIMEOUT   , 1000000
.equ KEYBOARD_CONSECUTIVE_DELAY, 100000

.equ LED_BASE           , 0x80100000

####################################################################################################################################################
####                                                                    macros                                                                  ####
####################################################################################################################################################

# brief: draw a pixel on the VGA memory buffer
# x: x coordinate
# y: y coordinate
# color: color value (only lower 4 bits are used)
.macro draw_pixel x y color
    li t0, DISPLAY_WIDTH
    li t1, VGA_BASE
    li t6, bits_4
    mul t2, \y, t0  # pixel index (row)
    add t2, t2, \x              # pixel index (row + col)
    andi t3, t2, 1              # t3: select which pixel inside byte (0: first pixel, 1: second pixel)
    slli t3, t3, 2              # (0: first pixel, 4: second pixel)
    andi t4, \color, 0b1111     # get the least significant 4 bits of the color
    sll t4, t4, t3              # shift color left by 4 bits if we want the second pixel
    srl t6, t6, t3              # shift bits_4 right by 4 bits if we want the second pixel
    srli t2, t2, 1              # byte index (1/2 byte per pixel)
    add t2, t2, t1       # vga write address
    lbu t5, 0(t2)               # read original byte from memory
    and t5, t5, t6              # and the byte with bits_4
    or t5, t5, t4               # or the byte with color
    sb t5, 0(t2)                # store the byte back to memory
.endm

# brief: draw 8 consecutive pixels (32-bit word) on the VGA memory buffer
# x: x coordinate
# y: y coordinate
# colors: color value (all 32 bits are used to paint 8 pixels)
# note: make sure the pixel position align with the word boundary (pixel index divisible by 8)
.macro draw_pixel_8 diplay_width vga_base x y colors
    mul t2, \y, \display_width
    add t2, t2, \x              # pixel index
    srli t2, t2, 1              # byte index
    add t2, t2, \vga_base       # vga write address
    sw \colors, 0(t2)
.endm

# res = 1 if printable, 0 otherwise
.macro is_printable char_name res
    sltiu \res, \char_name, 95
.endm

# res = 0 if no character, non-zero otherwise
.macro has_char char_name res
    addi \res, \char_name, -0xFF
.endm

.macro get_key keyboard_base key
    lw \key, 0(\keyboard_base)
.endm

####################################################################################################################################################
####                                                                    main()                                                                  ####
####################################################################################################################################################

.section .text
.global _start

_start:
    li s1, KEYBOARD_BASE
    li s2, 10               # s2: x
    li s3, 10               # s3: y
    li s6, 620              # s6: threshold of new line
    li s0, 0                # s0: has_char
    li s4, KEYBOARD_TIMEOUT
    #li s7, 0                # s7: state
                            # 0:    IDLE
                            # 1:    FIRST
                            # 2:    

loop:
    addi s4, s4, -1
    get_key s1, s5
    has_char s5, t0
    beq t0, zero, get_no_char

    # if a char is received
    mv t0, s0
    li s0, 1                # set has_char = 1
    beq t0, zero, ice_breaker

    # if has_char already
    blt s4, zero, timeout

    # if no timeout yet, continue
    j loop

    # if timeout, reset timer, consider key as new input
timeout:
    li s4, KEYBOARD_CONSECUTIVE_DELAY
    j check_printability

ice_breaker:
#    li s7, 1
    li s4, KEYBOARD_TIMEOUT
    
check_printability:
    is_printable s5, t0
    bne t0, zero, print

    # if not printable, check special command (e.g., bksp)
    li t0, bksp
    beq s5, t0, do_bksp
    
    # if not any special command
    j loop

do_bksp:
    # check if x is at the start of line
    addi t0, s2, -10
    beq t0, zero, prev_line
    addi s2, s2, -8
    j erase

prev_line:
    addi t0, s3, -10
    beq t0, zero, loop      # ignore backspace if we're at the first line

    li s2, 618              # move x to the end of line
    addi s3, s3, -10        # move y up a line

erase:
    mv a0, s2
    mv a1, s3
    li a2, 8
    li a3, 8
    li a4, RED
    jal fill

    li a0, 3
    jal turn_on_led

    j loop

print:
    mv a0, s2
    mv a1, s3
    mv a2, s5
    li a3, BLACK
    jal print_ascii
    
    addi s2, s2, 8
    bge s2, s6, new_line

    # if no new line
    j loop

new_line:
    li s2, 10
    addi s3, s3, 10
    j loop

get_no_char:
    li s0, 0
#    li s7, 0
    li s4, KEYBOARD_TIMEOUT
    j loop

####################################################################################################################################################
####                                                                 functions                                                                  ####
####################################################################################################################################################

# brief: print a 8 * 8 ascii character
# a0: x coordinate
# a1: y coordinate
# a2: ascii character index
# a3: color (only lower 4 bits are used)
# a4: background fill (when not zero, fill the remaining part in the 8 * 8 area with black)
print_ascii:
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    li s0, ASCII_BASE
    slli a2, a2, 3
    add a2, a2, s0              # a2: address of the 2-word space holding the ascii char
    lw s0, 0(a2)                # s0: the first word of the ascii char

    li s5, 0                    # s5: which word?
    li s6, 2                    # s6: total words?
    li s2, 32                   # s2: process 32 bits in each word
print_ascii_switch_word_loop:
    beq s5, s6, print_ascii_end

    beq s5, zero, print_ascii_same_word
    lw s0, 4(a2)
print_ascii_same_word:
    li s1, 0
    mv s4, a0   

print_ascii_loop:
    beq s1, s2, print_ascii_loop_end

    andi s3, s0, 1              # s3: check if the first bit is 1

    # skip/paint black if the current pixel is not ascii char
    beq s3, zero, not_char
    draw_pixel s4, a1, a3
not_char:

    addi s4, s4, 1              # x += 1
    addi s1, s1, 1              # s1 += 1
    srli s0, s0, 1              # shift right the ascii char

    # go to next line every 8 bits printed
    li t0, 8
    sub t1, s4, a0
    bne t1, t0, print_ascii_same_line
    mv s4, a0
    addi a1, a1, 1
print_ascii_same_line:
    j print_ascii_loop
print_ascii_loop_end:

    addi s5, s5, 1
    j print_ascii_switch_word_loop
print_ascii_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40
    ret

# brief: fill a rectangular space in the display with color
# a0: x_start
# a1: y_start
# a2: width
# a3: height
# a4: color
fill:
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    mv s0, a0
    mv s1, a1
    add s2, s0, a2
    add s3, s1, a3
fill_loop_y:

fill_loop_x:
    draw_pixel s0, s1, a4

    addi s0, s0, 1
    bne s0, s2, fill_loop_x

    mv s0, a0
    addi s1, s1, 1
    bne s1, s3, fill_loop_y

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)

    addi sp, sp, 20
    ret

# a0: the index of led to be turned on
turn_on_led:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)

    li s0, LED_BASE
    lw s1, 0(s0)
    li s2, 1
    sll s2, s2, a0
    or s1, s1, s2
    sw s1, 0(s0)

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    ret

# a0: the index of led to be turned on
turn_off_led:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)

    li s0, LED_BASE
    lw s1, 0(s0)
    li s2, 1
    sll s2, s2, a0
    not s2, s2
    and s1, s1, s2
    sw s1, 0(s0)

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16
    ret








