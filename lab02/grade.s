# read a mark and print the corresponding UNSW grade
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# Zhang Jingyuan, 23/02/2024

#![tabsize(8)]

main:
	la	$a0, prompt	# printf("Enter a mark: ");
	li	$v0, 4
	syscall

	li	$v0, 5		# scanf("%d", mark);
	syscall
	move	$t0, $v0	# $t0 = $v0;

	blt	$t0, 50, FL	# $if (mark < 50) goto FL;
	blt	$t0, 65, PS	# $if (mark < 65) goto PS;
	blt	$t0, 75, CR	# $if (mark < 75) goto CR;
	blt	$t0, 85, DN	# $if (mark < 85) goto DN;
	j	HD
	

FL:
	la	$a0, fl		# printf("FL\n");
	li	$v0, 4
	syscall
	j	End

PS:
	la	$a0, ps		#printf("PS\n");
	li	$v0, 4
	syscall
	j	End

CR:
	la	$a0, cr		#printf("CR\n");
	li	$v0, 4
	syscall
	j	End

DN:
	la	$a0, dn		#printf("DN\n");
	li	$v0, 4
	syscall
	j	End

HD:
	la	$a0, hd		#printf("HD\n");
	li	$v0, 4
	syscall

End:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt:
	.asciiz "Enter a mark: "
fl:
	.asciiz "FL\n"
ps:
	.asciiz "PS\n"
cr:
	.asciiz "CR\n"
dn:
	.asciiz "DN\n"
hd:
	.asciiz "HD\n"
