.data
ask: .asciiz "please enter your number :"
output:
.asciiz "the second root is :"
number: .space 1000 #we can change 1000 if required
float1: .float 0.001
float2: .float 1.0
float3: .float 2.0
float4: .float 0.0

.text
li $v0,4
la $a0,ask
syscall  #show the enter text

li $v0,6
la $a0,number
syscall   #float input is stored in f0

lwc1 $f4,float1   #eps
lwc1 $f1,float2   #initial amount of r
lwc1 $f3,float4   #constant number 0
lwc1 $f5,float3   #constant number 2

loop:
mul.s $f2,$f1,$f1  #we store |r*r-x| in f2
sub.s $f2,$f2,$f0
abs.s $f2,$f2
c.lt.s  $f4,$f2  #condition of while
bc1f ex   #if eps is greater then or equal to |r*r-x| then the while loop is finished
div.s $f2,$f0,$f1  #if eps is less then |r*r-x| then we update the amount of r and keep it in f1
add.s $f2,$f2,$f1
div.s $f1,$f2,$f5
j loop

ex:
li $v0,4
la $a0,output
syscall  #show the output text
li $v0,2
add.s $f12,$f1,$f3
syscall #prints the second root
