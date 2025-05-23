#include "utils.h"

uint32_t strlen(const char *str) {
    const char *s;
    for (s = str; *s; ++s);
    return (s - str);
}

// Helper function to reverse a string
// str: The character array to reverse
// length: The length of the string in the array
void reverse(char str[], int length) {
    int start = 0;
    int end = length - 1;
    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        start++;
        end--;
    }
}

// Implementation of itoa for decimal conversion without using '/' or '%'
// value: The integer to convert
// buffer: The character array to store the resulting string
// Returns: A pointer to the buffer
void itoa_dec(int value, char* buffer) {
    int i = 0; // Index for the buffer
    int is_negative = 0;
    unsigned int u_value; // Use unsigned int to handle magnitude of INT_MIN

    // 1. Handle 0 explicitly
    if (value == 0) {
        buffer[i++] = '0';
        buffer[i] = '\0';
        return;
    }

    u_value = (unsigned int)value;

    // 3. Process individual digits by repeatedly subtracting 10
    // Digits are generated in reverse order
    while (u_value > 0) {
        unsigned int remainder_val = u_value;
        unsigned int quotient_val = 0;

        // Simulate remainder_val = u_value % 10;
        // Simulate quotient_val = u_value / 10;
        // This loop subtracts 10 until remainder_val is < 10.
        // quotient_val counts how many times 10 was subtracted.
        while (remainder_val >= 10) {
            remainder_val -= 10;
            quotient_val++;
        }

        buffer[i++] = remainder_val + '0'; // remainder_val is the current last digit
        u_value = quotient_val;            // u_value becomes the number without its last digit
    }

    // 4. If the number was negative, append the minus sign
    if (is_negative) {
        buffer[i++] = '-';
    }

    // 5. Null-terminate the string
    buffer[i] = '\0';

    // 6. Reverse the string to get the correct order
    reverse(buffer, i); // i is the current length of the string

}

void itoa_hex(uint32_t value, char* buffer) {
    int i = 2;
    buffer[0] = '0';
    buffer[1] = 'x';
    for (int j = 7; j >= 0; j--) {
        uint8_t digit = (value >> (j << 2)) & 0xF;
        if (digit < 10) {
            buffer[i++] = digit + '0';
        } else {
            buffer[i++] = digit - 10 + 'A';
        }
    }
    buffer[i] = '\0';
}