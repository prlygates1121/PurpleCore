#include "button.h"

uint8_t get_button_left() {
    return (BUTTON_REG >> 2) & 1;
}

uint8_t get_button_right() {
    return (BUTTON_REG >> 3) & 1;
}

uint8_t get_button_up() {
    return (BUTTON_REG) & 1;
}

uint8_t get_button_down() {
    return (BUTTON_REG >> 1) & 1;
}

uint8_t get_button_center() {
    return (BUTTON_REG >> 4) & 1;
}

uint8_t get_button_all() {
    return BUTTON_REG;
}