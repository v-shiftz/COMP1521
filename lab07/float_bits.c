// Extract the 3 parts of a float using bit operations only

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// separate out the 3 components of a float
float_components_t float_bits(uint32_t f) {
    float_components_t components;
    components.sign = (f >> 31) & 0b1;
    components.exponent = (f >> 23) & 0xff;
    components.fraction = f & 0x7FFFFF;
    return components;   
    // PUT YOUR CODE HERE
}

// given the 3 components of a float
// return 1 if it is NaN, 0 otherwise
int is_nan(float_components_t f) {
    if(f.exponent == 0xFF && f.fraction!=0){
        return 1;
    }else{
        return 0;
    }
    // PUT YOUR CODE HERE
    
}

// given the 3 components of a float
// return 1 if it is inf, 0 otherwise
int is_positive_infinity(float_components_t f) {
    if (f.sign == 0 && f.exponent == 0xFF && f.fraction==0){
        return 1;
    }else{
        return 0;
    }
}

// given the 3 components of a float
// return 1 if it is -inf, 0 otherwise
int is_negative_infinity(float_components_t f) {
    // PUT YOUR CODE HERE
    if (f.sign == 1 && f.exponent == 0xFF && f.fraction==0){
        return 1;
    }else{
        return 0;
    }
}

// given the 3 components of a float
// return 1 if it is 0 or -0, 0 otherwise
int is_zero(float_components_t f) {
    // PUT YOUR CODE HERE
    if (f.exponent == 0 && f.fraction == 0){
        return 1;
    }else{
        return 0;
    }
}
