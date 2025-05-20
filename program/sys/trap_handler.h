#include <stdint.h>

#define INST_ACCESS_FAULT  1
#define LOAD_ACCESS_FAULT  5
#define STORE_ACCESS_FAULT 7
#define ECALL_M            11
#define NO_EXCP            24

struct trapframe {
    /*   0 */ uint32_t trap_sp;           // top of the trap stack
    /*   4 */ uint32_t trap_handler;      // address of the trap handler function
    /*   8 */ uint32_t user_pc;           // address of the trapped instruction
    /*  12 */ uint32_t ra;
    /*  16 */ uint32_t sp;
    /*  20 */ uint32_t gp;
    /*  24 */ uint32_t tp;
    /*  28 */ uint32_t t0;
    /*  32 */ uint32_t t1;
    /*  36 */ uint32_t t2;
    /*  40 */ uint32_t s0;
    /*  44 */ uint32_t s1;
    /*  48 */ uint32_t a0;
    /*  52 */ uint32_t a1;
    /*  56 */ uint32_t a2;
    /*  60 */ uint32_t a3;
    /*  64 */ uint32_t a4;
    /*  68 */ uint32_t a5;
    /*  72 */ uint32_t a6;
    /*  76 */ uint32_t a7;
    /*  80 */ uint32_t s2;
    /*  84 */ uint32_t s3;
    /*  88 */ uint32_t s4;
    /*  92 */ uint32_t s5;
    /*  96 */ uint32_t s6;
    /* 100 */ uint32_t s7;
    /* 104 */ uint32_t s8;
    /* 108 */ uint32_t s9;
    /* 112 */ uint32_t s10;
    /* 116 */ uint32_t s11;
    /* 120 */ uint32_t t3;
    /* 124 */ uint32_t t4;
    /* 128 */ uint32_t t5;
    /* 132 */ uint32_t t6;
};

void m_trap_handler();
void m_trap_done();
void ecall();