#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <inttypes.h>
#include <ctype.h>

// Helper function to read little-endian integers from the file
uint64_t read_integer(FILE *fd, int bytes) {
    uint64_t result = 0;
    for (int i = 0; i < bytes; i++) {
        int byte = fgetc(fd);
        if (byte == EOF) {
            fprintf(stderr, "Failed to read record\n");
            exit(1);
        }
        result |= ((uint64_t)byte << (i * 8));
    }
    return result;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    FILE *fd = fopen(argv[1], "rb");
    if (!fd) {
        perror("Error opening file");
        return 1;
    }

    // Check magic number
    char magic[4] = {0}; // Initialise all to 0 so there is a null terminator.
    if (fread(magic, 1, 3, fd) != 3 || magic[0] != 'L' || magic[1] != 'I' || magic[2] != 'T') {
        fprintf(stderr, "Failed to read magic\n");
        fclose(fd);
        return 1;
    }

    // Read records
    while (1) {
        int num_bytes_char = fgetc(fd);
        if (num_bytes_char == EOF){
            break;
        }

        if (num_bytes_char < '1' || num_bytes_char > '8') {
            fprintf(stderr, "Invalid record length\n");
            fclose(fd);
            return 1;
        }

        int num_bytes = num_bytes_char - '0';
        uint64_t value = read_integer(fd, num_bytes);
        printf("%lu\n", value);
    }

    fclose(fd);
    return 0;
}
