#include <stdint.h>
#define UART_DATA_REG       (*(volatile unsigned char*)0x80800000)
#define UART_STATUS_REG     (*(volatile unsigned char*)0x80800004)
#define UART_CONTROL_REG    (*(volatile uint32_t*)0x80800008)

#define CLK_MAIN_FREQ 40000000

#define UART_RX_RDY (1 << 0) // Bit 0: Receive Ready
#define UART_TX_RDY (1 << 1) // Bit 1: Transmit Ready

void uart_putc(char c);
void uart_puts(const char* s);
void uart_put_num(int num);
void uart_put_num_hex(uint32_t num);
char uart_getc();
uint32_t uart_get_num();
int uart_has_char();
void uart_set_freq(uint32_t cnt_max);
uint32_t uart_get_freq();