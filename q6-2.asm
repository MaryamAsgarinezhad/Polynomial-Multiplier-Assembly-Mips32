.data  #Maryam Asgarinezhad    98108651
textInput:  .asciiz "Please Enter Your Numbers in order: "
textoutput: .asciiz "the answer is: "
number1: .space 4
number2: .space 4

.text
la $a0, textInput
ori  $v0, $zero, 4
syscall          #shows the entering text
li $v0,5
la $a0,number1
li $a1,4
syscall 
add $s1,$zero,$v0 #gets number1 and puts it in s1
li $v0,5
la $a0,number2
li $a1,4
syscall 
add $s2,$zero,$v0 #gets number2 and puts it in s2


signcheck1:
li $t0,2147483648  # its a 32 bit mask that only the 32`th bit is 1 and other bits are 0(2^31=2147483648)
and $t1,$t0,$s1   #we mask the 321th bit of s1 to know its positive or negative,if t1 is 0 its positive else its negative
beqz $t1,pos1   #s1 is positive
li $s3,1    #if this line runs, means that number1 is negative,s3 is the sign of number1(1 for negative and 0 for positive)

addi $s1,$s1,-1
xori $s1,$s1,4294967295   #saves absolute value of s1 instead of s1(2^32-1=4294967295)
j signcheck2


signcheck2:
and $t1,$t0,$s2   #we mask the 321th bit of s1 to know its positive or negative
beqz $t1,pos2   #s1 is positive   
li $s4,1    #if this line runs, means that number2 is negative,s4 is the sign of number2(1 for negative and 0 for positive)

addi $s2,$s2,-1
xori $s2,$s2,4294967295   #saves absolute value of s2 instead of s2(2^32-1=4294967295)
j multiply

pos1:
li $s3,0    #if this line runs, means that number1 is positive,s3 is the sign of number1(1 for negative and 0 for positive)
j signcheck2

pos2:
li $s4,0    #if this line runs, means that number2 is positive,s4 is the sign of number2(1 for negative and 0 for positive)
j multiply     #starts multiplying absolute values of s1 & s2


multiply:
li $t0,1  #counter
li $t1,33  #condition of end loop
li $t3,1   #the mask to recognize a bit of s2 each time
li $t4,0   #if t4 is 0 means the t0`th bit of s2 is 0 else i`th bit of s2 is 1
li $t5,0   #answer of multiplication
addi $t6,$s1,0   #variable

loop:
beq  $t0,$t1,exit
and $t4,$t3,$s2  #if t4 is 0 means the t0`th bit of s2 is 0 else i`th bit of s2 is 1
bnez $t4,shift1  
shift2: 
sll $t6,$t6,1   #t6=t6*2 before going to next bit
addi $t0,$t0,1  #updates counter
sll $t3,$t3,1   #update the mask that only its t0`th bit is 1
j loop


shift1:
add $t5,$t6,$t5  #t0`th bit is 1 so we add the current t5 to the final amount
j shift2

exit:
xor $s3,$s3,$s4  #s3 is 0 if the answer is positive, and is 1 if the answer is negative
bnez $s3,negateans

print:
la $a0, textoutput
ori  $v0, $zero, 4
syscall          #shows the output text
addi $a0,$t5,0
li $v0,1
syscall  #prints the answer
j end

negateans:
xori $t5,$t5,4294967295   #saves absolute value of s2 instead of s2(2^32-1=4294967295)
addi $t5,$t5,1
j print

end:

