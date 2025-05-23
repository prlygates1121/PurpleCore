#include "uart.h"
#include "../utils.h"

void uart_putc(char c) {
    while (!(UART_STATUS_REG & UART_TX_RDY));
    UART_DATA_REG = c;
}

void uart_puts(const char* s) {
    while (*s) {
        uart_putc(*s++);
    }
}

void uart_put_num(int num) {
    char s[12];
    itoa(num, s);
    uart_puts(s);
}

char uart_getc() {
    while (!(UART_STATUS_REG & UART_RX_RDY));
    return UART_DATA_REG;
}

uint32_t uart_get_num() {
    int i = 0;
    char digit[32];
    while (i < 32) {
        digit[i] = uart_getc();
        if (digit[i] == '\n' || digit[i] == '\r') {
            break;
        }
        i++;
    }
    if (i == 0) {
        return 0;
    }
    uint32_t res = 0;
    for (int j = 0; j < i; j++) {
        res = res * 10 + (digit[j] - '0');
    }
    return res;
}


int uart_has_char() {
    return UART_STATUS_REG & UART_RX_RDY;
}

void uart_set_freq(uint32_t cnt_max) {
    if (cnt_max < 40) {
        uart_puts("Set frequency failed: UART frequency must be <= 1000000.\n");
        return;
    }
    UART_CONTROL_REG = cnt_max;
}

uint32_t uart_get_freq() {
    return UART_CONTROL_REG;
}