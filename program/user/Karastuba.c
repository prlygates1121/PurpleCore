#include <stdint.h> // For int32_t

// -- Helper Functions (32-bit Integer Versions) --

/**
 * Calculates base to the power of exp using 32-bit integers.
 */
int32_t integer_power(int32_t base, int exp) {
    int32_t result = 1;
    for (int i = 0; i < exp; i++) {
        result *= base;
    }
    return result;
}

/**
 * Counts the number of digits in a 32-bit integer.
 */
int integer_get_size(int32_t n) {
    if (n == 0) return 1;
    int count = 0;
    int32_t num = n >= 0 ? n : -n;
    while (num > 0) {
        num /= 10;
        count++;
    }
    return count;
}

// -- Main Algorithm --

/**
 * Implements the Karatsuba algorithm for 32-bit integers.
 */
int32_t karatsuba(int32_t num1, int32_t num2) {
    // Base case: If numbers are small, use standard multiplication.
    if (num1 < 10 || num2 < 10) {
        return num1 * num2;
    }

    // Determine the split point.
    int size1 = integer_get_size(num1);
    int size2 = integer_get_size(num2);
    int size = size1 > size2 ? size1 : size2;
    int half_size = size / 2;

    // Calculate the power of 10 to split the numbers.
    int32_t m = integer_power(10, half_size);

    // Split numbers into high and low parts using division and modulo.
    int32_t a = num1 / m;
    int32_t b = num1 % m;
    int32_t c = num2 / m;
    int32_t d = num2 % m;

    // Three recursive multiplications.
    int32_t z0 = karatsuba(b, d);
    int32_t z2 = karatsuba(a, c);
    int32_t z1 = karatsuba(a + b, c + d);

    // Combine results using the Karatsuba formula.
    int32_t m2 = integer_power(10, 2 * half_size);
    int32_t result = (z2 * m2) + ((z1 - z2 - z0) * m) + z0;

    return result;
}

int main() {
    int32_t number1 = 4;
    int32_t number2 = 6;

    // printf("Multiplying %d and %d\n\n", number1, number2);
    
    // Calculate using Karatsuba
    int32_t karatsuba_result = karatsuba(number1, number2);
    // printf("Karatsuba Result:  %d\n", karatsuba_result);

    // Calculate using standard multiplication for verification
    int32_t standard_result = number1 * number2;
    // printf("Standard Result:   %d\n", standard_result);
    
    // printf("\nVerification: %s\n", (karatsuba_result == standard_result) ? "Success ✅" : "Failure ❌");

    volatile int32_t diff = karatsuba_result - standard_result;

    return 0;
}