// Multiply a float by 2048 using bit operations only

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// float_2048 is given the bits of a float f as a uint32_t
// it uses bit operations and + to calculate f * 2048
// and returns the bits of this value as a uint32_t
//
// if the result is too large to be represented as a float +inf or -inf is returned
//
// if f is +0, -0, +inf or -inf, or Nan it is returned unchanged
//
// float_2048 assumes f is not a denormal number
//
uint32_t float_2048(uint32_t f) {
    uint32_t sign = (f >> 31) & 0x1;
    uint32_t exponent = (f >> 23) & 0xff;
    uint32_t fraction = f & 0x007fffff;
    if (exponent == 0){
        return f;
    }else if (exponent == 0xff) {
        return f;
    } else {
        uint32_t newExponent = exponent + 11;
        if (newExponent >= 0xff) {
            return sign << 31 | 0x7f800000;
        } else {
            return sign << 31 | newExponent << 23 | fraction;
        }
    }
}
