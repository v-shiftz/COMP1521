# Reads a line and prints whether it is a palindrome or not

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - ...

	li	$v0, 4				# syscall 4: print_string
	la	$a0, line_prompt_str		#
	syscall					# printf("Enter a line of input: ");

	li	$v0, 8				# syscall 8: read_string
	la	$a0, line			#
	la	$a1, LINE_LEN			#
	syscall					# fgets(buffer, LINE_LEN, stdin)


i_loop_init:
	li	$t0, 0
	li	$a0, line
i_loop_cond:
	add	$t9, $t0, $a0
	lb	$t1, 0($t9)
	beqz	$t1, i_loop_end
i_loop_body:
i_loop_iter:
	addi	$t0, $t0, 1
	j	i_loop_cond
i_loop_end:

compare_loop_init:
	li	$t2, 0
	addi	$t3, $t0, -2
	li	$t4, line
compare_loop_cond:
	bge	$t2, $t3, compare_loop_end
compare_loop_body:

	add	$t5, $t4, $t2
	lb	$t7, 0($t5)
	add	$t6, $t4, $t3
	lb	$t8, 0($t6) 
	bne	$t7, $t8, not_palindrome

compare_loop_iter:
	addi	$t3, $t3, -1
	addi	$t2, $t2, 1
	j	compare_loop_cond
compare_loop_end:
	j	is_palindrome
not_palindrome:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, result_not_palindrome_str	#
	syscall					# printf("not palindrome\n");
	j	epilogue
is_palindrome:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, result_palindrome_str	#
	syscall					# printf("palindrome\n");

epilogue:
	li	$v0, 0
	jr	$ra				# return 0;


########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
result_not_palindrome_str:
	.asciiz	"not palindrome\n"
result_palindrome_str:
	.asciiz	"palindrome\n"

# Line of input stored here
line:
	.space	LINE_LEN

