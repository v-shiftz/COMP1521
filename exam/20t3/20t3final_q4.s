# COMP1521 20T3 final exam Q4 starter code

# This code reads 1 integer and prints it

# Change it to read integers until low is greater or equal to high
# then print their difference

main:

loop_init:
	li	$t0, 0;			#int low = 0;
	li	$t1, 100;		#int high = 100;
loop_cond:
	bge	$t0, $t1, loop_end
loop_body:
	li	$v0, 5		# scanf("%d", &x);
	syscall
	move	$t2, $v0
loop_iter:
	add	$t0, $t2
	sub	$t1, $t2
	j	loop_cond
loop_end:
	sub	$t0, $t1

	move	$a0, $t0	# printf("%d\n", x);
	li	$v0, 1
	syscall

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall

	li	$v0, 0		# return 0
	jr	$ra
