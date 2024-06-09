#include <stdint.h>

/**
 * Return the provided value but with its bytes reversed.
 *
 * For example, 22t2final_q3(0x12345678) => 0x78563412
 *
 * *Note* that your task is to
 * reverse the order of *bytes*,
 * *not* to reverse the order of bits.
 **/

uint32_t _22t2final_q3(uint32_t value) {
    uint32_t result = 0;
    result |= (value & 0xFF000000) >> 24;
    result |= (value & 0x00FF0000) >> 8;
    result |= (value & 0x0000FF00) << 8;
    result |= (value & 0x000000FF) << 24; 
    return result;

}   
