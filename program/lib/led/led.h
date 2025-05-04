#include <stdint.h>
#define LED_REG (*(volatile uint16_t*)0x80200000)

void turn_on_led(uint8_t id);
void turn_off_led(uint8_t id);
void toggle_led(uint8_t id);

