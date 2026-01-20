#include "plic.h"

void plic_init() {
    plic_set_threshold(2);

    plic_set_priority(PLIC_BT_UP, 5);
    plic_set_priority(PLIC_BT_DOWN, 5);
    plic_set_priority(PLIC_BT_LEFT, 5);
    plic_set_priority(PLIC_BT_RIGHT, 5);
    plic_set_priority(PLIC_BT_CENTER, 5);

    plic_set_enable(plic_get_enable() | 0b11111);
}

void plic_set_priority(uint32_t idx, uint8_t priority) {
    PLIC_PRIORITY(idx) = priority;
}

uint8_t plic_get_priority(uint8_t idx) {
    return PLIC_PRIORITY(idx);
}

void plic_set_enable(uint32_t enable) {
    PLIC_ENABLE = enable;
}

uint32_t plic_get_enable() {
    return PLIC_ENABLE;
}

void plic_set_threshold(uint8_t threshold) {
    PLIC_THRESHOLD = threshold;
}

uint8_t plic_get_threshold() {
    return PLIC_THRESHOLD;
}

uint32_t plic_get_pending() {
    return PLIC_PENDING;
}

// claims an interrupt: read PLIC_CONTROL to get the idx of the most urgent interrupt
uint32_t plic_claim() {
    return PLIC_CLAIM;
}

void plic_complete(uint32_t idx) {
    PLIC_COMPLETE = idx;
}

void plic_clear(uint32_t clear) {
    PLIC_CLEAR = clear;
}