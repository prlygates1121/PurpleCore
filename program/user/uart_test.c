#include "../lib/uart/uart.h"
#include "../lib/led/led.h"
#include "../lib/seg_display/seg_display.h"

uint32_t a[5];

int main() {
    a[0] = 124;
    a[1] = 45;
    a[2] = 1;
    a[3] = 0;
    a[4] = 2;
    for (int i = 0; i < 5; i++) {
        uart_putc(a[i]);
    }
}
