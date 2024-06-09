# COMP1521 22T3 ... final exam, question 5

# Modify the program below such that its output
# matches that of 22t3final_q4.

main:
	li	$v0, 5				# syscall 5: read_int
	syscall					#
	move	$t0, $v0			# scanf("%d, &x);

	# ADD YOUR CODE HERE
for_init:
	li	$t1, 0			# int count = 0;
	li	$t2, 0			# int max = 0;
	li	$t3, 31			# int i = 31;
for_cond:
	blt	$t3, 0, for_end
for_body:
	srav	$t4, $t0, $t3
	and	$t4, 1
	beqz	$t4, reset_count
	addi	$t1, $t1, 1
	j	change_max
reset_count:
	li	$t1, 0
change_max:
	bgt	$t2, $t1, for_iter
	move	$t2, $t1
for_iter:
	addi	$t3, $t3, -1
	j	for_cond
for_end:

	li	$v0, 1				# syscall 1: print_int
	move	$a0, $t2				#
	syscall					# printf("%d", 42);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'			#
	syscall					# putchar('\n');

	li	$v0, 0				#
	jr	$ra				# return 0;
