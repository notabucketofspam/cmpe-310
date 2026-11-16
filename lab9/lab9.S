# from the 8255 datasheet, page 7:
# if we want to set all of the ports to output,
# and activate MODE 0, we can do 0b10000000

# here's the table of SSD bit-patterns:
# n : 0bxgfedcba
# S : 0b01101101
# H : 0b01110110
# E : 0b01111001

.section .data

.section .rodata
	ppi_a: .word 0x640 # 8255 port A
	ppi_b: .word 0x641 # 8255 port B
	ppi_c: .word 0x642 # 8255 port C
	ppi_x: .word 0x643 # 8255 control
	ppi_x_allout: .word 0x80 # set 'em all to output

# the SSD places
	dig_0: .word 0x01
	dig_1: .word 0x02
	dig_2: .word 0x04
	dig_3: .word 0x08
	dig_4: .word 0x10
	dig_5: .word 0x20
	dig_6: .word 0x40
	dig_7: .word 0x80

# the SSD letters
	ssd_S: .word 0b01101101
	ssd_H: .word 0b01110110
	ssd_E: .word 0b01111001
	ssd__: .word 0b00000000
	
.section .text
# see "Mastering GAS," page 194, for more information about macros
# NOTE: \() is a separator for the macro parsing
.macro ssd_write dat_7, dat_6, dat_5, dat_4, dat_3, dat_2, dat_1, dat_0
	.irp index 7, 6, 5, 4, 3, 2, 1, 0
		movw dig_\index, %di
		movw \dat_\()\index, %si
		call ssd_out
	.endr
.endm

.global _start
_start:
	movw ppi_x, %dx # put command reg in dx
	xorw %ax, %ax # clear ax
	movw ppi_x_allout, %ax # gonna set the 8255 to all output
	outb %al, %dx

	jmp kms

# @param {word} di the SSD place to write to
# @param {word} si the SSD letter to write
ssd_out:
	# write the SSD place (controlled by port A)
	movw %di, %ax
	movw ppi_a, %dx
	outb %al, %dx
	# write the SSD letter (controlled by port B)
	movw %si, %ax
	movw ppi_b, %dx
	outb %al, %dx
	ret

kms:	
	# clear cx
	xorw %cx, %cx

	# we are using cx as a ttl counter
	#00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18
	# _  _  _  _  _  _  _  _  S  H  E  _  _  _  _  _  _  _  _
time_00:
	movw dig_7, %di
	movw ssd__, %si
	call ssd_out
	call cx_ttl


cx_ttl:
	dec	%cx
	jcxz cx_dead
	ret

cx_dead:
	addw $0x02, %sp # need to clean up the stack pointer because we jmp'ed from cx_ttl
