# Reads 10 numbers into an array
# printing 0 if they are in non-decreasing order
# or 1 otherwise.
# Zhang Jingyuan, 01/03/2024

# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#  - $t0: int i
	#  - $t1: temporary result
	#  - $t2: temporary result
	#  - $t3: int swapped
	#  - $t4: int x
	#  - $t5: int y

scan_loop__init:
	li	$t0, 0				# i = 0;
scan_loop__cond:
	bge	$t0, ARRAY_LEN, scan_loop__end	# while (i < ARRAY_LEN) {

scan_loop__body:
	li	$v0, 5				#   syscall 5: read_int
	syscall					#   
						#
	mul	$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	la	$t2, numbers			#
	add	$t2, $t2, $t1			#
	sw	$v0, ($t2)			#   scanf("%d", &numbers[i]);

	addi	$t0, $t0, 1			#   i++;
	j	scan_loop__cond			# }
scan_loop__end:

	# TODO: add your code here!
swap_loop_init:
	li	$t3, 0				# int swapped = 0;
	li	$t0, 1				# int i = 1;

swap_loop_cond:
	bge	$t0, ARRAY_LEN, swap_loop_end	# while (i < ARRAY_LEN){

swap_loop_body:
	mul	$t1, $t0, 4			# numbers[i];
	sub	$t2, $t0, 1
	mul	$t2, $t2, 4			# numbers[i - 1];

	lw	$t4, numbers($t1)		# int x = numbers[i];
	lw	$t5, numbers($t2)		# int y = numbers[i - 1];

	bge	$t4, $t5, swap_loop_iter	# if (x < y){
	li	$t3, 1				# swapped = 1;

swap_loop_iter:
	addi	$t0, $t0, 1
	j	swap_loop_cond

swap_loop_end:
	move	$a0, $t3				
	li	$v0, 1	
	syscall					#printf("%d", swapped);

	li	$v0, 11				# syscall 11: print_char
	li	$a0, '\n'			#
	syscall					# printf("%c", '\n');

	li	$v0, 0
	jr	$ra				# return 0;

	.data
numbers:
	.word	0:ARRAY_LEN			# int numbers[ARRAY_LEN] = {0};
