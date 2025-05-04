#include "seg_display.h"

void seg_display_show_num(uint32_t num) {
    SEG_DISPLAY_REG = num;
}