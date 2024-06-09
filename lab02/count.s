# read a number n and print the integers 1..n one per line
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# Zhang Jingyuan, 23/02/2024

#![tabsize(8)]
	.text
	# $t0 = number enetered;
	# $t1 = i;
main:                 		# int main(void)
	la	$a0, prompt	# printf("Enter a number: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall
	move	$t0, $v0	# $t0 = $v0(number enetered)
	li	$t1, 1		# int i = 1; $t1 = i
TOP:
	bgt	$t1, $t0, end	# if i > number, goto end

	li	$v0, 1
	move	$a0, $t1
	syscall
	
	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall

	addi	$t1, $t1, 1	# $t1 = $t1 + 1;
	b	TOP		# goto top;

end:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt:
	.asciiz "Enter a number: "
