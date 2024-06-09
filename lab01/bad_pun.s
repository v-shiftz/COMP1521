    .text
main:
    li  $v0, 4          
    la  $a0, pun        #printf("Well, this is a mistake!");
    syscall

    li  $v0, 11
    li  $a0, '\n'       #printf("\n");
    syscall

    li  $v0,0
    jr  $ra

    .data
pun:
    .asciiz"Well, this was a MIPStake!"