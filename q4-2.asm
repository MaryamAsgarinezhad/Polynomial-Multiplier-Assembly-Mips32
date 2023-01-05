.data
polycoeff: .space 4  #we set the coefficints of both polynomials in this variable
deg1: .space 4  #degree of fist polynomial
deg2: .space 4  #degree of second polynomial
inputdeg1: .asciiz "please enter the degree of first polynomial(less than 6)"
inputdeg2: .asciiz "please enter the degree of second polynomial(less than 6)"
input1: .asciiz "please enter the coefficients of first polynomial inorder"
input2: .asciiz "please enter the coefficients of second polynomial inorder"
coeff1: .space 5  #we assume the maximum degree to be 5,so we need 5 bytes te store each coefficient in a byte
coeff2: .space 5
ans: .space 25 #we store the coeffs of multiplication in ans,the maximum degree of it is 5*5=25
invalid: .asciiz "smaller number required,"
outdeg: .asciiz "degree of multiplied polinomial is:"
outcoeff: .asciiz ", and coefficients of multiplied polinomial in order is:"
comma: .asciiz " , "

.text
checkdegree1:
la $a0,inputdeg1
li $v0,4
syscall    #shows the enter text for deg1
li $v0,5
la $a0,deg1
li $a1,4
syscall #gets degree
slti $t1,$v0,6
beqz $t1,exit1 #invalid degree
addi $s1,$v0,0  #stores the valid degree of first polynomial in s1

li $v0,4
la $a0,input1
syscall  #shows the enter text for coefficints of first poly

la $a2,coeff1 #address of current coeff

li $t0,1 #couter of inputloop1
addi $t1,$s1,2  #condition for end of inputloop1
inputloop1:
beq $t0,$t1,checkdegree2  #starts recieving poly2
li $v0,5
la $a0,polycoeff
li $a1,4
syscall  #gets a coeff
sb $v0,($a2) #saves the current coeff in coeff1
addi $a2,$a2,1 #goes to next address
addi $t0,$t0,1
j inputloop1

exit1:
li $v0,4
la $a0,invalid
syscall  #shows the text to enter a less degree
j checkdegree1

checkdegree2:
la $a0,inputdeg2
li $v0,4
syscall    #shows the enter text for deg2
li $v0,5
la $a0,deg2
li $a1,4
syscall #gets degree
slti $t1,$v0,6
beqz $t1,exit2 #invalid degree
addi $s2,$v0,0  #stores the valid degree of second polynomial in s2

li $v0,4
la $a0,input2
syscall  #shows the enter text for coefficints of second poly

la $a3,coeff2 #address of current coeff

li $t0,1 #couter of inputloop2
addi $t1,$s2,2   #condition for end of inputloop2
inputloop2:
beq $t0,$t1,multiply   #starts multiplication
li $v0,5
la $a0,polycoeff
li $a1,4
syscall  #gets a coeff
sb $v0,($a3) #saves the current coeff in coeff1
addi $a3,$a3,1 #goes to next address
addi $t0,$t0,1
j inputloop2

exit2:
li $v0,4
la $a0,invalid
syscall  #shows the text to enter a less degree
j checkdegree2

multiply:
la $a0,coeff1 #gets the first address of coeff1
la $a1,coeff2 #gets the first address of coeff2
jal f  #subroutine that multiplies polys
j printans

f:
li $t0,-1 #counter of loop1
addi $t1,$s1,1   #condition for end of loop1

loop1: #here we pass through 1st poly`s coeffs
lb $t2,($a0)
addi $a0,$a0,1 #updates the pointer for the next repeat of loop1
addi $t0,$t0,1 #updates counter
beq $t0,$t1,output
la $a1,coeff2 #gets the first address of coeff2

li $t3,-1 #counter of loop2
addi $t4,$s2,1   #condition for end of loop2

loop2:   #here we pass through 2nd poly`s coeffs
addi $t3,$t3,1 #updates counter
add $t7,$t3,$t0  #i+j, index of answer
beq $t3,$t4,loop1  #repeats loop2 for the next coeff of poly1
lb $t5,($a1)
addi $a1,$a1,1 #updates the pointer for the next repeat of loop2
mul $t6,$t2,$t5  #poly1[i]*poly2[j]
lb $t8,ans($t7)  #ans[i+j]
add $t6,$t6,$t8  #ans[i+j]+poly1[i]*poly2[j]
sb $t6,ans($t7)  #new ans[i+j]
j loop2

output:
la $v0,ans #adress of answer is in v0
jr $ra

printans:
la $a1,($v0)   #stores output adress in a1
la $a0,outdeg
li $v0,4
syscall    #shows the output text for degree
add $s1,$s2,$s1  #degree of multiplied poly is s1+s2
addi $a0,$s1,0
li $v0,1
syscall #prints the final degree
la $a0,outcoeff
li $v0,4
syscall    #shows the output text for coefficients

li $t0,-1   #counter of coeffprint
coeffprint:
beq $t0,$s1,exit   #s1 is the final degree, s1+1 is the number of final coeffs
lb $a0,($a1)
li $v0,1
syscall  #prints a coeff

la $a0,comma
li $v0,4
syscall    #prints a comma

addi $t0,$t0,1   #updates counter
addi $a1,$a1,1   #goes to next coeff
j coeffprint


exit:
li $v0,10
syscall   #end of program