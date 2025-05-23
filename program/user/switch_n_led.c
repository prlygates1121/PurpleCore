#include "../lib/uart/uart.h"
#include "../lib/seg_display/seg_display.h"
#include "../sys/csr.h"
#include "../lib/led/led.h"
#include "../lib/switch/switch.h"
#include "../lib/button/button.h"
void ecall_test();

int main() {
    while (1) {
        set_led_all(get_switch_all());
    }
}