        .text
main:
        li      $a0, prompt
        la      $v0, 4
        syscall

        li      $v0, 5
        syscall
        move    $t0, $v0

        move    $a0, $t0
        li      $v0, 1
        syscall
        
        li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall

        jr      $ra


        .data
prompt:
        .asciiz"Enter mips instructions as integers, -1 to finish: "
start_msg:
        .asciiz"Starting executing instructions"
finish_msg:
        .asciiz"Finished executing instructions"