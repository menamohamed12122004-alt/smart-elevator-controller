	.file	"faultlog.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.FLG_Init,"ax",@progbits
.global	FLG_Init
	.type	FLG_Init, @function
FLG_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts g_u8Head,__zero_reg__
	sts g_u8Count,__zero_reg__
	ldi r30,lo8(g_sFaultBuffer)
	ldi r31,hi8(g_sFaultBuffer)
.L2:
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+2,__zero_reg__
	std Z+3,__zero_reg__
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
	std Z+6,__zero_reg__
	std Z+7,__zero_reg__
	adiw r30,8
	ldi r24,hi8(g_sFaultBuffer+128)
	cpi r30,lo8(g_sFaultBuffer+128)
	cpc r31,r24
	brne .L2
/* epilogue start */
	ret
	.size	FLG_Init, .-FLG_Init
	.section	.text.FLG_Append,"ax",@progbits
.global	FLG_Append
	.type	FLG_Append, @function
FLG_Append:
	push r16
	push r17
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	sbiw r24,0
	breq .L4
	lds r30,g_u8Head
	mov r26,r30
	ldi r27,0
	ldi r21,lo8(8)
	mul r30,r21
	movw r30,r0
	clr __zero_reg__
	subi r30,lo8(-(g_sFaultBuffer))
	sbci r31,hi8(-(g_sFaultBuffer))
	st Z,r24
	std Z+1,r25
	std Z+2,r22
	std Z+3,r20
	std Z+4,r16
	std Z+5,r17
	std Z+6,r18
	std Z+7,r19
	movw r18,r26
	subi r18,-1
	sbci r19,-1
	andi r18,15
	sts g_u8Head,r18
	lds r24,g_u8Count
	cpi r24,lo8(16)
	brsh .L4
	subi r24,lo8(-(1))
	sts g_u8Count,r24
.L4:
/* epilogue start */
	pop r17
	pop r16
	ret
	.size	FLG_Append, .-FLG_Append
	.section	.rodata.FLG_Dump.str1.1,"aMS",@progbits,1
.LC0:
	.string	"\r\n--- FAULT LOG DUMP ---\r\n"
.LC1:
	.string	"Fault Code: "
.LC2:
	.string	" | Floor: "
.LC3:
	.string	"\r\n"
.LC4:
	.string	"----------------------\r\n"
	.section	.text.FLG_Dump,"ax",@progbits
.global	FLG_Dump
	.type	FLG_Dump, @function
FLG_Dump:
	push r16
	push r17
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 3 */
.L__stack_usage = 3
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	call UART_SendString
	ldi r28,0
.L9:
	lds r24,g_u8Count
	cp r28,r24
	brlo .L10
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
/* epilogue start */
	pop r28
	pop r17
	pop r16
	jmp UART_SendString
.L10:
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	call UART_SendString
	ldi r24,lo8(8)
	mul r28,r24
	movw r16,r0
	clr __zero_reg__
	subi r16,lo8(-(g_sFaultBuffer))
	sbci r17,hi8(-(g_sFaultBuffer))
	movw r30,r16
	ld r24,Z
	subi r24,lo8(-(48))
	call UART_SendByte
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call UART_SendString
	movw r30,r16
	ldd r24,Z+2
	subi r24,lo8(-(48))
	call UART_SendByte
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	call UART_SendString
	subi r28,lo8(-(1))
	rjmp .L9
	.size	FLG_Dump, .-FLG_Dump
	.section	.bss.g_u8Count,"aw",@nobits
	.type	g_u8Count, @object
	.size	g_u8Count, 1
g_u8Count:
	.zero	1
	.section	.bss.g_u8Head,"aw",@nobits
	.type	g_u8Head, @object
	.size	g_u8Head, 1
g_u8Head:
	.zero	1
	.section	.bss.g_sFaultBuffer,"aw",@nobits
	.type	g_sFaultBuffer, @object
	.size	g_sFaultBuffer, 128
g_sFaultBuffer:
	.zero	128
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
.global __do_clear_bss
