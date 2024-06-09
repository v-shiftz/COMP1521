# COMP1521 22T2 ... final exam, question 2

main:
	li	$v0, 5		# syscall 5: read_int
	syscall
	move	$t0, $v0	# read integer into $t0

	li	$t1, 0		# int count = 0;

for_loop_init:
	li	$t2, 0
for_loop_cond:
	bge	$t2, 32, for_loop_end
for_loop_body:
	li	$t3, 1
	sllv	$t4, $t3, $t2
	and	$t5, $t0, $t4
	bnez	$t5, for_loop_iter
	addi	$t1, $t1, 1
for_loop_iter:
	addi	$t2, $t2, 1
	j	for_loop_cond
for_loop_end:
	move	$a0, $t1
	li	$v0, 1
	syscall
	li	$a0, '\n'
	li	$v0, 11
	syscall

main__end:
	li	$v0, 0		# return 0;
	jr	$ra
