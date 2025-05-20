#include "../lib/uart/uart.h"
#include "../lib/keyboard/keyboard.h"
#include "../lib/vga/vga.h"

void ecall_test();

int main() {
    vga_clear(BACKGROUND_COLOR);
    vga_print_char(100, 100, 'a', 0, WHITE);
    vga_print_char(400, 400, '!', 0, BLUE);
    for (int i = 0; i < 40; i++) {
        vga_draw_point(i, i, i & 0xF);
    }
}