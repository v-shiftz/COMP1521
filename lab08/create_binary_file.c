#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <errno.h>
#include <ctype.h>

int main(int argc, char *argv[]){
        if (argc < 2){
                fprintf(stderr, "usage: %s <filename>\n", argv[0]);
                return 1;
        }
        FILE *fd = fopen(argv[1], "w");
        if (fd == NULL){
                fprintf(stderr, "%s", argv[0]);
                perror(argv[1]);
                return 1;
        }
        for (int i=2; i<argc; i++){
                fputc(atoi(argv[i]),fd);
        }
        //fprintf(fd, "\n");
        fclose(fd);
        return 0;
}