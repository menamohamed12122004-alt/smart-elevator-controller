	.file	"display.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SEG_Show,"ax",@progbits
.global	SEG_Show
	.type	SEG_Show, @function
SEG_Show:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(10)
	brsh .L1
	mov r30,r24
	ldi r31,0
	subi r30,lo8(-(SEG_LOOKUP_TABLE))
	sbci r31,hi8(-(SEG_LOOKUP_TABLE))
	ld r24,Z
	jmp HC595_SendByte
.L1:
/* epilogue start */
	ret
	.size	SEG_Show, .-SEG_Show
	.section	.rodata.SEG_LOOKUP_TABLE,"a"
	.type	SEG_LOOKUP_TABLE, @object
	.size	SEG_LOOKUP_TABLE, 10
SEG_LOOKUP_TABLE:
	.base64	"PwZbT2ZtfQd/bw=="
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
