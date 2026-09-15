	.file	"EXTI.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.EXTI_EnableChannel,"ax",@progbits
.global	EXTI_EnableChannel
	.type	EXTI_EnableChannel, @function
EXTI_EnableChannel:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(1)
	breq .L2
	cpi r24,lo8(2)
	breq .L3
	cpse r24,__zero_reg__
	rjmp .L6
	in r24,0x3b
	ori r24,lo8(64)
.L7:
	out 0x3b,r24
	ldi r24,0
	ldi r25,0
	ret
.L2:
	in r24,0x3b
	ori r24,lo8(-128)
	rjmp .L7
.L3:
	in r24,0x3b
	ori r24,lo8(32)
	rjmp .L7
.L6:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_EnableChannel, .-EXTI_EnableChannel
	.section	.text.EXTI_Init,"ax",@progbits
.global	EXTI_Init
	.type	EXTI_Init, @function
EXTI_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(3)
	brsh .L15
	cpi r24,lo8(1)
	brsh .L10
	cbi 0x11,2
	sbi 0x12,2
	in r25,0x35
	andi r25,lo8(-4)
	out 0x35,r25
	in r25,0x35
	andi r22,lo8(3)
.L16:
	or r25,r22
	out 0x35,r25
.L11:
	call EXTI_EnableChannel
	in r24,__SREG__
	ori r24,lo8(-128)
	out __SREG__,r24
	ldi r24,0
	ldi r25,0
	ret
.L10:
	brne .L12
	cbi 0x11,3
	sbi 0x12,3
	in r25,0x35
	andi r25,lo8(-13)
	out 0x35,r25
	in r25,0x35
	lsl r22
	lsl r22
	andi r22,lo8(12)
	rjmp .L16
.L12:
	cpi r22,lo8(2)
	brne .L13
	in r25,0x34
	andi r25,lo8(-65)
.L17:
	out 0x34,r25
	rjmp .L11
.L13:
	cpi r22,lo8(3)
	brne .L15
	in r25,0x34
	ori r25,lo8(64)
	rjmp .L17
.L15:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_Init, .-EXTI_Init
	.section	.text.EXTI_DisableChannel,"ax",@progbits
.global	EXTI_DisableChannel
	.type	EXTI_DisableChannel, @function
EXTI_DisableChannel:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(1)
	breq .L19
	cpi r24,lo8(2)
	breq .L20
	cpse r24,__zero_reg__
	rjmp .L23
	in r24,0x3b
	andi r24,lo8(-65)
.L24:
	out 0x3b,r24
	ldi r24,0
	ldi r25,0
	ret
.L19:
	in r24,0x3b
	andi r24,lo8(127)
	rjmp .L24
.L20:
	in r24,0x3b
	andi r24,lo8(-33)
	rjmp .L24
.L23:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_DisableChannel, .-EXTI_DisableChannel
	.section	.text.EXTI_SetCallBack,"ax",@progbits
.global	EXTI_SetCallBack
	.type	EXTI_SetCallBack, @function
EXTI_SetCallBack:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(3)
	brsh .L28
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L28
	mov r30,r24
	ldi r31,0
	lsl r30
	rol r31
	subi r30,lo8(-(g_EXTI_CallBacks))
	sbci r31,hi8(-(g_EXTI_CallBacks))
	st Z,r22
	std Z+1,r23
	ldi r24,0
	ldi r25,0
	ret
.L28:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	EXTI_SetCallBack, .-EXTI_SetCallBack
	.section	.text.__vector_1,"ax",@progbits
.global	__vector_1
	.type	__vector_1, @function
__vector_1:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24
	push r25
	push r26
	push r27
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 15 */
.L__stack_usage = 15
	lds r30,g_EXTI_CallBacks
	lds r31,g_EXTI_CallBacks+1
	sbiw r30,0
	breq .L29
	icall
.L29:
/* epilogue start */
	pop r31
	pop r30
	pop r27
	pop r26
	pop r25
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_1, .-__vector_1
	.section	.text.__vector_2,"ax",@progbits
.global	__vector_2
	.type	__vector_2, @function
__vector_2:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24
	push r25
	push r26
	push r27
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 15 */
.L__stack_usage = 15
	lds r30,g_EXTI_CallBacks+2
	lds r31,g_EXTI_CallBacks+3
	sbiw r30,0
	breq .L34
	icall
.L34:
/* epilogue start */
	pop r31
	pop r30
	pop r27
	pop r26
	pop r25
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_2, .-__vector_2
	.section	.text.__vector_3,"ax",@progbits
.global	__vector_3
	.type	__vector_3, @function
__vector_3:
	push r1
	push r0
	in r0,__SREG__
	push r0
	clr __zero_reg__
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24
	push r25
	push r26
	push r27
	push r30
	push r31
/* prologue: Signal */
/* frame size = 0 */
/* stack size = 15 */
.L__stack_usage = 15
	lds r30,g_EXTI_CallBacks+4
	lds r31,g_EXTI_CallBacks+5
	sbiw r30,0
	breq .L39
	icall
.L39:
/* epilogue start */
	pop r31
	pop r30
	pop r27
	pop r26
	pop r25
	pop r24
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r0
	out __SREG__,r0
	pop r0
	pop r1
	reti
	.size	__vector_3, .-__vector_3
	.section	.bss.g_EXTI_CallBacks,"aw",@nobits
	.type	g_EXTI_CallBacks, @object
	.size	g_EXTI_CallBacks, 6
g_EXTI_CallBacks:
	.zero	6
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
