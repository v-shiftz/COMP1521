////////////////////////////////////////////////////////////////////////
// COMP1521 24T1 --- Assignment 2: `space', a simple file archiver
// <https://www.cse.unsw.edu.au/~cs1521/24T1/assignments/ass2/index.html>
//
// Written by Zhang Jingyuan (z5408280) on 06-04-2024.
//
// 2024-03-08   v1.1    Team COMP1521 <cs1521 at cse.unsw.edu.au>

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include "space.h"


// ADD ANY extra #defines HERE

#include <string.h>
#include <libgen.h>
#include <math.h>

// ADD YOUR FUNCTION PROTOTYPES (AND STRUCTS IF ANY) HERE

// Subset 0
void list_galaxy(char *galaxy_pathname, int long_listing);

// Subset 1
void check_galaxy(char *galaxy_pathname);

// Subset 1 & 3
unsigned char *decode_7bit(const unsigned char *input, uint64_t input_len, 
														size_t *decoded_len);
unsigned char *decode_6bit(const unsigned char *input, uint64_t input_len, 
														size_t *decoded_len);
void extract_galaxy(char *galaxy_pathname);

// Subset 2 & 3
void write_star_to_galaxy(FILE *galaxy_fd, const char *pathname, int format);
int is_directory(const char *path);
void process_file(FILE *galaxy_fd, const char *file_path, int format);
void recursive_directory(FILE *galaxy_fd, const char *path, int format, 
															int root_level);
// print the files & directories stored in galaxy_pathname (subset 0)
//
// if long_listing is non-zero then file/directory permissions, formats & sizes
// are also printed (subset 0)

void list_galaxy(char *galaxy_pathname, int long_listing) {
    
    FILE *fd = fopen(galaxy_pathname, "r");
    if (fd == NULL) {
        perror(galaxy_pathname);
        return;
    }
    while (1) {
        uint8_t magic_number, star_format;
        char permissions[11] = {0};
        uint16_t pathname_len = 0;
        uint64_t cont_len = 0;

        // Read magic number and star format
        if (fread(&magic_number, 1, 1, fd) < 1) {
            break;
        }
        if (magic_number != 0x63) {
            perror(galaxy_pathname);
            exit(1);
        }
        if (fread(&star_format, 1, 1, fd) < 1) {
            break;
        }
        if (star_format != 0x38 && star_format != 0x37 && star_format != 0x36) {
			perror(galaxy_pathname);
            exit(1);
        }

        // Read permissions
        if (fread(permissions, 10, 1, fd) < 1 ) {
            perror(galaxy_pathname);
            exit(1);
        }

        // Read pathname length
		for (int i = 0; i < 2; i++) {
            uint8_t part;
            if (fread(&part, 1, 1, fd) < 1) {
                perror(galaxy_pathname);
                exit(1);
            }
            pathname_len |= ((uint64_t) part << (i * 8));
        }

        // Read pathname
        char pathname[pathname_len + 1];
        if (fread(pathname, pathname_len, 1, fd) < 1) {
            break;
        }
        pathname[pathname_len] = '\0';
        for (int i = 0; i < 6; i++) {
            uint8_t part;
            if (fread(&part, 1, 1, fd) < 1) {
                break;
            }
            cont_len |= ((uint64_t) part << (i * 8));
        }
		uint64_t adjusted_len;
        if (star_format == 0x38) {
            adjusted_len = cont_len;
        } else if (star_format == 0x37) {
            adjusted_len = ceil((7.0 / 8) * cont_len);
        } else { 
            adjusted_len = ceil((6.0 / 8) * cont_len);
        }

        // Skip content and hash
        fseek(fd, adjusted_len + 1, SEEK_CUR);

        if (long_listing) {
            printf("%s %2d %6lu  %s\n", permissions, star_format - '0', 
				cont_len, pathname);
        } else {
            printf("%s\n", pathname);
        }
    }
    fclose(fd);
}



