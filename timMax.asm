	.data
		readArraySize: .asciiz "Input your array size: "
		inputArray: .asciiz "Input element of array: "
		newLine: .asciiz "\n"
		max: .asciiz "\nMax is: "
		inputDone: .asciiz "Finish array\n"
	.text
main:
		# print readArraySize
		li $v0, 4
		la $a0, readArraySize
		syscall
		
		#---------------------------------------------------------------
		# get array size, store in $v0
		li $v0, 5
		syscall
		
		# $s2 = $v0 = n
		move $s2, $v0
		
		# $s0 = n * 4
		sll $s0, $v0, 2 
		
		# create a stack to store array
		sub $sp, $sp, $s0
		
		#---------------------------------------------------------------
		# print inputArray
		li $v0, 4
		la $a0, inputArray
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall
			
		#Stop program => exit
		#li $v0, 10
		#syscall
	
	#------------------------
	# input elements to array
	# -----------------------
	move $s1, $zero # init $s1 = 0 <=> i = 0
	# Now we have an array with 
	# 			n = $s2 ___ i = $s1
for_input:
		bge $s1, $s2, exit_input # check if i >= n then exit
		
		sll $t0, $s1, 2 # $t0 = i * 4
		add $t1, $t0, $sp
		
		# input element
		li $v0, 5
		syscall
		
		#element stored at address $t1
		sw $v0, 0($t1)
		
		# print newLine
		li $v0, 4
		la $a0, newLine
		syscall
		
		# i++
		addi $s1, $s1, 1 
		j for_input
exit_input:
		move $a0, $sp
		move $a1, $s2
		jal maxi
		
		#li $v0, 4
		#la $a0, inputDone
		#syscall
		
		li $v0, 10
		syscall	
		
	#--------------------------------
	# Find max
	#--------------------------------
maxi:
	# CAUTION !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	# HERE you repace $sp with your $s0 to save the address of array
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	move $t0, $sp # beginning of an array
	#move $t2, $s2 # $t2 = $s2 = length
	
	#sll $t3, $t1, 2	# first * 4
	#add $t3, $t3, $t0 # index = base array + first * 4		
	lw  $s3, 0($t0)	# $t4 = max = array[0]
	
	#move $a2, $t4 # $a2 = array[0]		
	
	move $s1, $zero # i = 0
find_max:
	bgt $s1, $s2, exit_max
	
	sll $t6, $s1, 2	 # i * 4
	add $t6, $t6, $t0 # index =  i * 4 + base array	
	lw $t7, 0($t6) # v[index]

	ble $t7, $s3, jumpMax # skip the if when v[i] < max
		
	move $s3, $t7 # max = v[i]
		
jumpMax:
	addi $s1, $s1, 1 # i += 1 
	j find_max
		
exit_max:
	li $v0, 4
	la $a0, max
	syscall	
	
	# Max have been saved in $s3
	# print $s3 <=> max	
	li $v0, 1
	move $a0, $s3
	syscall		
			
	jr $ra
		
		
	#----------------------------------
	#This is a function to print array	
	#----------------------------------
	
	# print element in array
	# -----------------------
	move $s1, $zero # init $s1 = 0 <=> i = 0
for_print:
		bge $s1, $s2, exit_print # if i > n then exit
		sll $t0, $s1, 2
		
		add $t1, $sp, $t0
		
		li $v0, 1
		lw $a0, 0($t1)
		syscall
		
		# print newLine
		li $v0, 4
		la $a0, newLine
		syscall
		
		# i++
		addi $s1, $s1, 1 
		j for_print
exit_print:
		add $sp, $sp, $s0
		
		li $v0, 10
		syscall
