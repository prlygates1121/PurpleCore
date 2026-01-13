#include <stdint.h>
#define LED_REG (*(volatile uint16_t*)0x00200000)

void turn_on_led(uint8_t id);
void set_led_all(uint16_t set);
void turn_off_led(uint8_t id);
void toggle_led(uint8_t id);