// check the files & directories stored in galaxy_pathname (subset 1)
//
// prints the files & directories stored in galaxy_pathname with a message
// either, indicating the hash byte is correct, or indicating the hash byte
// is incorrect, what the incorrect value is and the correct value would be

void check_galaxy(char *galaxy_pathname) {

    FILE *fd = fopen(galaxy_pathname, "r");
    if (fd == NULL) {
        perror(galaxy_pathname);
        return;
    }
    while (1) {
        uint8_t magic_number, byte;
        uint8_t calculated_hash = 0x00;
        uint16_t pathname_length = 0;
        uint64_t content_length = 0;

        // Read and check magic number
        fread(&magic_number, 1, 1, fd);
        if (magic_number != 0x63) {
            fprintf(stderr, "error: incorrect first star byte: 0x%X" 
                " should be 0x63\n", magic_number);
            break;
        }
        calculated_hash = galaxy_hash(calculated_hash, magic_number);
        // Read next 11 bytes for star format and permissions, updating hash
        for (int i = 0; i < 11; i++) {
            fread(&byte, 1, 1, fd);
            calculated_hash = galaxy_hash(calculated_hash, byte);
        }
        // Read pathname length
        for (int i = 0; i < 2; i++) {
            if (fread(&byte, 1, 1, fd) < 1) {
                break;
            }
            pathname_length |= ((uint64_t) byte << (i * 8));
            calculated_hash = galaxy_hash(calculated_hash, byte);
        }
        // Read pathname
        char pathname[pathname_length + 1];
        if (fread(pathname, pathname_length, 1, fd) < 1) {
            break;
        }
        pathname[pathname_length] = '\0';
        // Iterate through length of pathname and add to hash
        for (int i = 0; i < pathname_length; i++) {
            calculated_hash = galaxy_hash(calculated_hash, pathname[i]);
        }

        // Read content length and update hash accordingly
        for (int i = 0; i < 6; i++) {
            if (fread(&byte, 1, 1, fd) < 1) {
                perror(galaxy_pathname);
                exit(1);
            }
            content_length |= ((uint64_t) byte << (i * 8));
            calculated_hash = galaxy_hash(calculated_hash, byte);
        }

        // Read content based on content length and update hash
        for (uint64_t i = 0; i < content_length; i++) {
            if (fread(&byte, 1, 1, fd) < 1) {
                break;
            }
            calculated_hash = galaxy_hash(calculated_hash, byte);
        }
        // Finally, read and compare the expected hash
        uint8_t expected_hash;
        if (fread(&expected_hash, 1, 1, fd) < 1) {
            break;
        }
        // Report the result
        if (expected_hash == calculated_hash) {
            printf("%s - correct hash\n", pathname);
        } else {
            printf("%s - incorrect hash 0x%x should be 0x%x\n", pathname, 
			calculated_hash, expected_hash);
        }
    }

    fclose(fd);
}

// extract the files/directories stored in galaxy_pathname (subset 1 & 3)

// Helper function to decode 7bit to 8bit but doenst work
unsigned char *decode_7bit(const unsigned char *input, uint64_t input_len, 
														size_t *decoded_len) {
    *decoded_len = (input_len * 7 + 8) / 8;

    unsigned char *output = malloc(*decoded_len);
    if (!output) {
        perror("Failed to allocate memory for 7-bit decoding");
        return NULL;
    }
	// why is this not working T^T
    uint64_t input_index = 0, output_index = 0;
    int bits_collected = 0;
    uint32_t buffer = 0;

    while (input_index < input_len) {
        buffer = (buffer << 7) | (input[input_index++] & 0x7F);
        bits_collected += 7;

        while (bits_collected >= 8) {
            bits_collected -= 8;
            unsigned char decoded_byte = (buffer >> bits_collected) & 0xFF;
            output[output_index++] = decoded_byte;
        }
    }

    return output;
}

