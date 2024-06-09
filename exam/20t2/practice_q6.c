#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    int c;
    int count = 0;
    FILE *fd = fopen(argv[1], "r");
    while ((c =fgetc(fd)) != EOF) {
        if (isascii(c)) {
            count++;
        }
    }
    printf("%s contains %d ASCII bytes\n", argv[1], count);
}