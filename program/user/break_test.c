#include "../lib/seg_display/seg_display.h"
void ecall_test();
void ecall_stop();
void ecall_break();

int main() {
    for (int i = 0; i < 10; i++) {
        seg_display_show_num(i);
        ecall_break();
    }
}