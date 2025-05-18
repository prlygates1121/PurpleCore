#include "uart.h"
#include "../utils.h"

void uart_putc(char c) {
    while (!(UART_STATUS_REG & UART_TX_RDY));
    UART_DATA_REG = c;
}

void uart_puts(const char* s, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        uart_putc(s[i]);
    }
}

void uart_put_num(int num) {
    char s[100];
    itoa(num, s);
    uart_puts(s, strlen((char*)s));
}

char uart_getc() {
    while (!(UART_STATUS_REG & UART_RX_RDY));
    return UART_DATA_REG;
}

int uart_has_char() {
    return UART_STATUS_REG & UART_RX_RDY;
}