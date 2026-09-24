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
top:
  addw (%rdi), %ax
  inc %rdi
  inc %rdi
  dec %rsi
  jnz top
  ret

.section .note.GNUStack, "", @progbits
