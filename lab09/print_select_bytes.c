#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]){
        if (argc < 2){
                fprintf(stderr, "usage: %s <filename> <position>...<position>\n", argv[0]);
                return 1;
        }
        FILE *fd = fopen(argv[1], "r");
        if (fd == NULL){
                fprintf(stderr, "%s", argv[0]);
                perror(argv[1]);
                return 1;
        }
        int c;
        for (int i = 2; i < argc; i ++){
                fseek(fd, atoi(argv[i]), SEEK_SET);
                c=fgetc(fd);
                printf("%2d - 0x%02X", c, c);
                if(isprint(c)){
                        printf(" - '%c'", c);
                }
                printf("\n");
        }


        fclose(fd);
        return 0;
}