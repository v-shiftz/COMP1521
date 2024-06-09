// // // // // // // // DO NOT CHANGE THIS FILE! // // // // // // // //
// COMP1521 22T3 ... final exam, question 9
// This file is provided to ensure that your program creates the
// correct number of threads.
// You do not need to understand the code in this file.

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <pthread.h>

#define NUM_THREADS_REQUIRED 5
#define EPSILON              0.0001

pthread_t computation_threads[NUM_THREADS_REQUIRED];
pthread_mutex_t compute_thread_mutex = PTHREAD_MUTEX_INITIALIZER;

#ifdef main
#undef main
#endif

int my_main(int argc, char *argv[]);

int main(int argc, char *argv[]) {
    my_main(argc, argv);

    for (int i = 0; i < NUM_THREADS_REQUIRED; i++) {
        if (!computation_threads[i]) {
            fprintf(stderr, "ERROR: Your program must split the workload across %d threads!\n", NUM_THREADS_REQUIRED);
            fprintf(stderr, "       You only created %d threads which called compute_thread_hello.\n", i);
            fprintf(stderr, "       The program will now exit.\n");
            exit(EXIT_FAILURE);
        }
    }

    printf("Your program created enough threads!\n");
}

void compute_thread_hello(void) {
    pthread_t self = pthread_self();
    pthread_mutex_lock(&compute_thread_mutex);
    for (int i = 0; i < NUM_THREADS_REQUIRED; i++) {

        if (!computation_threads[i]) {
            computation_threads[i] = self;
            printf("Hello from compute thread %d!\n", i);
            pthread_mutex_unlock(&compute_thread_mutex);
            return;
        }

        if (pthread_equal(self, computation_threads[i])) {
            printf("ERROR: Computation thread %d already created!\n", i);
            printf("       The program will now exit.\n");
            exit(EXIT_FAILURE);
        }
    }

    printf("ERROR: Too many computation threads created!\n");
    printf("       The program will now exit.\n");
    exit(EXIT_FAILURE);
}

double evaluate_expression(char *expression) {
    if (strlen(expression) == 0 || expression[0] == '\n') {
        return 0;
    }

    double result = expression[0] - '0';
    for (int i = 1; i < strlen(expression); i += 2) {
        switch (expression[i]) {
            case '+':
                result += expression[i + 1] - '0';
                break;
            case '-':
                result -= expression[i + 1] - '0';
                break;
            case '*':
                result *= expression[i + 1] - '0';
                break;
            case '/':
                result /= (double)(expression[i + 1] - '0');
                break;
        }
    }

    return result;
}

double double_equals(double a, double b) {
    return fabs(a - b) < EPSILON;
}
