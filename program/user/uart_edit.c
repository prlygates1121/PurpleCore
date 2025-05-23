#include "../lib/uart/uart.h"
#include "../lib/seg_display/seg_display.h"
#include "../sys/csr.h"
#include "../lib/button/button.h"
void ecall_test();

int main() {
    uint32_t num = 0;
    int flag = 0;
    int button = 0;
    while (1) {
        button = get_button_all();
        if (button != 0) {
            if (!flag) {
                if ((button >> 3) & 1) {
                    uart_puts("Please input UART counter max value:");
                    num = uart_get_num();
                    uart_set_freq(num);
                } else if ((button >> 2) & 1) {
                    uart_puts("Current UART counter max value:");
                    uart_put_num(uart_get_freq());
                }
            }
            flag = 1;
        } else {
            flag = 0;
        }
    }
    // uart_set_freq(0x4331);
}