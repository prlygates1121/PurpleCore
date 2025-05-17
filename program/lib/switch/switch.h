#include <stdint.h>

#define SWITCH_REG (*(volatile uint16_t*)0x80300000)

uint8_t get_switch(uint8_t id);
uint16_t get_switch_all();