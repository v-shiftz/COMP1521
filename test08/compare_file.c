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
        FILE *compare = fopen(argv[2], "r");
        if (fd == NULL){
                fprintf(stderr, "%s", argv[0]);
                perror(argv[1]);
                return 1;
        }
        int c, c1;
        int count = 0;
        while (1){
                c=fgetc(fd); 
                c1=fgetc(compare);
                if (c == EOF && c1 == EOF){
                        printf("Files are identical\n");
                        exit(1);
                }
                if (c == EOF){
                        printf("EOF on %s\n",argv[1]);
                        exit(1);
                }
                if(c1 == EOF){
                        printf("EOF on %s\n", argv[2]);
                        exit(1);
                }
                if (c != c1){
                        printf("Files differ at byte %d\n", count);
                        break;
                }
                count++;
        }
        
        fclose(compare);
        fclose(fd);
        return 0;
}