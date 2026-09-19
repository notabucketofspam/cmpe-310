.section .bss 
.globl ram 
.lcomm ram, 256

.section .text 
.globl fill_ram

fill_ram: 
	movb $0x00, %al
	movq $ram+0x50, %rdi
	movb %al, 0(%rdi)
	movb %al, 1(%rdi)
	movb %al, 2(%rdi)
	movb %al, 3(%rdi)
	movb %al, 4(%rdi)
	movb %al, 5(%rdi)
	movb %al, 6(%rdi)
	movb %al, 7(%rdi)
	movb %al, 8(%rdi)
	ret

.section .note.GNUStack, "", @progbits
