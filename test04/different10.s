# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#   - $t0: int x
	#   - $t2: int n_seen
	#   - $t3: temporary result
	#   - $t4: temporary result
	#   - $t5: int i

slow_loop__init:
	li	$t2, 0				# n_seen = 0;
slow_loop__cond:
	bge	$t2, ARRAY_LEN, slow_loop__end	# while (n_seen < ARRAY_LEN) {

slow_loop__body:
	li	$v0, 4				#   syscall 4: print_string
	la	$a0, prompt_str			#
	syscall					#   printf("Enter a number: ");

	li	$v0, 5				#   syscall 5: read_int
	syscall					#
	move	$t0, $v0			#   scanf("%d", &x);

inner_loop_init:
	li	$t5, 0
inner_loop_cond:
	bge	$t5, $t2, inner_loop_end
inner_loop_body:
	la	$t3, numbers
	mul	$t4, $t5, 4
	add	$t3, $t3, $t4
	lw	$t6, ($t3)

	bne	$t0, $t6, inner_loop_iter
	j	update_array
inner_loop_iter:
	addi	$t5, $t5, 1
	j	inner_loop_cond
inner_loop_end:
update_array:
	bne	$t5, $t2, slow_loop__cond
	mul	$t3, $t2, 4			#
	sw	$t0, numbers($t3)		#   numbers[n_seen] = x;

	addi	$t2, $t2, 1			#   n_seen++;
	j	slow_loop__cond
slow_loop__end:					# }

	li	$v0, 4				# syscall 4: print_string
	la	$a0, result_str			#
	syscall					# printf("10th different number was: ");

	li	$v0, 1				# syscall 1: print_int
	move	$a0, $t0			#
	syscall					# printf("%d", x);

	li	$v0, 11				# syscall 11: print_char	
	li	$a0, '\n'			#
	syscall					# putchar('\n');

	li	$v0, 0
	jr	$ra				# return 0;

########################################################################
# .DATA
	.data
numbers:
	.space 4 * ARRAY_LEN			# int numbers[ARRAY_LEN];
prompt_str:
	.asciiz	"Enter a number: "
result_str:
	.asciiz	"10th different number was: "
