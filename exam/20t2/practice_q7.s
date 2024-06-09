# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print theintgers read in reverse order
.data
numbers: 
.word 0:1000

.text
main:
	
first_loop_init:
	li	$t0, 0			# int i = 0;
	li	$t1, 0			# int sum = 0;
first_loop_cond:
	bge	$t1, 42, first_loop_end
first_loop_body:
	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move	$t3, $v0
	la	$t4, numbers
	mul	$t5, $t0, 4
	add	$t4, $t5
	sw	$t3, ($t4)
	addi	$t0, $t0, 1
	
first_loop_iter:
	add	$t1, $t3
	j	first_loop_cond
first_loop_end:

second_loop_init:
second_loop_cond:
	ble	$t0, 0, second_loop_end
second_loop_body:
	addi	$t0, $t0, -1
	la	$t4, numbers
	mul	$t5, $t0, 4
	add	$t4, $t5
	lw	$t5, ($t4)

	move	$a0, $t5	# printf("%d\n", x);
	li	$v0, 1
	syscall

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall

second_loop_iter:
	j	second_loop_cond
second_loop_end:
	

	

	li	$v0, 0		# return 0
	jr	$ra
