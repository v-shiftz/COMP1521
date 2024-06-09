#include <stdio.h>

int main(void) {
	char input;
	
	while (scanf("%c", &input) == 1) {
		if (input != 'a' && input != 'A' && input != 'e' && input != 'E' && input != 'i' && input != 'I' && input != 'o' && input != 'O' && input != 'u' && input != 'U' ){
			printf("%c", input);
		}
	}

	return 0;
}
