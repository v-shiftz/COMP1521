// generate the encoded binary for an addi instruction, including opcode and operands

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "addi.h"

// return the encoded binary MIPS for addi $t,$s, i
uint32_t addi(int t, int s, int i) {
    uint32_t opcode = 0b001000;
    uint32_t fiveT = t & 0b11111;
    uint32_t fiveS = s & 0b11111;
    uint32_t sixteenI = i & 0xffff;

    uint32_t total = (opcode<<26) | (fiveS << 21) | (fiveT << 16) | (sixteenI);
    return total; // REPLACE WITH YOUR CODE

}
