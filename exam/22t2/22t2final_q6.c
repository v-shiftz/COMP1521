#include <string.h>
#include <stdlib.h>

/**
 * given a `UTF-8` encoded string,
 * return a new string that is only
 * the characters within the provided range.
 *
 * Note:
 * `range_start` is INCLUSIVE
 * `range_end`   is EXCLUSIVE
 *
 * eg:
 * "hello world", 0, 5
 * would return "hello"
 *
 * "🍓🍇🍈🍍🍐", 2, 5
 * would return "🍈🍍🍐"
**/

int utf8_sequence_length(char *string) {
    if ((*string & 0b11111000) == 0b11110000) return 4;
    if ((*string & 0b11110000) == 0b11100000) return 3;
    if ((*string & 0b11100000) == 0b11000000) return 2;
    if ((*string & 0b10000000) == 0b00000000) return 1;
    return 0;
}

char *_22t2final_q6(char *utf8_string, unsigned int range_start, unsigned int range_end) {
	char *new_string = calloc(strlen(utf8_string) + 1, sizeof (char));

	size_t ch = 0;
	for (size_t i = 0; utf8_string[i] && ch < range_end;) {
		int size = utf8_sequence_length(utf8_string + i);
		if (ch >= range_start) {
			memcpy(&new_string[strlen(new_string)], &utf8_string[i], size);
		}

		ch++;
		i += size;
	}

	return new_string;
}
