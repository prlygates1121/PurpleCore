#include "uart.h"

void uart_putc(char c) {
    while (!(UART_STATUS_REG & UART_TX_RDY));
    UART_DATA_REG = c;
}

char uart_getc() {
    while (!(UART_STATUS_REG & UART_RX_RDY));
    return UART_DATA_REG;
}

int uart_has_char() {
    return UART_STATUS_REG & UART_RX_RDY;
}