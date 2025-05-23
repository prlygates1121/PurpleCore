#include "../lib/uart/uart.h"
#include "../lib/keyboard/keyboard.h"
#include "../lib/vga/vga.h"

void ecall_test();

int main() {
    uint8_t key;
    uint8_t pressed = 0;
    uint32_t x = 10;
    uint32_t y = 10;
    uint32_t hold_time = 0;
    uint8_t continuing = 0;
    vga_clear(BACKGROUND_COLOR);
    while (1) {
        key = keyboard_read();
        if (key != k_NONE) {
            if (hold_time > 2000000) {
                continuing = 1;
            }
            if (!pressed || continuing && hold_time > 200000) {
                hold_time = 0;
                // uart_put_num(x);
                // uart_puts(" and ");
                // uart_put_num(y);
                // uart_putc('\n');
                if (key == k_BACKSPACE) {
                    if (x == 10) {
                        x = 602;
                        y -= 8;
                    } else {
                        x -= 8;
                    }
                    vga_print_char(x, y, ' ', 1, RED);
                } else {
                    vga_print_char(x, y, key + 0x20, 1, WHITE);
                    if (x > VGA_WIDTH_PIXELS - 40) {
                        x = 10;
                        y += 8;
                    } else {
                        x += 8;
                    }
                }
                pressed = 1;
            } else {
                hold_time++;
            }
        } else {
            continuing = 0;
            hold_time = 0;
            pressed = 0;
        }
    }
}