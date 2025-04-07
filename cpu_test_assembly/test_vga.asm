.equ VGA_BASE,              0x80300000
.equ DISPLAY_WIDTH,         640
.equ DISPLAY_HEIGHT,        480
.equ bits_4,                0b11110000

# brief: draw a pixel on the VGA memory buffer
.macro draw_pixel x y color
    li t0, DISPLAY_WIDTH
    li t1, VGA_BASE
    li t6, bits_4
    mul t2, \x, t0              # pixel index (row)
    add t2, t2, \y              # pixel index (row + col)
    andi t3, t2, 1              # t3: select which pixel inside byte (0: first pixel, 1: second pixel)
    slli t3, t3, 2              # (0: first pixel, 4: second pixel)
    sll t4, \color, t3          # shift color left by 4 bits if we want the second pixel
    srl t6, t6, t3              # shift bits_4 right by 4 bits if we want the second pixel
    srli t2, t2, 1              # byte index (1/2 byte per pixel)
    add t2, t2, t1              # vga write address
    lbu t5, 0(t2)               # read original byte from memory
    and t5, t5, t6              # and the byte with bits_4
    or t5, t5, t4               # or the byte with color
    sb t5, 0(t2)                # store the byte back to memory
    lbu t5, 0(t2)
.endm

# brief: draw 8 consecutive pixels (32-bit word) on the VGA memory buffer
# note: make sure the pixel position align with the word boundary (pixel index divisible by 8)
.macro draw_pixel_8 x y colors
    li t0, DISPLAY_WIDTH
    li t1, VGA_BASE
    mul t2, \x, t0
    add t2, t2, \y              # pixel index
    srli t2, t2, 1              # byte index
    add t2, t2, t1              # vga write address
    sw \colors, 0(t2)
.endm

.section .text
.global _start

_start:
    
    li s0, 0
    li s1, DISPLAY_HEIGHT
    li s2, 0
#outer_loop:
#    beq s3, s4, outer_loop_end
#    mv s0, s5
loop:
    beq s0, s1, loop_end
    draw_pixel s0, s0, s2
    addi s2, s2, 1
    andi s2, s2, 0b1111
    addi s0, s0, 1
    j loop
loop_end:
    j loop_end
#    addi s3, s3, 10
#    addi s5, s5, 1
#    j outer_loop
#outer_loop_end:
#
#    j outer_loop_end



