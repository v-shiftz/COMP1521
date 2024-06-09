#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <errno.h>
#include <ctype.h>

int main(int argc, char *argv[]){
        if (argc != 2){
                fprintf(stderr, "usage: %s <filename>\n", argv[0]);
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
                printf("byte %4d: %3d 0x%02x ", count, c, c);
                if(isprint(c)){
                        printf("'%c'", c);
                }
                printf("\n");
                count++;
        }
        fclose(fd);
        return 0;
}