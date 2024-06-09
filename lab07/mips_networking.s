# Reads a 4-byte value and reverses the byte order, then prints it

########################################################################
# .TEXT <main>
main:
	# Locals:
	#	- $t0: int network_bytes
	#	- $t1: int computer_bytes
	#	- Add your registers here!


	li	$v0, 5		# scanf("%d", &x);
	syscall
	move	$t0, $v0

	li	$t1, 0
	li	$t2, 0xFF
	and	$t3, $t0, $t2
	sll	$t3, 24
	or	$t1, $t3

	li	$t2, 0xFF
	sll	$t2, 8
	and	$t3, $t0, $t2
	sll	$t3, 8
	or	$t1, $t3

	li	$t2, 0xFF
	sll	$t2, 16
	and	$t3, $t0, $t2
	sra	$t3, 8
	or	$t1, $t3

	li	$t2, 0xFF
	sll	$t2, 24
	and	$t3, $t0, $t2
	sra	$t3, 24
	or	$t1, $t3


	move	$a0, $t1	# printf("%d\n", x);
	li	$v0, 1
	syscall

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall

main__end:
	li	$v0, 0		# return 0;
	jr	$ra
