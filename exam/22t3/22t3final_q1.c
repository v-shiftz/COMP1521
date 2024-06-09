// COMP1521 22T3 ... final exam, question 1

#include <stdint.h>

uint32_t _22t3final_q1(uint32_t x) {
    uint32_t result = 0;
    result = x & 0x000ff000;
    result = result >> 12;
    return result;
}
