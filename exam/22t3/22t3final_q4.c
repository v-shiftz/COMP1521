// COMP1521 22T3 ... final exam, question 4

#include <stdint.h>
#include <stdio.h>

int _22t3final_q4(uint32_t x) {
    int count = 0;
    int max = 0;
    for (int i = 31; i >= 0; i--) {
        if((x >> i) & 1) {
            count++;
        } else {
            count = 0;
        }
        if (max < count) {
            max = count;
        }
    }
    return max;
}
