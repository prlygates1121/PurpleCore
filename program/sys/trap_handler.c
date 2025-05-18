#include <string.h>
#include "trap_handler.h"
#include "csr.h"
#include "../lib/uart/uart.h"
#include "../lib/seg_display/seg_display.h"
volatile struct trapframe trapframe;

extern void m_ret(uint32_t a0);

void m_trap_handler() {
    // save user trap pc in trapframe
    trapframe.user_pc = r_mepc();

    // ecall
    if (r_mcause() == 11) {
        trapframe.user_pc += 4;
        ecall();
    }

    m_trap_done();
}

void m_trap_done() {

    w_mepc(trapframe.user_pc);

    m_ret((uint32_t)(&trapframe));
}

void ecall() {
    uint32_t a7 = trapframe.a7;
    switch (a7) {
        case 0:
            char* str = "I'm an ecall!";
            uart_puts(str, 13);
            break;
        default:
    }
}