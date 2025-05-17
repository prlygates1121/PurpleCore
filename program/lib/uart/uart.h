#include <stdint.h>
#define UART_DATA_REG   (*(volatile unsigned char*)0x80800000)
#define UART_STATUS_REG (*(volatile unsigned char*)0x80800004)

#define UART_RX_RDY (1 << 0) // Bit 0: Receive Ready
#define UART_TX_RDY (1 << 1) // Bit 1: Transmit Ready

void uart_putc(char c);
void uart_puts(const char* s, uint32_t len);
char uart_getc();
int uart_has_char();