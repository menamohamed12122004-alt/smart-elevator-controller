	.file	"calls165.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.BTN_Init,"ax",@progbits
.global	BTN_Init
	.type	BTN_Init, @function
BTN_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call HC165_Init
	sts g_u16CurrentButtonStates,__zero_reg__
	sts g_u16CurrentButtonStates+1,__zero_reg__
/* epilogue start */
	ret
	.size	BTN_Init, .-BTN_Init
	.section	.text.BTN_Scan,"ax",@progbits
.global	BTN_Scan
	.type	BTN_Scan, @function
BTN_Scan:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+1,__zero_reg__
	std Y+2,__zero_reg__
	movw r24,r28
	adiw r24,1
	call HC165_Read16Bits
	or r24,r25
	brne .L2
	ldd r24,Y+1
	ldd r25,Y+2
	sts g_u16CurrentButtonStates,r24
	sts g_u16CurrentButtonStates+1,r25
.L2:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	BTN_Scan, .-BTN_Scan
	.section	.text.BTN_Pressed,"ax",@progbits
.global	BTN_Pressed
	.type	BTN_Pressed, @function
BTN_Pressed:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(16)
	brsh .L6
	lds r18,g_u16CurrentButtonStates
	lds r19,g_u16CurrentButtonStates+1
	rjmp 2f
	1:
	lsr r19
	ror r18
	2:
	dec r24
	brpl 1b
	mov r24,r18
	andi r24,1<<0
	ret
.L6:
	ldi r24,0
/* epilogue start */
	ret
	.size	BTN_Pressed, .-BTN_Pressed
	.section	.bss.g_u16CurrentButtonStates,"aw",@nobits
	.type	g_u16CurrentButtonStates, @object
	.size	g_u16CurrentButtonStates, 2
g_u16CurrentButtonStates:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
