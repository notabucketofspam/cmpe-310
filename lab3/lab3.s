.section .data
	please_str1: .asciz "gimme string #1, please:\n"
	len_str1 = . - please_str1 # idk how this works but it was in the powerpoint from lab
	please_str2: .asciz "aight bet. now... please gimme string #2:\n"
	len_str2 = . - please_str2
	stringman: .asciz "Mr. Stringman, string me a man:\n"
	len_stringman = . - stringman
	make_him_the: .asciz "Make him the cutest:\n"
	len_make_him_the = . - make_him_the

.section .bss
# this is where we store the user's strings
	.global input_str1
	.lcomm input_str1, 0x100
	.global input_str2
	.lcomm input_str2, 0x100
	.global output_str
	.lcomm output_str, 0x100
	.global some_buffers
	.lcomm some_buffers, 0x100

.section .text
.global _start

_start:
# first of all, i want to clear the buffers that we are gonna be using
	# clear string numero uno
	mov $0, %rcx
	top_clear1:
	movb $0, input_str1(%rcx)
	inc %rcx
	cmp $0x100, %rcx
	jl top_clear1
	# clear string number the second
	mov $0, %rcx
	top_clear2:
	movb $0, input_str2(%rcx)
	inc %rcx
	cmp $0x100, %rcx
	jl top_clear2
	# clear the output string
	mov $0, %rcx
	top_clear3:
	movb $0x20, output_str(%rcx)
	inc %rcx
	cmp $0x100, %rcx
	jl top_clear3
	# also, clear my buffers dearest
	mov $0, %rcx
	top_clear4:
	movb $0, some_buffers(%rcx)
	inc %rcx
	cmp $0x100, %rcx
	jl top_clear4

	# reset the counter
	mov $0, %rcx

# says to you, "please give me a string"
	mov $1, %rax # we are writing
	mov $1, %rdi # this is standard out
	mov $stringman, %rsi
	mov $len_stringman, %rdx
	syscall
	
	# give me a string
	mov $0, %rax # we are reading
	mov $0, %rdi # stdin
	# we gotta put it in input_str1
	mov $input_str1, %rsi
	mov $0x100, %rdx # how big is your string, sir?
	syscall

	# i pray to the segfault deity that this is going ok so far...

# the sequel to user input
	mov $1, %rax # write
	mov $1, %rdi # stdout
	mov $make_him_the, %rsi
	mov $len_make_him_the, %rdx
	syscall

	# man car door hook hand
	mov $0, %rax # read
	mov $0, %rdi # stdin
	# I would put your input_str2 right in the machine
	mov $input_str2, %rsi
	mov $0x100, %rdx
	syscall

# now, we need to get the length of each string
	# to do this, im gonna scan until i get a null
	mov $0, %rcx # the counter
	mov $input_str1, %rdi # the address of the string
	mov $0, %al # the byte that we are looking for
length_loop1:
	cmpb %al, (%rdi) # compare the byte at the address to the null byte
	je end_length_loop1
	inc %rcx
	inc %rdi
	jmp length_loop1
end_length_loop1:
	# store it in my buffers dearest
	mov %rcx, some_buffers
	# copy-paste the above, but for the second string
	mov $0, %rcx
	mov $input_str2, %rdi
	mov $0, %al
length_loop2:
	cmpb %al, (%rdi)
	je end_length_loop2
	inc %rcx
	inc %rdi
	jmp length_loop2
end_length_loop2:
	mov $0x10, %rdi
	# also store this guy
	mov %rcx, some_buffers(%rdi)

	# gotta compare the lengths, and then store the lowest one
	movq some_buffers, %rax
	add $0x10, %rdi
	cmp %rax, %rcx
	jae str2_longest
	jl str1_longest
str1_longest:
	# we gotta take rcx and put him in my beloved buffers
	dec %rcx # there may be a newline
	movq %rcx, some_buffers(%rdi)
	jmp done_with_that_part
str2_longest:
	# rax has my length
	dec %rax
	movq %rax, some_buffers(%rdi)
	jmp done_with_that_part
done_with_that_part:

# WHAT IS IN MY BUFFERS DEAREST:
# 0x00 the length of string 1
# 0x10 length string 2
# 0x20 the length of the shorter string (he probs feels inadequate)
# 0x30 the actual Hamming length

# HOW DO WE READ SOMETHING OUT OF BUFFER AND INTO RAX???
# where $OFFSET is one of those offsets above:
# mov $OFFSET, %rdi
# mov some_buffers(%rdi), %rax

# ======================================
# and now, we shall so something with Hamming girth

	mov $0x20, %rdi 
	movq some_buffers(%rdi), %rbx # put the shortest length into rbx
	xorq %rax, %rax # rax is gonna hold girth while we count
	xorq %rcx, %rcx # rcx has the current byte count, to make sure that we dont do more than the length

measuring_his_girth:
	cmp %rcx, %rbx # "are we there yet?"
	je we_have_his_girth
	jne still_measuring_it
still_measuring_it: # this is the start of the loop (kinda)

	# r8 has a byte from string 1, and then has the xorb result
	# r9 has byte from string 2
	# r10 is holding the bit position that im using for bsf
	xorq %r8, %r8
	xorq %r9, %r9
	xorq %r10, %r10
	# i looked it up, and the "z" in "movzbq" means
	# "fill that guy with zeroes"
	movzbq input_str1(%rcx), %r8
	movzbq input_str2(%rcx), %r9
	xorq %r8, %r9

we_are_scanning:
	bsfq %r9, %r10
	jz oops_all_zeros

we_do_indeed_have_a_bit_here:
	inc %rax # accumulate
	btrq %r10, %r9 # reset this bit
	jmp we_are_scanning

oops_all_zeros:
	inc %rcx # onto the next byte
	jmp measuring_his_girth

we_have_his_girth: # this is the end of the loop
	mov $0x30, %rdi
	mov %rax, some_buffers(%rdi) # i was saving that one for later

# TEST: print out that length, to make sure that im doing this right
# we know that the length of the written portion cant be more than 3
	mov $0x30, %rdi # this is the hamming number
	movq some_buffers(%rdi), %rax # move the length into rax (bc dividing)

	mov $output_str, %rdi # pointer for the string
	add $0x4, %rdi # move the pointer to the end of the string
	mov %rdi, %rsi # put it here
	dec %rsi # move him back a smidge
	movb $0x0A, (%rsi) # put a newline at the end of the string
	dec %rsi # move the pointer back to where we want to put the lowest digit

	mov $0x0A, %rcx # put 10 in rcx (bc we are dividing by 10)
writeger:
	movq $0, %rdx # clear rdx (bc we are dividing)
	# divide rax by 10; 
	#remainder is in rdx, quotient is in rax	
	div %rcx
	add $0x30,%rdx # this (sort of) converts it to ascii number
	movb %dl, (%rsi) # put this char in the output string
	dec %rsi # look at the next place to put a char
	test %rax, %rax # is rax zero?
	jnz writeger # the answer may surprise you

	# print it!
	mov $1, %rax # write
	mov $1, %rdi # stdout
	mov $output_str, %rsi # buf
	mov $0x5, %rdx # len
	syscall


# this is equivalent to give up
mov $60, %rax
mov $0,  %rdi
syscall

