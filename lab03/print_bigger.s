# Reads 10 numbers into an array and prints numbers which are
# larger than the final number read.

# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#  - $t0: int i
	#  - $t1: temporary result
	#  - $t2: temporary result
	#  - $t9: final_number


	# TODO: modify the code below to behave like
	# the provided C program.
scan_loop__init:
	li	$t0, 0				# i = 0;
scan_loop__cond:
	bge	$t0, ARRAY_LEN, scan_loop__end	# while (i < ARRAY_LEN) {

scan_loop__body:
	li	$v0, 5				#   syscall 5: read_int
	syscall					#   
	move	$t9, $v0			#
	mul	$t1, $t0, 4			#   
	sw	$t9, numbers($t1)		#  

	addi	$t0, $t0, 1			#
	j	scan_loop__cond			#
scan_loop__end:

print_loop__init:
	li	$t0, 0				# i = 0
	
print_loop__cond:
	bge	$t0, ARRAY_LEN, print_loop__end # while (i < ARRAY_LEN) {

print_loop__body:
	mul	$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	lw	$t2, numbers($t1)		#
	blt	$t2, $t9, print_loop_iter	#
	li	$v0, 1				#   syscall 1: print_int
	move	$a0, $t2
	syscall					#   printf("%d", numbers[i]);

	li	$v0, 11				#   syscall 11: print_char
	li	$a0, '\n'			#
	syscall					#   printf("%c", '\n');


print_loop_iter:
	addi	$t0, $t0, 1			#   i++;
	j	print_loop__cond		# }
print_loop__end:

	li	$v0, 0				
	jr	$ra				# return 0;

	.data
numbers:
	.word	0:ARRAY_LEN			# int numbers[ARRAY_LEN] = {0};
