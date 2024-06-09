# COMP1521 22T3 ... final exam, question 3

# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print their sum

main:
	
while_init:
	li	$t1, 0
while_cond:
	bge	$t1, 42, while_end
while_body:
	li	$v0, 5		#   scanf("%d", &x);
	syscall			#
	move	$t0, $v0

while_iter:
	add	$t1, $t0
	j	while_cond
while_end:

	move	$a0, $t1	#   printf("%d\n", x);
	li	$v0, 1
	syscall

	li	$a0, '\n'	#   printf("%c", '\n');
	li	$v0, 11
	syscall

	li	$v0, 0		# return 0
	jr	$ra
