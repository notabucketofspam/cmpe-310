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


# ======================================
# and now, we shall so something, but idk what lol

mov $0x11, %ax
mov $0x00, %cx
bsr %ax, %cx # find the highest bit set
btr %cx, %ax # clear that bit


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

