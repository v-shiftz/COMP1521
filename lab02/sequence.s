# Read three numbers `start`, `stop`, `step`
# Print the integers bwtween `start` and `stop` moving in increments of size `step`
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# Zhang Jingyuan, 23/02/2024

#![tabsize(8)]
	.text
	# $t0 = start_num;
	# $t1 = stop_num;
	# $t2 = step_size;
	# $t3 = int i;
main:					# int main(void)
	la	$a0, prompt1		# printf("Enter the starting number: ");
	li	$v0, 4
	syscall

	li	$v0, 5			# scanf("%d", number);
	syscall
	move	$t0, $v0		# $t0 = $v0(start_num);

	la	$a0, prompt2		# printf("Enter the stopping number: ");
	li	$v0, 4
	syscall

	li	$v0, 5			# scanf("%d", number);
	syscall
	move	$t1, $v0		# $t1 = $v0(stop_num);

	la	$a0, prompt3		# printf("Enter the step size: ");
	li	$v0, 4
	syscall

	li	$v0, 5			# scanf("%d", number);
	syscall
	move	$t2, $v0		# $t2 = $v0(step_size);

	blt	$t1, $t0, loop_1	# if (stop < start) goto loop_1;
	bgt	$t1, $t0, loop_2	# if (stop > start) goto loop_2;
loop_1:
	bgt	$t2, 0, end		# if (step > 0) goto end;
	ble	$t0, $t1, end		# if (start <= stop) goto end;
	
	move	$a0, $t0
	li	$v0, 1
	syscall				#printf("%d", i);

	li	$a0, '\n'		# printf("%c", '\n');
	li	$v0, 11
	syscall

	add	$t0, $t0, $t2		# $t0: start += step;
	b	loop_1

loop_2:
	blt	$t2, 0, end		# if (step < 0) goto end;
	bge	$t0, $t1, end		# if (start >= stop) goto end;
	
	move	$a0, $t0
	li	$v0, 1
	syscall				# printf("%c", '\n');

	li	$a0, '\n'		
	li	$v0, 11
	syscall				#printf("%d", i);

	add	$t0, $t0, $t2		# $t0: start += step;
	b	loop_2

end:
	li	$v0, 0
	jr	$ra			# return 0

	.data
prompt1:
	.asciiz "Enter the starting number: "
prompt2:
	.asciiz "Enter the stopping number: "
prompt3:
	.asciiz "Enter the step size: "
