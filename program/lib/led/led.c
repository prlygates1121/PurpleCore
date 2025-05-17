#include "led.h"

void turn_on_led(uint8_t id) {
    LED_REG |= (1 << id);
}

void set_led_all(uint16_t set) {
    LED_REG = set;
}

void turn_off_led(uint8_t id) {
    LED_REG &= ~(1 << id);
}
void toggle_led(uint8_t id) {
    LED_REG ^= (1 << id);
}
