# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
# Zhang JINGYUAN, 05/03/2024

# Constants
ARRAY_LEN = 1000
	.text
	# $t0 = int i;
	# $t1 = int j;
main:

i_loop_init:
	li	$t0, 2
i_loop_cond:
	bge	$t0, ARRAY_LEN, i_loop_end
i_loop_body:

	la	$t2, prime
	add	$t2, $t2, $t0
	lb	$t3, 0($t2)
	beqz	$t3, i_loop_iter

	li	$v0, 1
	move	$a0, $t0
	syscall

	li	$v0, 11		# syscall 11: print_char
	li	$a0, '\n'	# 
	syscall			# printf("%c", '\n');

j_loop_init:
	mul	$t1, $t0, 2
j_loop_cond:
	bge	$t1, ARRAY_LEN, j_loop_end
j_loop_body:
	la	$t4, prime
	add	$t4, $t4,$t1
	sb	$zero, 0($t4)
j_loop_iter:
	add	$t1, $t1, $t0
	j	j_loop_cond
j_loop_end:


i_loop_iter:
	addi	$t0, $t0, 1
	j	i_loop_cond
i_loop_end:
	li	$v0, 0
	jr	$ra			# return 0;

	.data
prime:
	.byte	1:ARRAY_LEN		# uint8_t prime[ARRAY_LEN] = {1, 1, ...};
