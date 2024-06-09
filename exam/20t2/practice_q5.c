#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char *argv[]) {
    char *first = getenv(argv[1]);
    char *second = getenv(argv[2]);
    if (first != NULL && second != NULL && strcmp(first, second)==0) {
        printf("1\n");
    } else {
        printf("0\n");
    }
    return 0;
}