// Helper function to decode 6_bit file using function from space_6_bit.c
unsigned char *decode_6bit(const unsigned char *input, uint64_t input_len, 
														size_t *decoded_len) {
    *decoded_len = ((input_len * 6 + 7) / 8);

    unsigned char *output = malloc(*decoded_len);
    if (!output) {
        perror("Failed to allocate memory for 6-bit decoding");
        return NULL;
    }

    uint64_t input_index = 0, output_index = 0;
    int bits_collected = 0;
    uint32_t buffer = 0;

    while (input_index < input_len) {
        buffer = (buffer << 8) | input[input_index++];
        bits_collected += 8;

        while (bits_collected >= 6) {
            int six_bit_value = (buffer >> (bits_collected - 6)) & 0x3F;
            bits_collected -= 6;

            int decoded_byte = galaxy_from_6_bit(six_bit_value);
            if (decoded_byte == -1) {
                free(output);
                fprintf(stderr, "Invalid 6-bit value encountered\n");
                return NULL;
            }

            if (output_index < *decoded_len) {
                output[output_index++] = decoded_byte;
            }
        }
    }

    return output;
}

// Main Function to extract files
void extract_galaxy(char *galaxy_pathname) {
    FILE *input = fopen(galaxy_pathname, "r");
    if (input == NULL) {
        perror(galaxy_pathname);
        exit(1);
    }
    while (1) {
        uint8_t magic_number, byte, star_format;
        char permissions[11] = {0};
        uint16_t pathname_length = 0;
        uint64_t content_length = 0;
        // Read and check magic number
        if (fread(&magic_number, 1, 1, input) < 1) {
            break;
        }
        if (magic_number != 0x63) {
            fprintf(stderr, "error: incorrect first star byte: 0x%X" 
                " should be 0x63\n", magic_number);
            exit(1);
        }
        if (fread(&star_format, 1, 1, input) < 1 ) {
			perror(galaxy_pathname);
			exit(1);
        }
        if (fread(permissions, 1, 10, input) < 1) {
            perror(galaxy_pathname);
			exit(1);
        }
        // Read pathname length
        for (int i = 0; i < 2; i++) {
            if (fread(&byte, 1, 1, input) < 1) {
                perror(galaxy_pathname);
				exit(1);
            }
            pathname_length |= ((uint64_t) byte << (i * 8));
        }
        // Read pathname
        char pathname[pathname_length + 1];
        if (fread(pathname, pathname_length, 1, input) < 1) {
            perror(galaxy_pathname);
			exit(1);
        }
        pathname[pathname_length] = '\0';
        // Read content length and update hash accordingly
        for (int i = 0; i < 6; i++) {
            if (fread(&byte, 1, 1, input) < 1) {
                perror(galaxy_pathname);
				exit(1);
            }
            content_length |= ((uint64_t) byte << (i * 8));
        }
        mode_t mode = 0;
        if (permissions[0] == 'd') {
            mode = S_IRWXU | S_IRWXG | S_IRWXO;
            if (mkdir(pathname, mode) != 0) {
                perror(pathname);
				exit(1);
            }
            printf("Creating directory: %s\n", pathname);
            for (uint64_t i = 0; i < content_length; i++) {
                fread(&byte, 1, 1, input);
            }
            fread(&byte, 1, 1, input);
            continue;
        } else {
            FILE *output = fopen(pathname, "w");
            printf("Extracting: %s\n", pathname);
			uint64_t adjusted_len;
			adjusted_len = content_length; // For star_format 8
			if (star_format == 0x37) {
				adjusted_len = ceil((7.0 / 8) * content_length);
			} else if (star_format == 0x36) { 
				adjusted_len = ceil((6.0 / 8) * content_length);
			}
			unsigned char *encoded_content = malloc(adjusted_len);
			if (encoded_content == NULL) {
				fclose(output);
				exit(1);
			}
            for (uint64_t i = 0; i < adjusted_len; i++) {
                if (fread(&encoded_content[i], 1, 1, input) < 1) {
					perror(galaxy_pathname);
					exit(1);
				}
            }
			// 8-bit format, no decoding needed
			if (star_format == 0x38) { 
				fwrite(encoded_content, 1, adjusted_len, output);
			} else {
				size_t decoded_len = 0;
				unsigned char *decoded_content = NULL;

				if (star_format == 0x37) {
					// Decode 7-bit content
					decoded_content = decode_7bit (encoded_content, 
					content_length, &decoded_len);
				} else if (star_format == 0x36) {
					// Decode 6-bit content
					decoded_content = decode_6bit (encoded_content, 
					content_length, &decoded_len);
				}
                
				if (decoded_content != NULL) {
					// Write decoded content to file
					fwrite (decoded_content, 1, decoded_len, output);
					free (decoded_content);
				}
			}
			free (encoded_content);
            fclose (output);
            if (permissions[1] == 'r') mode |= S_IRUSR;
            if (permissions[2] == 'w') mode |= S_IWUSR;
            if (permissions[3] == 'x') mode |= S_IXUSR;
            if (permissions[4] == 'r') mode |= S_IRGRP;
            if (permissions[5] == 'w') mode |= S_IWGRP;
            if (permissions[6] == 'x') mode |= S_IXGRP;
            if (permissions[7] == 'r') mode |= S_IROTH;
            if (permissions[8] == 'w') mode |= S_IWOTH;
            if (permissions[9] == 'x') mode |= S_IXOTH;
            chmod(pathname, mode);
            // Skip hash (1 byte)
            fread(&byte, 1, 1, input);
        }
    }
    fclose(input);
}


