#include <stdint.h>

void *memset(void *ptr, int value, unsigned int num);
void reverse(char str[], int length);
void itoa_dec(int value, char* buffer);
void itoa_hex(uint32_t value, char* buffer);
uint32_t strlen(const char *str);