.data
array: .space 100   
size: .asciiz "Insert the array size : "
int: .asciiz "Insert the array elements,one per line :\n "
space: .asciiz " "
option: .asciiz "Choce your sort option :\n1 - Selection sort\n2 - Bubble sort\n--> "
final: .asciiz "The sorted array is : \n "

msg_inputList:      .asciiz "\nPlease enter positive numbers in ascending order and a 0 to terminate\n"
msg_searchList:     .asciiz "Please enter a number to initSearch for\n"
msg_YES:            .asciiz " - YES\n"
msg_NO:             .asciiz " - NO\n"

.text

main:
la $a0,option                       
li $v0,4
syscall

li $v0,5
syscall
beq $v0,1,selectionSort
beq $v0,2,bubble

bubble:
la $a0,size                       
li $v0,4
syscall

li $v0,5
syscall

move $s1, $v0                      
sub $s1,$s1,1                       
la $a0,int                     
li $v0,4
syscall
addint:

li $v0,5        
syscall

move $t3,$v0                        
add $t1,$zero,$zero                 
sll $t1,$t0,2                       

sw $t3,array ( $t1 )                
addi $t0,$t0,1                      
slt $t1,$s1,$t0                     
beq $t1,$zero,addint                
	
la $a0,array                        
addi $a1,$s1,1                      

jal bubble_sort                            

la $a0,final 
li $v0,4
syscall

la $t0,array                        
li $t1,0                            

print:
lw $a0,0($t0)                       
li $v0,1
syscall
#space
la $a0,space
li $v0,4
syscall
addi $t0,$t0,4                      
addi $t1,$t1,1                      
slt $t2,$s1,$t1                     
beq $t2,$zero,print                 
j binarrySearch
bubble_sort:
li $t0,0                            

loop1:

addi $t0,$t0,1                      
bgt $t0,$a1,end                  
add $t1,$a1,$zero                   

loop2:

bge $t0,$t1,loop1                  

sub $t1,$t1,1                      

sll $t4, $t1, 2                     
sub $t3, $t4, 4                    

add $t4,$t4,$a0                     
add $t3,$t3,$a0                     
lw $t5,0($t4)
lw $t6,0($t3)

swap:
bgt $t5,$t6,loop2                   
sw $t5,0($t3)                       
sw $t6,0($t4)
j loop2

end:
jr $ra





selectionSort:
		la	$a0,size		# Print of size
		li	$v0, 4			#
		syscall				#

		li	$v0, 5			# Get the array size(n) and
		syscall				# and put it in $v0
		move	$s2, $v0		# $s2=n
		sll	$s0, $v0, 2		# $s0=n*4
		sub	$sp, $sp, $s0		# This instruction creates a stack
						# frame large enough to contain
						# the array
		la	$a0, int		#
		li	$v0, 4			# Print of int
		syscall				#

		move	$s1, $zero		# i=0
for_get:	bge	$s1, $s2, exit_get	# if i>=n go to exit_for_get
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $t0, $sp		# $t1=$sp+i*4
		li	$v0, 5			# Get one element of the array
		syscall				#
		sw	$v0, 0($t1)		# The element is stored
						# at the address $t1
		la	$a0, space
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	for_get
exit_get:	move	$a0, $sp		# $a0=base address af the array
		move	$a1, $s2		# $a1=size of the array
		jal	isort			# isort(a,n)
						# In this moment the array has been 
						# sorted and is in the stack frame 
		la	$a0, final		# Print of str3
		li	$v0, 4
		syscall

		move	$s1, $zero		# i=0
for_print:	bge	$s1, $s2, exit_print	# if i>=n go to exit_print
		sll	$t0, $s1, 2		# $t0=i*4
		add	$t1, $sp, $t0		# $t1=address of a[i]
		lw	$a0, 0($t1)		#
		li	$v0, 1			# print of the element a[i]
		syscall				#

		la	$a0, space
		li	$v0, 4
		syscall
		addi	$s1, $s1, 1		# i=i+1
		j	for_print
exit_print:	add	$sp, $sp, $s0		# elimination of the stack frame 
              
		j binarrySearch
		
		
# selection_sort
isort:		addi	$sp, $sp, -20		# save values on stack
		sw	$ra, 0($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)
		sw	$s2, 12($sp)
		sw	$s3, 16($sp)

		move 	$s0, $a0		# base address of the array
		move	$s1, $zero		# i=0

		sub	$s2, $a1, 1		# lenght -1
