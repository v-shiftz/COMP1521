// Given an UTF-8 string, return the index of the first invalid byte.
// If there are no invalid bytes, return -1.
#include <stdio.h>
#include <ctype.h>
#include <string.h>
// Do NOT change this function's return type or signature.

int utf8_sequence_length(unsigned char c) {
    if ((c & 0b11111000) == 0b11110000) return 4;
    if ((c & 0b11110000) == 0b11100000) return 3;
    if ((c & 0b11100000) == 0b11000000) return 2;
    if ((c & 0b10000000) == 0b00000000) return 1;
    return 0;
}

int invalid_utf8_byte(char *utf8_string) {
    int i = 0;
    unsigned char c;

    while ((c = utf8_string[i]) != '\0') {
        int len = utf8_sequence_length(c);

        if (len == 0) {
            return i;
        } else {
            for (int j = 1; j < len; ++j) {
                if (utf8_string[i + j] == '\0' || (utf8_string[i + j] & 0xC0) != 0x80) {
                    return i + j;
                }
            }

            i += len - 1;
        }

        i++;
    }

    return -1;
}