.section .rodata
Numbers:
	.long 1
	.long 15
	.long 4
	.long 2
	.long 7
	.long 9
	.long 23
	.long 7
	.long 3
	.long 11
Array_length:
	.long 10

# copypasta from lab3 lol
psa_str1: .asciz "This is the biggest number:\n"
len_psa_str1 = . - psa_str1

.section .bss
.global output_str
.lcomm output_str, 0x100

.section .text
.global _start

_start:
	mov $1, %rax
	mov $1, %rdi
	mov $psa_str1, %rsi
	mov $len_psa_str1, %rdx
	syscall

	# clear the output string
	mov $0, %rcx
	top_clear3:
	movb $0x20, output_str(%rcx)
	inc %rcx
	cmp $0x100, %rcx
	jl top_clear3

	# reset some registers
	xorq %rax, %rax
	xorq %rbx, %rbx
	xorq %rcx, %rcx
	xorq %rdx, %rdx
	xorq %rdi, %rdi

# eax: the biggest number
# ebx the one we are comparing to eax
# ecx: the index in the for loop
# edx: the length of the array
# edi: our current byte offset in the array

	movl Array_length, %edx
readme:
	movl Numbers(%edi), %ebx
	cmpl %eax, %ebx
	jl too_small
	movl %ebx, %eax
too_small:
	addl $4, %edi
	incl %ecx
	cmpl %ecx, %edx
	jg readme

# writing it
	mov $output_str, %rdi # pointer for the string
	add $0x6, %rdi # move the pointer to the end of the string
	mov %rdi, %rsi # put it here
	dec %rsi # move him back a smidge
	movb $0x0A, (%rsi) # put a newline at the end of the string
	#this has our "actual" string size
	mov $0x01, %r8

	mov $0x0A, %rcx # put 10 in rcx (bc we are dividing by 10)
writeger:
	dec %rsi # look at the next place to put a char
	inc %r8 # the real length of the output string
	movq $0, %rdx # clear rdx (bc we are dividing)
	# divide rax by 10; 
	#remainder is in rdx, quotient is in rax
	div %rcx
	add $0x30,%rdx # this (sort of) converts it to ascii number
	movb %dl, (%rsi) # put this char in the output string
	test %rax, %rax # is rax zero?
	jnz writeger # the answer may surprise you

	# print it!
	mov $1, %rax # write
	mov $1, %rdi # stdout
	movq %r8, %rdx # len
	syscall

	# PLEASE GIVE UP
	mov $60, %rax
	mov $0,  %rdi
	syscall
