#include <stdio.h>
#include <string.h>

int main(void) {
	char input[1024];
	while (fgets(input, sizeof(input), stdin)) {
        if (strlen(input) % 2 == 0) {
            fputs(input, stdout);
        }
	}
	return 0;
}
