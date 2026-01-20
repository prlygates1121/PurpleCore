#include <stdint.h>

#define PLIC_PRIORITY(i)    (*((volatile uint32_t*)0x00100000 + i))
#define PLIC_ENABLE         (*(volatile uint32_t*)0x00100020)
#define PLIC_THRESHOLD      (*(volatile uint8_t*)0x00100040)
#define PLIC_PENDING        (*(volatile uint32_t*)0x00100060)
#define PLIC_CLAIM          (*(volatile uint32_t*)0x00100080)
#define PLIC_COMPLETE       (*(volatile uint32_t*)0x00100080)
#define PLIC_CLEAR          (*(volatile uint32_t*)0x001000A0)

#define PLIC_BT_UP      0
#define PLIC_BT_DOWN    1
#define PLIC_BT_LEFT    2
#define PLIC_BT_RIGHT   3
#define PLIC_BT_CENTER  4

void plic_init();
void plic_set_priority(uint32_t idx, uint8_t priority);
uint8_t plic_get_priority(uint8_t idx);
void plic_set_enable(uint32_t enable);
uint32_t plic_get_enable();
void plic_set_threshold(uint8_t threshold);
uint8_t plic_get_threshold();
uint32_t plic_get_pending();
uint32_t plic_claim();
void plic_complete(uint32_t idx);
void plic_clear(uint32_t clear);