// create galaxy_pathname containing the files or directories specified in
// pathnames (subset 2 & 3)
//
// if append is zero galaxy_pathname should be over-written if it exists
// if append is non-zero galaxys should be instead appended to galaxy_pathname
//                       if it exists
//
// format specifies the galaxy format to use, it must be one STAR_FMT_6,
// STAR_FMT_7 or STAR_FMT_8

// Helper function to write file contents into galaxy
void write_star_to_galaxy(FILE *galaxy_fd, const char *pathname, int format){
    uint8_t calculated_hash = 0x00;
    struct stat file_stat;
    if (stat(pathname, &file_stat) != 0) {
        perror(pathname);
        exit(1);
    }
    // Put magic number
    fputc(0x63, galaxy_fd);
    calculated_hash = galaxy_hash(calculated_hash, 0x63);

    // Put star format
    fputc(format, galaxy_fd);
    calculated_hash = galaxy_hash(calculated_hash, format);
    
    // Write permissions
    char permissions[11];
    permissions[0] = (S_ISDIR(file_stat.st_mode)) ? 'd' : '-';
    permissions[1] = (file_stat.st_mode & S_IRUSR) ? 'r' : '-';
    permissions[2] = (file_stat.st_mode & S_IWUSR) ? 'w' : '-';
    permissions[3] = (file_stat.st_mode & S_IXUSR) ? 'x' : '-';
    permissions[4] = (file_stat.st_mode & S_IRGRP) ? 'r' : '-';
    permissions[5] = (file_stat.st_mode & S_IWGRP) ? 'w' : '-';
    permissions[6] = (file_stat.st_mode & S_IXGRP) ? 'x' : '-';
    permissions[7] = (file_stat.st_mode & S_IROTH) ? 'r' : '-';
    permissions[8] = (file_stat.st_mode & S_IWOTH) ? 'w' : '-';
    permissions[9] = (file_stat.st_mode & S_IXOTH) ? 'x' : '-';
    permissions[10] = '\0';
    fwrite(permissions, sizeof(char), 10, galaxy_fd);
    for (int i = 0; i < 10; i ++) {
        calculated_hash = galaxy_hash(calculated_hash, permissions[i]);
    }

    // Write pathname_length
    uint16_t pathname_len = strlen(pathname);
    for (int i = 0; i < 2; i++) {
        uint8_t part = (pathname_len >> (i * 8)) & 0xFF;
        fwrite(&part, sizeof(part), 1, galaxy_fd);
        calculated_hash = galaxy_hash(calculated_hash, part);
    }
    
    // Write pathname
    fputs(pathname, galaxy_fd);

    for (int i = 0; i < pathname_len; i++) {
        calculated_hash = galaxy_hash(calculated_hash, pathname[i]);
    }

    // Write content length
    FILE *file_fd = fopen(pathname, "r");
    if (file_fd == NULL) {
        perror("file_fd");
        exit(1);
    }
    int c;
    uint64_t cont_len = 0;
    while ((c = fgetc(file_fd)) != EOF) {
        cont_len++;
    }
    
    rewind(file_fd);

    for (int i = 0; i < 6; i++) {
        uint8_t part = (cont_len >> (i * 8)) & 0xFF;
        fwrite(&part, sizeof(part), 1, galaxy_fd);
        calculated_hash = galaxy_hash(calculated_hash, part);
    }
    while ((c=fgetc(file_fd)) != EOF) {
        fputc(c, galaxy_fd);
        calculated_hash = galaxy_hash(calculated_hash, c);
    }

    fclose (file_fd);

    fwrite (&calculated_hash, sizeof(calculated_hash), 1, galaxy_fd);
}

