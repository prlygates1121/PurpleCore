#include <stdint.h>

#define BUTTON_REG (*(volatile uint8_t*)0x80600000)

uint8_t get_button_left();
uint8_t get_button_right();
uint8_t get_button_up();
uint8_t get_button_down();
uint8_t get_button_center();
uint8_t get_button_all();