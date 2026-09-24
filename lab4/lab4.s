# this is conspicuously written on the whiteboard:
# sum(a, b)
# rdi-^  ^-rsi

.section .text
.global sum

# rdi has the array address
# rsi has the count
# assume that these are int16_t
sum:
  xor %rax, %rax
  movzwq (%rsi), %rcx
top:
  addw (%rdi), %ax
  inc %rdi
  inc %rdi
  dec %rcx
  jnz top
  ret

.section .note.GNUStack, "", @progbits
