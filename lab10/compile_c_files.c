// compile .c files specified as command line arguments
//
// if my_program.c and other_program.c is speicified as an argument then the follow two command will be executed:
// /usr/local/bin/dcc my_program.c -o my_program
// /usr/local/bin/dcc other_program.c -o other_program

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <spawn.h>
#include <sys/types.h>
#include <sys/wait.h>

#define DCC_PATH "/usr/local/bin/dcc"

extern char **environ;

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "Usage: %s file1.c file2.c ...\n", argv[0]);
        return EXIT_FAILURE;
    }

    pid_t pid;
    int status;

    for (int i = 1; i < argc; i++) {
        char *sourceFile = argv[i];
        // Check if the file has a .c extension
        if (strlen(sourceFile) > 2 && strcmp(sourceFile + strlen(sourceFile) - 2, ".c") == 0) {
            // Construct output file name by stripping ".c"
            char outputFile[256];
            strncpy(outputFile, sourceFile, strlen(sourceFile) - 2);
            outputFile[strlen(sourceFile) - 2] = '\0';

            // Prepare arguments for the dcc compiler
            char *dccArgs[] = {DCC_PATH, sourceFile, "-o", outputFile, NULL};

            // Print the command that will be executed
            printf("running the command: \"%s %s -o %s\"\n", DCC_PATH, sourceFile, outputFile);

            // Spawn the compiler process
            if (posix_spawn(&pid, DCC_PATH, NULL, NULL, dccArgs, environ) != 0) {
                perror("Failed to spawn compiler");
                continue;
            }
        } else {
            fprintf(stderr, "Error: Invalid file extension for %s. Only .c files are accepted.\n", sourceFile);
        }
    }

    return EXIT_SUCCESS;
}
