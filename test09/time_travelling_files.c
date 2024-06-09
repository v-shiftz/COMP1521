#include <stdio.h>
#include <sys/stat.h>
#include <time.h>

int main(int argc, char *argv[]) {
    struct stat file_stat;
    time_t now = time(NULL); // Get current time

    for (int i = 0; i < argc; i++) {
        if (stat(argv[i], &file_stat) == 0) { // Get file statistics
            // Check if access time or modification time is in the future
            if (file_stat.st_atime > now || file_stat.st_mtime > now) {
                printf("%s has a timestamp that is in the future\n", argv[i]);
            }
        }
    }

    return 0;
}
