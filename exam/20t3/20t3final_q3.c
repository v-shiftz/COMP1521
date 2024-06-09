// COMP1521 20T3 final exam Q2 starter code

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    char *value1 = getenv(argv[1]);
    char *value2 = getenv(argv[2]);
    int first_val;
    if (value1 == NULL) {
        first_val = 42;
    } else {
        first_val = atoi(value1);
    }
    int second_val;
    if (value2 == NULL) {
        second_val = 42;
    } else {
        second_val = atoi(value2);
    }
    int difference = first_val - second_val;
    if (difference > -10 && difference < 10) {
        printf("1\n");
        
    } else {
        printf("0\n");
    }
    return 0;
}
