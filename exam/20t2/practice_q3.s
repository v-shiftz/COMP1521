# this code reads 1 integer and prints it
# add code so that prints 1 iff
# the least significant (bottom) byte of the number read
# is equal to the 2nd least significant byte
# and it prints 0 otherwise

main:
	li	$v0, 5
	syscall
	move	$t0, $v0

	sll	$t1, $t0, 24
	sra	$t1, 24

	sll	$t2, $t0, 16
	sra	$t2, 24

	beq	$t1, $t2, positive
negative:
	li	$a0, 0
	j	print_statement
positive:
	li	$a0, 1
print_statement:
	li	$v0, 1
	syscall

	li	$a0, '\n'
	li	$v0, 11
	syscall

	li	$v0, 0
	jr	$ra