// Helper function to check if path is directory
int is_directory(const char *path) {
    struct stat path_stat;
    if (stat(path, &path_stat) != 0) {
        return 0;
    }
    return S_ISDIR(path_stat.st_mode);
}

// Helper function for printing statements and write_star_to_galaxy
void process_file(FILE *galaxy_fd, const char *file_path, int format) {
    printf("Adding: %s\n", file_path);
    write_star_to_galaxy(galaxy_fd, file_path, format);
}

// Helper function for create_galaxy
char *get_parent_directory(const char *path) {
    char *path_copy = strdup(path);
    char *dir = dirname(path_copy);
    char *result = strdup(dir);
    free(path_copy);
    return result;
}

// Helper function to recurse through directory and add files
void recursive_directory(FILE *galaxy_fd, const char *path, int format, 
														int root_level) {
    if (root_level) {
        printf("Adding: %s\n", path);
        write_star_to_galaxy(galaxy_fd, path, format);
    }

    if (is_directory(path)) {
        DIR *dir = opendir(path);
        if (!dir) {
            perror("Failed to open directory");
            exit(1);
        }

        struct dirent *entry;
        while ((entry = readdir(dir)) != NULL) {
            if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
				continue;
			}
            char *full_entry_path = malloc(strlen(path) + strlen(entry->d_name) + 2);
            sprintf(full_entry_path, "%s/%s", path, entry->d_name);
            
            if (is_directory(full_entry_path)) {
                printf("Adding: %s\n", full_entry_path);
                write_star_to_galaxy(galaxy_fd, full_entry_path, format);
                recursive_directory(galaxy_fd, full_entry_path, format, 0);
            } else {
                process_file(galaxy_fd, full_entry_path, format);
            }
            free(full_entry_path);
        }
        closedir(dir);
    }
}

// Main function to create a new galaxy file
void create_galaxy(char *galaxy_pathname, int append, int format,
                   int n_pathnames, char *pathnames[n_pathnames]) {
    
    const char *mode;
    if (append) {
        mode = "a";
    } else {
        mode = "w";
    }

    FILE *galaxy_fd = fopen(galaxy_pathname, mode);
    if (galaxy_fd == NULL) {
        perror(galaxy_pathname);
        return;
    }
    for (int i = 0; i < n_pathnames; i++) {
        if (is_directory(pathnames[i])) {
            // Directly process the directory
            recursive_directory(galaxy_fd, pathnames[i], format, 1);
        } else {
            // Check if the file is in a directory if not still process
            // with the original pathname
            char *parent_dir = get_parent_directory(pathnames[i]);
            if (strcmp(parent_dir, ".") != 0) {
                recursive_directory(galaxy_fd, parent_dir, format, 1);
            } else {
				recursive_directory(galaxy_fd, pathnames[i], format, 1);
			}
            free(parent_dir);
        }
    }
    fclose(galaxy_fd);
}


// ADD YOUR EXTRA FUNCTIONS HERE
