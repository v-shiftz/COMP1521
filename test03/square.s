	.text
	# $t0 = int x;
	# $t1 = int i;
	# $t2 = int j;
main:
	li	$v0, 5				# scanf("%d", &x);
	syscall					#
	move	$t0, $v0			# scanf("%d", &x);
outer_loop_init:
	li	$t1, 0				# int i = 0;

outer_loop_cond:
	bge	$t1, $t0, outer_loop_end	# while (i < x) {
outer_loop_body:
inner_loop_init:
	li	$t2, 0				# int j = 0;
inner_loop_cond:
	bge	$t2, $t0, inner_loop_end	# while (j < x) {
inner_loop_body:
	li	$a0, '*'
	li	$v0, 11
	syscall					# printf("*");
inner_loop_iter:
	addi	$t2, $t2, 1			# j = j + 1;
	j	inner_loop_cond
inner_loop_end:					# };
outer_loop_iter:
	addi	$t1, $t1, 1			# i = i + 1;
	li	$a0, '\n'			# printf("%c", '\n');
	li	$v0, 11
	syscall
	j	outer_loop_cond
outer_loop_end:					# };
end:
	li	$v0, 0				# return 0
	jr	$ra	
