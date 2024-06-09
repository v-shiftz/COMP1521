// COMP1521 22T3 ... final exam, question 6

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(int argc, char *argv[]) {

    assert(argc == 3);

    char *filename = argv[1];
    int line = atoi(argv[2]);

    assert(line > 0);
    FILE *fp = fopen(filename, "r");
    FILE *tmp = fopen("tmp", "w");
    int c;
    int count = 1;
    while ((c = fgetc(fp)) != EOF) {
        if (count != line) {
            fputc(c, tmp);
        }
        if (c == '\n') {
            count++;
        }
    }
    fclose(fp);
    fclose(tmp);
    FILE *write = fopen(filename, "w");
    FILE *read = fopen("tmp", "r");
    while ((c = fgetc(read)) != EOF) {
        fputc(c, write);
    }
    fclose(write);
    fclose(read);
    return 0;
}
