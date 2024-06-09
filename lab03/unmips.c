#include <stdio.h>
#include <string.h>

#define DATA_SIZE 146
#define BUFFER 72
            // $t0 and $t1 are addresses / temp
            // $t2 = num1;
            // $t3 = num2;
            //


int main(void) {
    char data_segment[DATA_SIZE] = {0};     // .byte 0:145
    char buffer_segment[BUFFER];            // addi	$t1, $t0, 73
    char *start = data_segment;
    char *swap = buffer_segment;
    int num1, num2;
    fgets(start,BUFFER,stdin);              // li	$a1, 72 + syscall
    scanf("%d", &num1);                     // li	$v0, 5 + syscall + move	$t2, $v0
    scanf("%d", &num2);                     // li	$v0, 5 + syscall + move	$t3, $v0

    int x = 0;                              // $t4 = int x = 0
    while (x < num1){                       // bge	$t4, $t2, label_6
        int y = 0;                          // $t5 = int y = 0
        while (y < 70){                     // bge	$t5, 70, label_5
            char previous, current, next;   
            int P, C, N;
            if (y == 0){                    // make sure previous wont give an error when -1 (out of index error)
                previous = '0';             // lb	$t6, -1($t9)
                current = start[y];         // lb	$t7, ($t9)
                next = start[y + 1];        // lb	$t8, 1($t9)
            }else if(y == 69){              // make sure next wont give an error when + 1 (out of index error)
                previous =  start[y - 1];   // lb	$t6, -1($t9)
                current = start[y];         // lb	$t7, ($t9)
                next = '0';                 // lb	$t8, 1($t9)
            }else{
                previous =  start[y - 1];   // lb	$t6, -1($t9)
                current = start[y];         // lb	$t7, ($t9)
                next = start[y + 1];        // lb	$t8, 1($t9)
            }
            
            
            P = (previous > '0') * 4;       // sgt	$t6, $t6, 48 + mul	$t6, $t6, 4
            C = (current > '0') * 2;        // sgt	$t7, $t7, 48 + mul	$t7, $t7, 2
            N = (next > '0');               // sgt	$t8, $t8, 48

            int sum = P + C + N;            // add	$t8, $t8, $t7 + add	$t8, $t8, $t6
            N = num2;                       // move	$t6, $t3
            while (sum > 0){                // ble	$t8, 0, label_4
                N /= 2;                     // div	$t6, $t6, 2
                sum --;                     // addi	$t8, $t8, -1
            }
            N = (N % 2) + 1;                // rem	$t6, $t6, 2 + addi	$t6, $t6, 1
            N *= 32;                        // mul	$t6, $t6, 32
            swap[y] = N;                    // add	$t9, $t1, $t5 + sb	$t6, ($t9)
            printf("%c", swap[y]);          // li	$v0, 11 + move	$a0, $t6 + syscall

            y++;                            // addi	$t5, $t5, 1
        }
        printf("\n");                       // li	$a0, 10 + syscall
        char *temp = start;                 // move	$t6, $t0
        start = swap;                       // move	$t0, $t1
        swap = temp;                        // move	$t1, $t6
        x++;                                // addi	$t4, 1
    }   
    return 0;                               //li	$v0, 0 + jr	$ra
}
