#include "../lib/uart/uart.h"
#include "../lib/seg_display/seg_display.h"
#include "../lib/led/led.h"
#include "../lib/vga/vga.h"
#include "../sys/csr.h"

void ecall_test();

int main() {
    // draw a shape on the screen
    vga_clear(BLACK);
    for (int i = 0; i < VGA_WIDTH_PIXELS; i++) {
        for (int j = 0; j < VGA_HEIGHT_PIXELS; j++) {
            if ((i / 10) % 2 == 0 && (j / 10) % 2 == 0) {
                vga_draw_point(i, j, WHITE);
            } else {
                vga_draw_point(i, j, BLACK);
            }
        }
    }
}