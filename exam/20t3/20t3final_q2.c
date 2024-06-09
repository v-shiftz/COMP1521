// COMP1521 20T3 final exam Q2 starter code

#include <stdlib.h>
#include <stdint.h>
#include <assert.h>

// given a uint32_t,
// return 1 iff the least significant bit
// is equal to the most significant bit
// return 0 otherwise
int final_q2(uint32_t value) {
    if (value << 31 >> 31 == value >> 31) {
        return 1;
    } else {
        return 0;
    }
}
