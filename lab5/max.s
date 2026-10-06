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

.section .text
.global _start
_start:

# PLEASE GIVE UP
mov $60, %rax
mov $0,  %rdi
syscall
