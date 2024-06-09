# Read a number and print positive multiples of 7 or 11 < n
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# ZHANG JINGYUAN, 23/02/2024

#![tabsize(8)]
	.text
	# $t0 = number entered;
	# $t1 = i;
	# $t2 = i % 7;
	# $t3 = i % 11;
main:				# int main(void) {

	la	$a0, prompt	# printf("Enter a number: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall
	move	$t0, $v0	# $t0 = number;
	li	$t1, 1		# $t1 = 1;

Loop_Begin:
	bge	$t1, $t0, end	# if i > number, goto end

	rem	$t2, $t1, 7	# if ((i % 7) 
	beqz	$t2, Print_I	# == 0) goto Print_I;

	rem	$t3, $t1, 11	# if((i % 11)
	beqz	$t3, Print_I	# == 0) goto Print_I;
	b	Add_I

Print_I:
	move	$a0, $t1	# printf("%d", i);
	li	$v0, 1
	syscall

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall
Add_I:
	addi	$t1, $t1, 1	# i = i + 1;
	b	Loop_Begin

end:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt:
	.asciiz "Enter a number: "
