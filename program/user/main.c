#include "../sys/plic.h"
#include "../lib/seg_display/seg_display.h"

int main() {
    plic_init();
    while(1);
}