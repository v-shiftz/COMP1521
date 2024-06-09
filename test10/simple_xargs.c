#include <stdio.h>
#include <stdlib.h>
#include <spawn.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <string.h>

extern char **environ;

int main(int argc, char *argv[]) {
    char *command = argv[1];
    char input[1024];

    while (fgets(input, sizeof(input), stdin)) {
        // Remove newline character from fgets input
        size_t len = strlen(input);
        if (input[len - 1] == '\n') {
            input[len - 1] = '\0';
        }
        char *args[] = {command, input, NULL};

        pid_t pid;
        int status;

        if (posix_spawn(&pid, command, NULL, NULL, args, environ) != 0) {
            perror("posix_spawn failed");
            continue;
        }

        waitpid(pid, &status, 0);
    }

    return 0;
}
