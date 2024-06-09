// // // // // // // // DO NOT CHANGE THIS FILE! // // // // // // // //
// COMP1521 22T3 ... final exam, question 9
// This header file contains some functions you may find useful.

#ifndef _22t3final_q9_H
#define _22t3final_q9_H

// You must call this function from every thread you create.
void compute_thread_hello(void);

// Evaluate the given expression from left to right, ignoring order of
// operations.
double evaluate_expression(char *expression);

// Checks if two doubles are equal, within a small epsilon to account for
// floating point errors.
double double_equals(double a, double b);


#endif // _22t3final_q9_H
