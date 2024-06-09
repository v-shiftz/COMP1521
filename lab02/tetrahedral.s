# Read a number n and print the first n tetrahedral numbers
# https://en.wikipedia.org/wiki/Tetrahedral_number
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# Zhang Jingyuan, 23/02/2024

#![tabsize(8)]
	.text
	# $t0 = how_many;
	# $t1 = i;
	# $t2 = j;
	# $t3 = n;
	# $t4 = total;
main:				# int main(void) {

	la	$a0, prompt	# printf("Enter how many: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall
	move	$t0, $v0	# $t0 = $v0 (how_many);
	li	$t3, 1		# n = 1;
	
	
n_loop:
	bgt	$t3, $t0, end	# if (n > how_many) goto end;
	li	$t4, 0		# total = 0;
	li	$t2, 1		# j = 1;
j_loop:
	bgt	$t2, $t3, add_n	# if (j > n) goto add_n;
	li	$t1, 1		# i = 1;
i_loop:
	
	bgt	$t1, $t2, add_j	# if (i > j) goto add_j;
	add	$t4, $t4, $t1	# total = total + i;
	
	addi	$t1, $t1, 1	# i = i + 1;
	b	i_loop

add_n:
	move	$a0, $t4
	li	$v0, 1
	syscall			# printf("%d", total);

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall
	addi	$t3, $t3, 1	# n = n + 1;
	b	n_loop
add_j:
	addi	$t2, $t2, 1	# j = j + 1;
	b	j_loop

	

end:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt:
	.asciiz "Enter how many: "