isort_for:	bge 	$s1, $s2, isort_exit	# if i >= length-1 -> exit loop
		
		move	$a0, $s0		# base address
		move	$a1, $s1		# i
		move	$a2, $s2		# length - 1
		
		jal	mini
		move	$s3, $v0		# return value of mini
		
		move	$a0, $s0		# array
		move	$a1, $s1		# i
		move	$a2, $s3		# mini
		
		jal	swap1

		addi	$s1, $s1, 1		# i += 1
		j	isort_for		# go back to the beginning of the loop
		
isort_exit:	lw	$ra, 0($sp)		# restore values from stack
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		lw	$s2, 12($sp)
		lw	$s3, 16($sp)
		addi	$sp, $sp, 20		# restore stack pointer
		jr	$ra			# return


# index_minimum routine
mini:		move	$t0, $a0		# base of the array
		move	$t1, $a1		# mini = first = i
		move	$t2, $a2		# last
		
		sll	$t3, $t1, 2		# first * 4
		add	$t3, $t3, $t0		# index = base array + first * 4		
		lw	$t4, 0($t3)		# min = v[first]
		
		addi	$t5, $t1, 1		# i = 0
mini_for:	bgt	$t5, $t2, mini_end	# go to min_end

		sll	$t6, $t5, 2		# i * 4
		add	$t6, $t6, $t0		# index = base array + i * 4		
		lw	$t7, 0($t6)		# v[index]

		bge	$t7, $t4, mini_if_exit	# skip the if when v[i] >= min
		
		move	$t1, $t5		# mini = i
		move	$t4, $t7		# min = v[i]

mini_if_exit:	addi	$t5, $t5, 1		# i += 1
		j	mini_for

mini_end:	move 	$v0, $t1		# return mini
		jr	$ra


# swap routine
swap1:		sll	$t1, $a1, 2		# i * 4
		add	$t1, $a0, $t1		# v + i * 4
		
		sll	$t2, $a2, 2		# j * 4
		add	$t2, $a0, $t2		# v + j * 4

		lw	$t0, 0($t1)		# v[i]
		lw	$t3, 0($t2)		# v[j]

		sw	$t3, 0($t1)		# v[i] = v[j]
		sw	$t0, 0($t2)		# v[j] = $t0

		jr	$ra 









binarrySearch:
    li          $v0, 4                  # syscall 4 (print_str)
    la          $a0, msg_inputList      # load the input message
    syscall                             # execute message print

    li          $v0, 9                  # syscall 9 (sbrk)
    la          $a0, 4                  # 4 bytes allocated for ints
    syscall                             # execute memory allocation
    move        $s1, $v0                # store the start address of heap

    li          $s4, 0                  # set list items counter to 0
    
#===============================================================#

inputList:
    li          $v0, 5                  # syscall 5 (read_int)
    syscall                             # execute int reading
    move        $t1, $v0                # store int in $t1
    blez        $v0, initSearchList     # start search items input if 0 is input

    li          $v0, 9                  # syscall 9 (sbrk)
    la          $a0, 4                  # 4 bytes allocated for ints
    syscall                             # execute memory allocation

    li          $t0, 4                  # 4 bytes for an int
    mul         $t0, $s4, $t0           # length of the input storage address space
    add         $t0, $t0, $s1           # calculate end of address space
    move        $s5, $t0                # store end of address space
    sw          $t1, ($t0)              # store the input on the heap
    addi        $s4  $s4, 1             # counter++
    
    j           inputList               # take next input
    
#===============================================================#

initSearchList:
    li          $v0, 4                  # syscall 4 (print_str)
    la          $a0, msg_searchList     # load the search items input message
    syscall                             # execute message print

    li          $s2, 0                  # set search items counter to 0
    
#===============================================================#

searchList:
    li          $v0, 5                  # syscall 5 (read_int)
    syscall                             # execute int reading
    move        $t1, $v0                # move int to $t1
    blez        $v0, initSearch         # start search if 0 was entered

    li          $v0, 9                  # syscall 4 (sbrk)
    la          $a0, 4                  # 4 bytes allocated for ints
    syscall                             # execute memory allocation

    li          $t0, 4                  # 4 bytes for an int
    add         $t2, $s4, $s2           # length of the list is counter1 + counter 2
    mul         $t0, $t2, $t0           # length of the input storage address space
    add         $t0, $t0, $s1           # calculate end of address spaces
    move        $s3, $t0                # store end of address space
    sw          $t1, ($t0)              # store input on the heap
    addi        $s2, $s2, 1             # counter++

    j           searchList              # take next input
    
