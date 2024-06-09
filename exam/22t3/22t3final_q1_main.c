// // // // // // // // DO NOT CHANGE THIS FILE! // // // // // // // //
// COMP1521 22T3 ... final exam, question 1

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

uint32_t _22t3final_q1(uint32_t x);

#ifdef main
#undef main
#endif

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <number>\n", argv[0]);
        return EXIT_FAILURE;
    }

    uint32_t input = strtoul(argv[1], NULL, 0);

    uint32_t middle_bits = _22t3final_q1(input);
    printf("%u\n", middle_bits);

    return EXIT_SUCCESS;
}
