// Convert string of binary digits to 16-bit signed integer

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#define N_BITS 16

int16_t sixteen_in(char *bits);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        printf("%d\n", sixteen_in(argv[arg]));
    }

    return 0;
}

//
// given a string of binary digits ('1' and '0')
// return the corresponding signed 16 bit integer
//
int16_t sixteen_in(char *bits) {

    int16_t result = 0;
    int length = strlen(bits);

    assert(length <= N_BITS);

    for (int i = 0; i < length; i++) {
        result = result << 1; // Shift left to make room for the next bit
        if (bits[i] == '1') {
            result |= 1; // Set the last bit to 1 if the current character is '1'
        }
    }

    return result;
}

