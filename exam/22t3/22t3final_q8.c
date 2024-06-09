// // // // // // // // DO NOT CHANGE THIS FILE! // // // // // // // //
// COMP1521 22T3 ... final exam, question 8
// Modify 22t3final_q8.s so that its behaviour
// matches the following C code.


#include <stdio.h>

char *s;

int expression(void);
int term(void);
int value(void);

int main(void) {
    char buffer[10000];
    fgets(buffer, 10000, stdin);
    s = buffer;

    if (expression()) {
        printf("T\n");
    } else {
        printf("F\n");
    }

    return 0;
}

int expression(void) {
    int lhs = term();
    if (*s != '|') {
        return lhs;
    }
    s++;
    int rhs = expression();
    return lhs || rhs;
}

int term(void) {
    int lhs = value();
    if (*s != '&') {
        return lhs;
    }
    s++;
    int rhs = term();
    return lhs && rhs;
}

int value(void) {
    int retval = *s == 'T';
    s++;
    return retval;
}
