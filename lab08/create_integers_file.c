#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <errno.h>

int main(int argc, char *argv[]){
        if (argc != 4){
                fprintf(stderr, "usage: %s <filename> <start> <end>\n", argv[0]);
                return 1;
        }
        FILE *fd = fopen(argv[1], "w");
        if (fd == NULL){
                fprintf(stderr, "%s", argv[0]);
                perror(argv[1]);
                return 1;
        }
        int start = atoi(argv[2]);
        int end = atoi(argv[3]);
        for (int i = start; i <= end; i++){
                fprintf(fd,"%d\n",i);
        }
        fclose(fd);
        return 0;

}