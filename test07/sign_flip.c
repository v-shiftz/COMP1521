#include "sign_flip.h"

// given the 32 bits of a float return it with its sign flipped
uint32_t sign_flip(uint32_t f) {
    //return f ^ 0x80000000;
    uint32_t sign_bit = (f >> 31) & 0b1;
    sign_bit = sign_bit ^ 0b1;
    f = f & 0x7FFFFFFF;    
    f = f | (sign_bit << 31);
    return f;
}
