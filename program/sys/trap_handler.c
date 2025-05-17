#include "trap_handler.h"
#include "csr.h"
#include "../lib/led/led.h"
struct trapframe trapframe;

extern void m_ret();

void m_trap_handler() {
    // save user trap pc in trapframe
    trapframe.user_pc = r_mepc();

    // ecall
    if (r_mcause() == 8) {
        trapframe.user_pc += 4;
        ecall();
    }

    m_trap_done();
}

void m_trap_done() {

    m_ret();
}

void ecall() {
    uint32_t a0 = trapframe.a0;
    switch (a0) {
        case 0:
                
            break;
        default:
    }
}