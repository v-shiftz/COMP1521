#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int count_zero_bits(uint32_t x) {
	return __builtin_popcount(~x);
}