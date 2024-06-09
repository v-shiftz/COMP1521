#include <stdio.h>
#include <ctype.h>

int main(void) {
	char input;

	while ((input = getchar())!= EOF){
		putchar(tolower(input));
	}
	return 0;
}
