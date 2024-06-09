#include <stdio.h>
#include <stdlib.h>

void collatz(int current_num){

	if (current_num == 1){
		printf("%d\n", current_num);
        return;
	}

	printf("%d\n", current_num);

	if (current_num % 2 == 0){
		collatz(current_num/2);
	}else{
		collatz(current_num*3+1);
	}
}


int main(int argc, char *argv[])
{
	int number = atoi(argv[1]);
	collatz(number);
	return EXIT_SUCCESS;
}

