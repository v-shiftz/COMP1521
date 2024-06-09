#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	int min = atoi(argv[1]);
	int max = min;
	int sum = 0;
	int prod = 1;
	double mean = 0;
	for (int i = 1; i < argc; i++) {
		int value = atoi(argv[i]);
		if (value < min){
			min = value;
		}
		if (value > max){
			max = value;
		}
		sum += value;
		prod *= value;
	}
	mean = (double)sum/(argc-1);
	printf("MIN:  %d\n", min);
	printf("MAX:  %d\n", max);
	printf("SUM:  %d\n", sum);
	printf("PROD: %d\n", prod);
	printf("MEAN: %d\n", (int)mean);
	return 0;
}
