#include <stdio.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <strings.h>

int main(int argc, char *argv[]) {
    struct stat st;
    
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <filename> <filename> ...\n", argv[0]);
        exit(1);
    }

    for (int i = 1; i < argc; i++) {
        if (stat(argv[i], &st) == 0) {
            printf((S_ISDIR(st.st_mode)) ? "d" : "-");
            printf((st.st_mode & S_IRUSR) ? "r" : "-");
            printf((st.st_mode & S_IWUSR) ? "w" : "-");
            printf((st.st_mode & S_IXUSR) ? "x" : "-");
            printf((st.st_mode & S_IRGRP) ? "r" : "-");
            printf((st.st_mode & S_IWGRP) ? "w" : "-");
            printf((st.st_mode & S_IXGRP) ? "x" : "-");
            printf((st.st_mode & S_IROTH) ? "r" : "-");
            printf((st.st_mode & S_IWOTH) ? "w" : "-");
            printf((st.st_mode & S_IXOTH) ? "x" : "-");
            printf(" %s\n", argv[i]);
        } else {
            perror(argv[i]);
        }
    }

    return 0;
}
