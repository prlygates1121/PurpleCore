#include "../lib/uart/uart.h"
#include "../lib/led/led.h"
#include "../lib/seg_display/seg_display.h"

// uint32_t a[] = {1324, 3245, 1, 0, 2};

int main() {
    uint32_t i = 0, j = 0;
    while (1) {
        uart_putc(uart_getc());
        toggle_led(i);
        seg_display_show_num(j);
        j++;
        if (i == 15) {
            i = 0;
        } else {
            i = i + 1;
        }
    }
}
