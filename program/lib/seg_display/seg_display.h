#include <stdint.h>
#define SEG_DISPLAY_REG (*(volatile uint32_t*)0x00700000)

void seg_display_show_num(uint32_t num);