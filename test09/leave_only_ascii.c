#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    FILE *open = fopen(argv[1], "r");
    FILE *replace = tmpfile();
    int c;
    while ((c = fgetc(open))!=EOF) {
        if (c >= 0 && c <= 127){
            fputc(c, replace);
        }
    }
    fclose(open);
    rewind(replace);
    open = fopen(argv[1],"w");
    while ((c = fgetc(replace)) != EOF) {
        fputc(c, open);
    }
    fclose(open);
    fclose(replace);
    return 0;
}