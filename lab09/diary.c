#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    char *home = getenv("HOME");
    if (home == NULL) {
        fprintf(stderr, "Error: HOME environment variable not set.\n");
        return 1;
    }

    char diaryPath[1024];
    snprintf(diaryPath, sizeof(diaryPath), "%s/.diary", home);

    FILE *diaryFile = fopen(diaryPath, "a");
    if (diaryFile == NULL) {
        fprintf(stderr, "Error: Unable to open file %s\n", diaryPath);
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        if (i > 1) {
            fprintf(diaryFile, " ");
        }
        fprintf(diaryFile, "%s", argv[i]);
    }

    fprintf(diaryFile, "\n");

    fclose(diaryFile);
    
    return 0;
}
