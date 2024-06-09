########################################################################
# .DATA
# Here are some handy strings for use in your code.
	.data
prompt_m_str:	.asciiz	"Enter m: "
prompt_n_str:	.asciiz	"Enter n: "
result_str_1:	.asciiz	"Ackermann("
result_str_2:	.asciiz	", "
result_str_3:	.asciiz	") = "

########################################################################
# .TEXT <main>
	.text
main:

	# Args: void
	# Returns: int
	#
	# Frame:	[...]
	# Uses: 	[...]
	# Clobbers:	[...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   - main
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

main__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	# TODO: set up your stack frame

main__body:
	li	$v0, 4
	la	$a0, prompt_m_str
	syscall

	li	$v0, 5
	syscall
	move	$s0, $v0		# $s0 = int m;

	li	$v0, 4
	la	$a0, prompt_n_str
	syscall

	li	$v0, 5
	syscall
	move	$s1, $v0		# $s1 = int n;

	move	$a0, $s0
	move	$a1, $s1
	jal	ackermann
	move	$s2, $v0

	li	$v0, 4
	la	$a0, result_str_1
	syscall

	li	$v0, 1
	move	$a0, $s0
	syscall

	li	$v0, 4
	la	$a0, result_str_2
	syscall

	li	$v0, 1
	move	$a0, $s1
	syscall

	li	$v0, 4
	la	$a0, result_str_3
	syscall

	li	$v0, 1
	move	$a0, $s2
	syscall

	li	$v0, 11					# syscall 11: print_char
	li	$a0, '\n'				# 
	syscall						# printf("%c", '\n');
	# TODO: add your function body here

main__epilogue:

	# TODO: clean up your stack frame
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	li	$v0, 0
	jr	$ra			# return 0;

########################################################################
# .TEXT <ackermann>
	.text
ackermann:

	# Args:
	#   - $a0: int m
	#   - $a1: int n
	# Returns: int
	#
	# Frame:	[]
	# Uses: 	[]
	# Clobbers:	[]
	#
	# Locals:
	#   - .
	#
	# Structure:
	#   - ackermann
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

ackermann__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	move	$s0, $a0
	move	$s1, $a1
	# TODO: set up your stack frame

ackermann__body:
	beq	$s0, 0, m_is_0
	beq	$s1, 0, n_is_0

	addi	$s1, $s1, -1
	move	$a0, $s0
	move	$a1, $s1
	jal	ackermann
	move    $s2, $v0
	
	addi	$s0, $s0, -1
	move	$a0, $s0
	move	$a1, $s2
	jal	ackermann

	j	ackermann__epilogue
m_is_0:
	addi	$s1, $s1, 1
	move	$v0, $s1
	j	ackermann__epilogue

n_is_0:
	li	$s1, 1
	addiu	$s0, $s0, -1
	move	$a0, $s0
	move	$a1, $s1
	jal	ackermann
	# TODO: add your function body here

ackermann__epilogue:
	# TODO: clean up your stack frame
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra
