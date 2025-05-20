#include <stdint.h>

#define MSTATS_MIE (1 << 3)

uint32_t r_mstatus();
void w_mstatus(uint32_t x);
uint32_t r_mepc();
void w_mepc(uint32_t x);
uint32_t r_mcause();
void w_mcause(uint32_t x);
void w_mboot(uint32_t x);