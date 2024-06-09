	.data
numbers:
	.word 0:10	# int numbers[10] = { 0 };

	.text
main:
	li	$t0, 0		# i = 0;

main__input_loop:
	bge	$t0, 10, main__input_finished	# while (i < 10) {

	li	$v0, 5			# syscall 5: read_int
	syscall
	mul	$t1, $t0, 4
	sw	$v0, numbers($t1)	#	scanf("%d", &numbers[i]);
	
	addi	$t0, 1			#	i++;
	b	main__input_loop	# }

main__input_finished:
	
while_loop_init:
	li	$t2, 1			# int max_run = 1;
	li	$t3, 1			# int current_run = 1;
	li	$t0, 1			# i = 1;
while_loop_cond:
	bge	$t0, 10, while_loop_end
while_loop_body:
	mul	$t1, $t0, 4
	lw	$t4, numbers($t1)	# numbers[i]
	addi	$t1, $t1, -4
	lw	$t5, numbers($t1)	# numbers[i - 1]
	
	bleu	$t4, $t5, current_run_one
current_run_add:
	addi	$t3, $t3, 1
	j	check_run_diff
current_run_one:
	li	$t3, 1
check_run_diff:
	bleu	$t3, $t2, while_loop_iter
	move	$t2, $t3
while_loop_iter:
	addi	$t0, $t0, 1
	j	while_loop_cond
while_loop_end:
main__print_42:
	li	$v0, 1		# syscall 1: print_int
	move	$a0, $t2
	syscall			# printf("42");

	li	$v0, 11		# syscall 11: print_char
	li	$a0, '\n'
	syscall			# printf("\n");

	li	$v0, 0
	jr	$ra		# return 0;
