#include "../lib/uart/uart.h"
#include "../lib/seg_display/seg_display.h"
#include "../lib/led/led.h"

void ecall_test();

int main() {
    for (uint32_t count = 0; ; count++) {
        if ((count & 0xFFFF) == 0) {
            ecall_test();
            uart_put_num(count);
            uart_putc('\n');
            seg_display_show_num(count);
        }
    }
}