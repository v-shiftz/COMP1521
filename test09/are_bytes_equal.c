#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *first_file = fopen(argv[1], "r");
    int pos1 = atoi(argv[2]);
    FILE *second_file = fopen(argv[3], "r");
    int pos2 = atoi(argv[4]);
    int c1;
    int c2;
    fseek(first_file, pos1, SEEK_SET);
    c1 = fgetc(first_file);
    fseek(second_file, pos2, SEEK_SET);
    c2 = fgetc(second_file);
    if (c1 == EOF && c2 == EOF){
        printf("byte %d in %s and byte %d in %s are not the same\n", pos1, argv[1], pos2, argv[3]);
    } else if (c1 == c2) {
        printf("byte %d in %s and byte %d in %s are the same\n", pos1, argv[1], pos2, argv[3]);
    } else {
        printf("byte %d in %s and byte %d in %s are not the same\n", pos1, argv[1], pos2, argv[3]);
    }
    fclose(first_file);
    fclose(second_file);
    return 0;
}