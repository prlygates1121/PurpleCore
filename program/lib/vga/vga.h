#include <stdint.h>

#define VGA_BASE_ADDR ((volatile uint8_t*)0x80400000)
#define VGA_HEIGHT_PIXELS 480
#define VGA_WIDTH_PIXELS 640
#define VGA_HEIGHT_BYTES (VGA_HEIGHT_PIXELS/2)
#define VGA_WIDTH_BYTES (VGA_WIDTH_PIXELS/2)

#define BLACK               0
#define WHITE               1
#define RED                 2
#define ORANGE              3
#define YELLOW              4
#define LIGHT_GREEN         5
#define GREEN               6
#define SPRING_GREEN        7
#define CYAN                8
#define SKY_BLUE            9
#define BLUE                10
#define PURPLE              11
#define PINK                12
#define ROSE                13
#define SUPERNOVA           14
#define GRAY                15

#define BACKGROUND_COLOR    BLACK

/**
 * 8x8 monochrome bitmap fonts for rendering
 * Author: Daniel Hepper <daniel@hepper.net>
 *
 * License: Public Domain
 *
 * Based on:
 * // Summary: font8x8.h
 * // 8x8 monochrome bitmap fonts for rendering
 * //
 * // Author:
 * //     Marcel Sondaar
 * //     International Business Machines (public domain VGA fonts)
 * //
 * // License:
 * //     Public Domain
 *
 * Fetched from: http://dimensionalrift.homelinux.net/combuster/mos3/?p=viewsource&file=/modules/gfx/font8_8.asm
 **/

// Constant: font8x8_basic
// Contains an 8x8 font map for unicode points U+0000 - U+007F (basic latin)
extern const char font_88[128][8];

void vga_draw_point(uint32_t x, uint32_t y, uint8_t color);
void vga_clear(uint8_t color);
void vga_print_char(uint32_t x, uint32_t y, uint8_t char_code, uint8_t fill, uint8_t color);