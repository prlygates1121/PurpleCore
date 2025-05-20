#include "csr.h"
#include "../lib/seg_display/seg_display.h"

uint32_t r_mstatus() {
    uint32_t x;
    asm volatile("csrr %0, mstatus" : "=r" (x));
    return x;
}

void w_mstatus(uint32_t x) {
    asm volatile("csrw mstatus, %0" : : "r" (x) );
}

uint32_t r_mepc() {
    uint32_t x;
    asm volatile("csrr %0, mepc" : "=r" (x));
    return x;
}

void w_mepc(uint32_t x) {
    asm volatile("csrw mepc, %0" : : "r" (x));
}

uint32_t r_mcause() {
    uint32_t x;
    asm volatile("csrr %0, mcause" : "=r" (x));
    return x;
}

void w_mcause(uint32_t x) {
    asm volatile("csrw mcause, %0" : : "r" (x));
}

void w_mboot(uint32_t x) {
    asm volatile("csrw 0x7C0, %0" : : "r" (x));
}