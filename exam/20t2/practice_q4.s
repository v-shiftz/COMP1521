# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print their sum

main:
while_init:
	li	$t0, 0
while_cond:
	bge	$t0, 42,while_end
while_body:
	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move	$t1, $v0
while_iter:
	add	$t0, $t0, $t1
	j	while_cond
while_end:
	
	move	$a0, $t0	# printf("%d\n", x);
	li	$v0, 1
	syscall

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall

	li	$v0, 0		# return 0
	jr	$ra
