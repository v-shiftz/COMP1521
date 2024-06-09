// // // // // // // // DO NOT CHANGE THIS FILE! // // // // // // // //
// COMP1521 22T3 ... final exam, question 4

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int _22t3final_q4(uint32_t x);

#ifdef main
#undef main
#endif

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <number>\n", argv[0]);
        return EXIT_FAILURE;
    }

    uint32_t input = strtoul(argv[1], NULL, 0);

    int longest_sequence_of_one_bits = _22t3final_q4(input);
    printf("%d\n", longest_sequence_of_one_bits);

    return EXIT_SUCCESS;
}
