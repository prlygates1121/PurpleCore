#include "trap_handler.h"
#include "csr.h"
#include "../lib/uart/uart.h"
#include "../lib/utils.h"
#include "../lib/led/led.h"
#include "../lib/seg_display/seg_display.h"
volatile struct trapframe trapframe;

extern void m_ret(uint32_t a0);

void m_trap_handler() {
    // save user trap pc in trapframe
    trapframe.user_pc = r_mepc();
    
    // ecall
    uint32_t cause = r_mcause();
    switch (cause) {
        case (ECALL_M):
            trapframe.user_pc += 4;
            ecall();
            break;
        case (INST_ACCESS_FAULT): 
        case (STORE_ACCESS_FAULT):
        case (LOAD_ACCESS_FAULT):
            char *s1 = "Exception Occurred.\n";
            uart_puts(s1);
            char *s2 = "mcause:\t";
            uart_puts(s2);
            uart_put_num(r_mcause());
            uart_putc('\n');
            char *s3 = "mepc:\t";
            uart_puts(s3);
            uart_put_num(r_mepc());
            uart_putc('\n');
            while (1);
        default:
            break;
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
            uart_puts(str);
            break;
        default:
    }
}