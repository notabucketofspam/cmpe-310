# from the 8255 datasheet, page 7:
# if we want to set all of the ports to output,
# and activate MODE 0, we can do 0b10000000

# here's the table of SSD bit-patterns:
# n : 0bxgfedcba
# S : 0b01101101
# H : 0b01110110
# E : 0b01111001

# some controls for the Intel 8255A
.equ ppi_a, 0x640 # 8255 port A
.equ ppi_b, 0x641 # 8255 port B
.equ ppi_c, 0x642 # 8255 port C
.equ ppi_x, 0x643 # 8255 control
.equ ppi_x_allout, 0x80 # set 'em all to output

# the SSD places
.equ dig_0, 0x01
.equ dig_1, 0x02
.equ dig_2, 0x04
.equ dig_3, 0x08
.equ dig_4, 0x10
.equ dig_5, 0x20
.equ dig_6, 0x40
.equ dig_7, 0x80

# the SSD letters
.equ ssd_S, 0b01101101
.equ ssd_H, 0b01110110
.equ ssd_E, 0b01111001
.equ ssd__, 0b00000000
	
# at what point in the SSD state LUT do we want to wrap
.equ scroll_max, 11
	
.section .rodata
# a LUT (look up table) that I'm using to scroll the message
ssd_lut:
	.byte ssd__, ssd__, ssd__, ssd__ # 0:3
	.byte ssd__, ssd__, ssd__, ssd__ # 4:7
	.byte ssd_S, ssd_H, ssd_E, ssd__ # 8:11
	.byte ssd__, ssd__, ssd__, ssd__ # 12:15
	.byte ssd__, ssd__, ssd__, ssd__ # 16:19

.section .data
nowtime: .quad 0x00 # very recent time
lastime: .quad 0x00 # almost-recent time
scroll_state: .byte 0x00 # where you at

.section .text
# see "Mastering GAS," page 194, for more information about macros
.macro ssd_write offset
	pushq %r15 # save r15
	leaq ssd_lut(%rip), %r15 # load the ssd_lut's memaddr into r15
	addq \offset, %r15 # add the offset (ie, scroll_state) to r15
	.irp ix 7, 6, 5, 4, 3, 2, 1, 0 # basically a for loop
		movw $dig_\ix, %di # the digit we want to write to
		movzbw (7 - \ix)(%r15), %si # the data from ssd_lut that we want to write
		call ssd_out
	.endr
	popq %r15 # restore r15
.endm

# for more info about linux syscall register clobbering on x86_64, see:
# https://man7.org/linux/man-pages/man2/syscall.2.html
# https://intel.github.io/SDM/instruction/SYSCALL.html
# https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
.macro reg_save
	# this one is just for the flag register
	pushfq
	# these are from the syscall man page
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %r10
	pushq %r8
	pushq %r9
	# these are from the Intel page
	pushq %r11
	pushq %rcx
	# these are just for safety
	pushq %rax
.endm
# same as the above macro, but in reverse order
.macro reg_load
	popq %rax
	popq %rcx
	popq %r11
	popq %r9
	popq %r8
	popq %r10
	popq %rdx
	popq %rsi
	popq %rdi
	popfq
.endm

# @param {word} di the SSD place to write to
# @param {word} si the SSD letter to write
# @returns {none}
ssd_out:
	# write the SSD place (controlled by port A)
	movw %di, %ax
	movw $ppi_a, %dx
	outb %al, %dx
	# write the SSD letter (controlled by port B)
	movw %si, %ax
	movw $ppi_b, %dx
	outb %al, %dx
	ret

# stores the current system time to memory
# @param {none}
# @returns {none}
# @effects {quad} nowtime holds the system time
get_time:
	reg_save
	movq $201, %rax
	leaq nowtime(%rip), %rdi
	syscall
	reg_load
	ret

# we call this once at startup
# @param {none}
# @returns {none}
# @effects {quad} lastime the system time that we are gonna be comparing against
init_get_time:
	reg_save
	movq $201, %rax # syscall for getting the time
	leaq lastime(%rip), %rdi # load the mem addr to store said time
	syscall
	reg_load
	ret

# check the time to see if we need to update the state
# @param {none}
# @returns {none}
# @effects {byte} scroll_state may change slightly
cmp_time:
	reg_save
	call get_time
	movq lastime(%rip), %rax
	cmpq %rax, nowtime(%rip)
	jg cmp_time_march # the unstoppable march of time
	jmp cmp_time_done # time hasn't change
	cmp_time_march:
	# we end up here when the time changes
	movq nowtime(%rip), %rax
	movq %rax, lastime(%rip) # update lastime to match nowtime
	xorq %rax, %rax # clear rax
	incb scroll_state(%rip) # we advance the state
	cmpb scroll_state(%rip), $scroll_max
	je cmp_time_wrap # jump if it's time to wrap
	jmp cmp_time_done # goto end if not
	cmp_time_wrap:
	movb $0x00, scroll_state(%rip) # reset scroll_state
	cmp_time_done:
	reg_load
	ret

.global _start
_start:
	call init_get_time

	movw $ppi_x, %dx # put command reg in dx
	xorw %ax, %ax # clear ax
	movw $ppi_x_allout, %ax # gonna set the 8255 to all output
	outb %al, %dx # write to the 8255

	top_o_the_mornin:
		ssd_write scroll_state(%rip) # write to all eight digits on the SSD
		call cmp_time # check to see if time has changed
	jmp top_o_the_mornin # repeat

	# PLEASE GIVE UP
	movq $60, %rax
	xorq %rd1, %rdi
	syscall
