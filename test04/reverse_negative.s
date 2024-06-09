# Reads numbers into an array until a negative number is entered
# then print the numbers in reverse order.

# Constants
ARRAY_LEN = 1000				# This is equivalent to a #define in C.

main:
	# Registers:
	#   - $t0: int i
	#   - $t1: temporary result

read_loop__init:
	li	$t0, 0				# i = 0
read_loop__cond:
	bge	$t0, ARRAY_LEN, read_loop__end	# while (i < ARRAY_LEN) {

read_loop__body:
	li	$v0, 5				#   syscall 5: read_int
	syscall					#   scanf("%d", &x);

	blt	$v0, 0, read_loop__end		#   if (x < 0) break;

	mul	$t1, $t0, 4			#   &numbers[i] = numbers + 4 * i
	sw	$v0, numbers($t1)		#   numbers[i] = x

	addi	$t0, $t0, 1			#   i++;
	j	read_loop__cond			# }
read_loop__end:
while_loop_start:
	# TODO: add your code here!
	ble	$t0, 0, end_of_code
	addi	$t0, $t0, -1

	mul	$t1, $t0, 4
	lw	$t2, numbers($t1)

	move	$a0, $t2
	li	$v0, 1
	syscall

	li	$v0, 11			# syscall 11: print_char
	li	$a0, '\n'		#
	syscall				# printf("%c", '\n');
	j	while_loop_start
end_of_code:
	li	$v0, 0
	jr	$ra				# return 0;

########################################################################
# .DATA
	.data
numbers:
	.space 4 * ARRAY_LEN			# int numbers[ARRAY_LEN];
