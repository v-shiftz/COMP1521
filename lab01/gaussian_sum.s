# A simple MIPS program that calculates the Gaussian sum between two numbers

# int main(void)
# {
#   int number1, number2;
#
#   printf("Enter first number: ");
#   scanf("%d", &number1);
#
#   printf("Enter second number: ");
#   scanf("%d", &number2);
#
#   int gaussian_sum = ((number2 - number1 + 1) * (number1 + number2)) / 2;
#
#   printf("The sum of all numbers between %d and %d (inclusive) is: %d\n", number1, number2, gaussian_sum);
#
#   return 0;
# }
  .text
  #$t0 = first_num
  #$t1 = second_num
main:
  li  $v0, 4
  la  $a0, prompt1        #printf("Enter first number: );
  syscall

  li  $v0, 5
  syscall
  move $t0, $v0           #$t0 = first_num;
  
  li  $v0, 4
  la  $a0, prompt2        #printf("Enter second number: );
  syscall
  
  li  $v0, 5
  syscall
  move $t1, $v0           # $t1 = second_num;

  addi $t2, $t1, 1        # $t2 = number2 + 1
  
  sub $t2, $t2, $t0       # $t2 = number 2 - number1 + 1;
  
  add $t3, $t0, $t1       # $t3 = number 1 + number 2;
  
  mul $t4, $t2, $t3       # $t4 = (number 2 - number1 + 2) * (number1 + number2);
  li  $t5, 2              # $t5 = 2
  div $t4, $t5            # $L0 = ((number 2 - number1 + 2) * (number1 + number2))/2; -> saved in L0
  mflo  $t4               # $t4 = L0; -> move from L0 to $t4 

  li  $v0, 4          
  la  $a0, answer1        #printf("The sum of all numbers between ");
  syscall

  li  $v0, 1
  move  $a0, $t0            #printf(number1);
  syscall

  li  $v0, 4
  la  $a0, answer2        #printf(" and ");
  syscall

  li  $v0, 1
  move  $a0, $t1
  syscall                 #printf(number2);

  li  $v0, 4
  la  $a0, answer3        #printf(" (inclusive) is: ");
  syscall

  li  $v0, 1
  move  $a0, $t4          #printf(gaussian num);
  syscall

  li  $v0, 11
  li  $a0, '\n'           #printf("\n");
  syscall

  li   $v0, 0
  jr   $ra                # return


.data
  prompt1: .asciiz "Enter first number: "
  prompt2: .asciiz "Enter second number: "

  answer1: .asciiz "The sum of all numbers between "
  answer2: .asciiz " and "
  answer3: .asciiz " (inclusive) is: "
