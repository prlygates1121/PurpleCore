#include "../lib/uart/uart.h"
#include "../lib/seg_display/seg_display.h"
#include "../lib/led/led.h"
#include "../sys/csr.h"

void ecall_test();

int main() {
    w_mboot(0);
    int i = 0;
    while (1) {
        uart_put_num(i++);
        uart_putc('\n');
        ecall_test();
        uart_putc('\n');
    }
}