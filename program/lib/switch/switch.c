#include "switch.h"

uint8_t get_switch(uint8_t id) {
    return (SWITCH_REG >> id) & 1;
}

uint16_t get_switch_all() {
    return SWITCH_REG;
}