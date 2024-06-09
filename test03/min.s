#  print the minimum of two integers
	.text
	# $t0 = int x;
	# $t1 = int y;
main:
	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move	$t0, $v0

	li	$v0, 5		# scanf("%d", &y);
	syscall			#
	move	$t1, $v0

compare_loop:
	blt 	$t0, $t1, print_x

print_y:
	li	$v0, 1
	move	$a0, $t1
	syscall			# printf("%d", y);

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall
	j	end
	
print_x:
	li	$v0, 1
	move	$a0, $t0
	syscall			# printf("%d", x);

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall
end:
	li	$v0, 0		# return 0
	jr	$ra
