#include "../lib/uart/uart.h"
#include "../lib/seg_display/seg_display.h"
#include "../sys/csr.h"
void ecall_test();

int main() {
    // for (uint32_t i = 0; ; i++) {
    //     seg_display_show_num(i);
    //     ecall_test();
    // }
    w_mboot(0);
    volatile uint32_t *ptr = (volatile uint32_t*)(0x00000008);
    goto *ptr;
}