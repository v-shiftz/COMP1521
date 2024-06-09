// swap pairs of bits of a 64-bit value, using bitwise operators

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return value with pairs of bits swapped
uint64_t bit_swap(uint64_t value) {
    // PUT YOUR CODE HERE
    
    uint64_t result = 0;
    int position = 0;
    while (position < 64) {
        uint64_t bit_pair = (value >> position) & 0b11;
        bit_pair = ((bit_pair & 0b01) << 1) | ((bit_pair & 0b10) >> 1);
        result |= (bit_pair << position);
        position += 2;
    }
    return result;
}
