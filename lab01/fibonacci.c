#include <stdio.h>
#include <stdlib.h>

#define SERIES_MAX 30

int fibonacci(int input){
    if (input == 0){
        return 0;
    }else if (input == 1){
        return 1;
    }else{
        return fibonacci(input - 1) + fibonacci (input - 2);
    }
}

int main(void) {
    int input;
    while(scanf("%d", &input) == 1){
        if (input > SERIES_MAX){
            break;
        }else{
            printf("%d\n",fibonacci(input));
        }
    }
    return EXIT_SUCCESS;
}
