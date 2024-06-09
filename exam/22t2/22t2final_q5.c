// COMP1521 22T2 ... final exam, question 5

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void print_bytes(FILE *file, long n) {
	int positive = 1;
	if (n < 0) {
		positive = 0;
		n = labs(n);
	} else {
		positive = 1;
	}
	int c;
	if (positive == 1) {
		for (int i = 0; i < n; i++) {
			c = fgetc(file);
			if (c == EOF) {
				break;
			}
			putchar(c);
		}
	} else {
		int count = 0;
		while ((c = fgetc(file))!=EOF) {
			count++;
		}
		count = count - n;
		rewind(file);
		for (int i = 0; i < count; i++){
			c = fgetc(file);
			if (c == EOF) {
				exit(1);
			}
			putchar(c);
		}
	}
}
