#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[]){
        if (argc < 1){
                fprintf(stderr, "usage: <filename>\n");
                return 1;
        }
        FILE *fd = fopen(argv[1], "r");
        if (fd == NULL){
                fprintf(stderr, "%s", argv[0]);
                perror(argv[1]);
                return 1;
        }
        int c;
        int count = 0;
        while ((c=fgetc(fd)) != EOF){
                if (tolower(c) == 'a' || tolower(c) == 'e' || tolower(c) == 'i' || tolower(c) == 'o' || tolower(c) == 'u'){
                        count++;
                }
        }
        printf("%d\n", count);
        fclose(fd);
        return 0;
}