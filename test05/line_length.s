# Reads a line and print its length

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - ...

	li	$v0, 4			# syscall 4: print_string
	la	$a0, line_prompt_str	#
	syscall				# printf("Enter a line of input: ");

	li	$v0, 8			# syscall 8: read_string
	la	$a0, line		#
	la	$a1, LINE_LEN		#
	syscall				# fgets(buffer, LINE_LEN, stdin)

	li	$v0, 4			# syscall 4: print_string
	la	$a0, result_str		#
	syscall				# printf("Line length: ");

loop_i_init:
	li	$t0, 0
	
loop_i_cond:
	addi	$t1, $t0, line
	lb	$t2, 0($t1)
	beqz	$t2, loop_i_end
loop_i_body:
	addi	$t0, $t0, 1
loop_i_iter:
	j	loop_i_cond
loop_i_end:

	li	$v0, 1			# syscall 1: print_int
	move	$a0, $t0		# 		
	syscall				# printf("%d", 42);

	li	$v0, 11			# syscall 11: print_char
	li	$a0, '\n'		#
	syscall				# putchar('\n');

	li	$v0, 0
	jr	$ra			# return 0;

########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
result_str:
	.asciiz	"Line length: "

# Line of input stored here
line:
	.space	LINE_LEN

