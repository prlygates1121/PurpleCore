#include <stdint.h>
#define SEG_DISPLAY_REG (*(volatile uint32_t*)0x80700000)

void seg_display_show_num(uint32_t num);