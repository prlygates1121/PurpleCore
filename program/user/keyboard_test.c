#include "../lib/uart/uart.h"
#include "../lib/keyboard/keyboard.h"

void ecall_test();

int main() {
    uint8_t key;
    uint8_t pressed = 0;
    while (1) {
        key = keyboard_read();
        if (key != k_NONE) {
            if (!pressed) {
                uart_putc(key + 0x20);
                pressed = 1;
            }
        } else {
            pressed = 0;
        }
    }
}