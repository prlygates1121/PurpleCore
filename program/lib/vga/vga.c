#include "vga.h"

void vga_draw_point(uint32_t x, uint32_t y, uint8_t color) {
    volatile uint8_t *pointer = VGA_BASE_ADDR;
    pointer += VGA_WIDTH_BYTES * y + x >> 1;
    if (x & 0x1) {
        *pointer &= ((0xF << 4) | (color & 0xF));
    } else {
        *pointer &= (0xF | (color << 4));
    }
}

void vga_clear(uint8_t color) {
    volatile uint8_t *pointer = VGA_BASE_ADDR;
    while (pointer != VGA_BASE_ADDR + VGA_HEIGHT_BYTES * VGA_WIDTH_BYTES) {
        *pointer = (color << 4) | color;
        pointer++;
    }
}