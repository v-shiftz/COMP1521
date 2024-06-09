#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

int main (int argc, char *argv[]) {
    int remove = atoi(argv[1]);
    FILE *old = fopen(argv[2], "r");
    FILE *new = fopen(argv[3], "w");
    int c;
    int count = 0;
    while((c = fgetc(old)) != EOF) {
        count++;
    }
    rewind(old);
    int diff = count - remove;
    for (int i = 0; i < diff; i++) {
        c = fgetc(old);

        fputc(c, new);
    }
    return 0;
}