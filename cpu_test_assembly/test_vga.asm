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

# brief: draw a pixel on the VGA memory buffer
# x: x coordinate
# y: y coordinate
# color: color value (only lower 4 bits are used)
.macro draw_pixel x y color
    li t0, DISPLAY_WIDTH
    li t1, VGA_BASE
    li t6, bits_4
    mul t2, \y, t0              # pixel index (row)
    add t2, t2, \x              # pixel index (row + col)
    andi t3, t2, 1              # t3: select which pixel inside byte (0: first pixel, 1: second pixel)
    slli t3, t3, 2              # (0: first pixel, 4: second pixel)
    andi t4, \color, 0b1111     # get the least significant 4 bits of the color
    sll t4, t4, t3              # shift color left by 4 bits if we want the second pixel
    srl t6, t6, t3              # shift bits_4 right by 4 bits if we want the second pixel
    srli t2, t2, 1              # byte index (1/2 byte per pixel)
    add t2, t2, t1              # vga write address
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
.macro draw_pixel_8 x y colors
    li t0, DISPLAY_WIDTH
    li t1, VGA_BASE
    mul t2, \y, t0
    add t2, t2, \x              # pixel index
    srli t2, t2, 1              # byte index
    add t2, t2, t1              # vga write address
    sw \colors, 0(t2)
.endm

.macro m_print_ascii x y color char_name
    mv a0, \x
    mv a1, \y
    li a2, \char_name
    li a3, \color
    jal print_ascii
.endm

.section .text
.global _start

_start:
    li s0, 10
    li s1, 10
    m_print_ascii s0, s1, BLACK, I
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, n
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, SPACE
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, a
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, SPACE
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, g
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, a
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, l
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, a
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, x
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, y
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, SPACE
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, f
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, a
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, r
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, COMMA
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, SPACE
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, f
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, a
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, r
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, SPACE
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, a
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, w
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, a
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, y
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, PERIOD
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, PERIOD
    addi s0, s0, 8
    m_print_ascii s0, s1, BLACK, PERIOD

what:
    j what

# brief: print a 8 * 8 ascii character
# a0: x coordinate
# a1: y coordinate
# a2: ascii character index
# a3: color (only lower 4 bits are used)
# a4: background fill (when not zero, fill the remaining part in the 8 * 8 area with black)
print_ascii:
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
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
    addi sp, sp, 32
    ret








