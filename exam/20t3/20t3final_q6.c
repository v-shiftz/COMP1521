#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    int c;
    int bit_counter = 0;
    FILE *fd = fopen(argv[1], "r");
    while ((c = fgetc(fd)) != EOF) {
        bit_counter += __builtin_popcount(c & 0b11111111);
    }
    printf("%s has %d bits set\n", argv[1], bit_counter);
}