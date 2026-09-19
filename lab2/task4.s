.section .bss 
.globl ram 
.lcomm ram, 256

.section .text
.globl fill_ram

fill_ram:
	movq $ram+0x50, %rdi
	#movq (0x0), (%rdi)
	# the accumulator
	movb $0x00, %al
	# the counter
	mov $0x01, %cl

	# this is our loop
	the_top:
	add %cl, %al
	inc %cl
	# B means "eleven"
	# and we are doing this because we are counting from one to ten
	cmpb $0x0B, %cl
	jne the_top

	movb %al, (%rdi)
	
	ret

.section .note.GNUStack, "", @progbits
