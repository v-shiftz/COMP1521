	.text
	# $t0 = int x;
	# $t1 = int y;
	# $t2 = int i;
main:
	li	$v0, 5				# scanf("%d", &x);
	syscall					#
	move	$t0, $v0

	li	$v0, 5				# scanf("%d", &y);
	syscall					#
	move	$t1, $v0

loop_init:
	addi	$t2, $t0, 1			#  int i = x + 1;
loop_cond:
	bge	$t2, $t1, loop_end		# while (i < y) {
loop_body:
inner_loop_init:
inner_loop_cond:
	beq	$t2, 13, inner_loop_iter	# if (i != 13) {
	move	$a0, $t2
	li	$v0, 1
	syscall					# printf("%d", i);
	li	$a0, '\n'			# printf("%c", '\n');
	li	$v0, 11
	syscall					# };
inner_loop_iter:
	addi	$t2, $t2, 1			# i = i + 1;
	j	loop_cond
loop_end:					# };
end:
	li	$v0, 0         		# return 0
	jr	$ra
