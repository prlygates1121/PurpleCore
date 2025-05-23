#include "trap_handler.h"
#include "csr.h"
#include "../lib/uart/uart.h"
#include "../lib/utils.h"
#include "../lib/led/led.h"
#include "../lib/button/button.h"
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
            char *s2 = "mcause:\t\t";
            uart_puts(s2);
            uart_put_num_hex(r_mcause());
            uart_putc('\n');
            char *s3 = "mepc:\t\t";
            uart_puts(s3);
            uart_put_num_hex(r_mepc());
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
            uart_puts("I'm an ecall!");
            break;
        case 1:
            while (1);
        case 2:
            // print out the registesrs and other info saved in trapframe, just like gdb
            uart_puts("trapframe:\n");
            uart_puts("trap_sp:\t\t");
            uart_put_num_hex(trapframe.trap_sp);
            uart_putc('\n');
            uart_puts("trap_handler:\t");
            uart_put_num_hex(trapframe.trap_handler);
            uart_putc('\n');
            uart_puts("user_pc:\t\t");
            uart_put_num_hex(trapframe.user_pc);
            uart_putc('\n');
            uart_puts("ra:\t\t\t\t");
            uart_put_num_hex(trapframe.ra);
            uart_putc('\n');
            uart_puts("sp:\t\t\t\t");
            uart_put_num_hex(trapframe.sp);
            uart_putc('\n');
            uart_puts("gp:\t\t\t\t");
            uart_put_num_hex(trapframe.gp);
            uart_putc('\n');
            uart_puts("tp:\t\t\t\t");
            uart_put_num_hex(trapframe.tp);
            uart_putc('\n');
            uart_puts("t0:\t\t\t\t");
            uart_put_num_hex(trapframe.t0);
            uart_putc('\n');
            uart_puts("t1:\t\t\t\t");
            uart_put_num_hex(trapframe.t1);
            uart_putc('\n');
            uart_puts("t2:\t\t\t\t");
            uart_put_num_hex(trapframe.t2);
            uart_putc('\n');
            uart_puts("s0:\t\t\t\t");
            uart_put_num_hex(trapframe.s0);
            uart_putc('\n');
            uart_puts("s1:\t\t\t\t");
            uart_put_num_hex(trapframe.s1);
            uart_putc('\n');
            uart_puts("a0:\t\t\t\t");
            uart_put_num_hex(trapframe.a0);
            uart_putc('\n');
            uart_puts("a1:\t\t\t\t");
            uart_put_num_hex(trapframe.a1);
            uart_putc('\n');
            uart_puts("a2:\t\t\t\t");
            uart_put_num_hex(trapframe.a2);
            uart_putc('\n');
            uart_puts("a3:\t\t\t\t");
            uart_put_num_hex(trapframe.a3);
            uart_putc('\n');
            uart_puts("a4:\t\t\t\t");
            uart_put_num_hex(trapframe.a4);
            uart_putc('\n');
            uart_puts("a5:\t\t\t\t");
            uart_put_num_hex(trapframe.a5);
            uart_putc('\n');
            uart_puts("a6:\t\t\t\t");
            uart_put_num_hex(trapframe.a6);
            uart_putc('\n');
            uart_puts("a7:\t\t\t\t");
            uart_put_num_hex(trapframe.a7);
            uart_putc('\n');
            uart_puts("s2:\t\t\t\t");
            uart_put_num_hex(trapframe.s2);
            uart_putc('\n');
            uart_puts("s3:\t\t\t\t");
            uart_put_num_hex(trapframe.s3);
            uart_putc('\n');
            uart_puts("s4:\t\t\t\t");
            uart_put_num_hex(trapframe.s4);
            uart_putc('\n');
            uart_puts("s5:\t\t\t\t");
            uart_put_num_hex(trapframe.s5);
            uart_putc('\n');
            uart_puts("s6:\t\t\t\t");
            uart_put_num_hex(trapframe.s6);
            uart_putc('\n');
            uart_puts("s7:\t\t\t\t");
            uart_put_num_hex(trapframe.s7);
            uart_putc('\n');
            uart_puts("s8:\t\t\t\t");
            uart_put_num_hex(trapframe.s8);
            uart_putc('\n');
            uart_puts("s9:\t\t\t\t");
            uart_put_num_hex(trapframe.s9);
            uart_putc('\n');
            uart_puts("s10:\t\t\t");
            uart_put_num_hex(trapframe.s10);
            uart_putc('\n');
            uart_puts("s11:\t\t\t");
            uart_put_num_hex(trapframe.s11);
            uart_putc('\n');
            uart_puts("t3:\t\t\t\t");
            uart_put_num_hex(trapframe.t3);
            uart_putc('\n');
            uart_puts("t4:\t\t\t\t");
            uart_put_num_hex(trapframe.t4);
            uart_putc('\n');
            uart_puts("t5:\t\t\t\t");
            uart_put_num_hex(trapframe.t5);
            uart_putc('\n');
            uart_puts("t6:\t\t\t\t");
            uart_put_num_hex(trapframe.t6);
            uart_putc('\n');
            int flag = 1;
            while (1) {
                if (get_button_center()) {
                    if (!flag) {
                        break;
                    }
                    flag = 1;
                } else {
                    flag = 0;
                }
            }
            break;
        default:
            break;
    }
}