#===============================================================#

initSearch:
    move        $t6, $s5                # store end address of input items
    move        $t7, $s3                # store end address of search items
    
#===============================================================#

search:                                                  
    move        $t5, $s5                # store end address of input items
    beq         $t7, $t6, exit          # if there's nothing to search, exit
    
#===============================================================#

splitStep:

    move        $s6, $s1                # min is the start address of the heap
    move        $s7, $s5                # max is the end address of the heap
    move        $t0, $s4                # store the input list counter
    move        $t9, $s4                # store the input list counter
    li          $v1, 2                  # store 2
    div         $t9, $v1                # divide the counter by 2
    mflo        $t9                     # move result of division to $t9
    add         $t9, $t9, $v1
    
#===============================================================#

checkHigher:
    li          $v1, 2                  # store 2
    div         $t0, $v1                # divide the counter by 2
    mflo        $v1                     # store the division result
    mflo        $t0                     # move the counter out

    blez        $t0, remainderStep      # counter is at 0, check remainer step
    
    j           loopCheck               # run the looping check
    
#===============================================================#

checkLower:
    li          $v1, 2                  # store 2
    div         $t0, $v1                # divide the counter by 2
    mflo        $v1                     # store the division result
    mflo        $t0                     # move the counter out
    mfhi        $t1                     # move Hi to $t1

    blez        $t0, failStep           # If the counter equals zero and so does the division remainder then print no
    
    j           loopCheck               # run the looping check
    
#===============================================================#

failStep:
    blez        $t1, no                 # failed, return no
    
#===============================================================#

loopCheck:
    beq         $s6, $s7, no            # max and min are now the same, didn't find the number
    blez        $t9, no                 # lower counter is 0, we didn't find the number

    mul         $v1, $t0, 4             # multiply counter by 4 to get the address space length
    add         $t4, $s6, $v1           # add the address space length to get the end address

    lw          $a1, ($t7)              # get value of $t7
    lw          $a2, ($t4)              # get value of $t4

    sub         $t9, $t9, 1             # counter--

    beq         $a2, $a1, yes           # we found it! yay
    sub         $t1, $a1, $a2           # is it greater than or less than the point?
    blez        $t1, searchLower        # it's less than, run the search on the lower segment
    bgez        $t1, searchHigher       # it's greater than, run the search on the higher segment
    
#===============================================================#

remainderStep:
    mfhi        $t8                     # store result
    bgtz        $t8, incrementCounter   # there's a remainder, move on to deal with it
    j           loopCheck               # no remainder, run the search
    
#===============================================================#

incrementCounter:
    add         $t0, $v1, $t8           # counter++
    
    j           loopCheck               # run the search
    
#===============================================================#

searchLower:
    move        $s7, $t4                # max point is now the old midpoint
    
    j           checkLower              # search lower segment
    
#===============================================================#

searchHigher:
    move        $s6, $t4                # min point is now the old max
    
    j           checkHigher             # search higher segment
    
#===============================================================#

restartSearch:
    sub         $t7, $t7, 4             # counter - 4
    
    j           search                  # run search
    
#===============================================================#

yes:
    li          $v0, 1                  # syscall 1 (print_int)
    lw          $a0, ($t4)              # load current int
    syscall                             # execute int printing

    li          $v0, 4                  # syscall 4 (print_str)
    la          $a0, msg_YES            # load yes message
    syscall                             # execute message printing

    j           restartSearch           # run search on the rest of the search items
    
#===============================================================#

no:
    li          $v0, 1                  # syscall 1 (print_int)
    lw          $a0, ($t7)              # load current int
    syscall                             # execute int printing

    li          $v0, 4                  # syscall 4 (print_str)
    la          $a0, msg_NO             # load no message
    syscall                             # execute message printing
    
    j           restartSearch           # run search on the rest of the search items
    
#===============================================================#

exit:
    li          $v0, 10                 # syscall 10 (exit)
    syscall                             # execute exit
