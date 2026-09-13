	.file	"INTERRUPT.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.INTERRUPT_EnableGlobal,"ax",@progbits
.global	INTERRUPT_EnableGlobal
	.type	INTERRUPT_EnableGlobal, @function
INTERRUPT_EnableGlobal:
/* prologue: function */
/* frame size = 0 */
/* #APP */
 ;  34 "MCAL/INTERRUPT/INTERRUPT.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(0)
	ldi r25,hi8(0)
/* epilogue start */
	ret
	.size	INTERRUPT_EnableGlobal, .-INTERRUPT_EnableGlobal
	.section	.text.INTERRUPT_DisableGlobal,"ax",@progbits
.global	INTERRUPT_DisableGlobal
	.type	INTERRUPT_DisableGlobal, @function
INTERRUPT_DisableGlobal:
/* prologue: function */
/* frame size = 0 */
/* #APP */
 ;  39 "MCAL/INTERRUPT/INTERRUPT.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(0)
	ldi r25,hi8(0)
/* epilogue start */
	ret
	.size	INTERRUPT_DisableGlobal, .-INTERRUPT_DisableGlobal
	.section	.text.EXTI_ClearFlag,"ax",@progbits
.global	EXTI_ClearFlag
	.type	EXTI_ClearFlag, @function
EXTI_ClearFlag:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(3)
	brlo .L6
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L7
.L6:
	cpi r24,lo8(1)
	breq .L10
	cpi r24,lo8(1)
	brlo .L9
	cpi r24,lo8(2)
	brne .L14
	rjmp .L11
.L9:
	ldi r24,lo8(64)
	rjmp .L13
.L10:
	ldi r24,lo8(-128)
	rjmp .L13
.L11:
	ldi r24,lo8(32)
.L13:
	out 90-32,r24
.L14:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L7:
	movw r24,r18
/* epilogue start */
	ret
	.size	EXTI_ClearFlag, .-EXTI_ClearFlag
	.section	.text.EXTI_SetSense,"ax",@progbits
.global	EXTI_SetSense
	.type	EXTI_SetSense, @function
EXTI_SetSense:
/* prologue: function */
/* frame size = 0 */
	mov r25,r24
	cpi r24,lo8(3)
	brsh .L16
	cpi r22,lo8(4)
	brsh .L16
	cpi r24,lo8(1)
	breq .L19
	cpi r24,lo8(1)
	brlo .L18
	cpi r24,lo8(2)
	brne .L17
	rjmp .L26
.L18:
	in r24,85-32
	andi r22,lo8(3)
	andi r24,lo8(-4)
	rjmp .L24
.L19:
	in r24,85-32
	lsl r22
	lsl r22
	andi r22,lo8(12)
	andi r24,lo8(-13)
.L24:
	or r24,r22
	out 85-32,r24
	rjmp .L17
.L26:
	cpi r22,lo8(2)
	brne .L21
	in r24,84-32
	andi r24,lo8(-65)
	rjmp .L25
.L21:
	cpi r22,lo8(3)
	brne .L16
	in r24,84-32
	ori r24,lo8(64)
.L25:
	out 84-32,r24
.L17:
	mov r24,r25
	call EXTI_ClearFlag
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L22
.L16:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
.L22:
	movw r24,r18
/* epilogue start */
	ret
	.size	EXTI_SetSense, .-EXTI_SetSense
	.section	.text.EXTI_Enable,"ax",@progbits
.global	EXTI_Enable
	.type	EXTI_Enable, @function
EXTI_Enable:
	push r17
/* prologue: function */
/* frame size = 0 */
	mov r17,r24
	cpi r24,lo8(3)
	brlo .L28
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L29
.L28:
	call EXTI_ClearFlag
	cpi r17,lo8(1)
	breq .L32
	cpi r17,lo8(1)
	brlo .L31
	cpi r17,lo8(2)
	brne .L36
	rjmp .L33
.L31:
	in r24,91-32
	ori r24,lo8(64)
	rjmp .L35
.L32:
	in r24,91-32
	ori r24,lo8(-128)
	rjmp .L35
.L33:
	in r24,91-32
	ori r24,lo8(32)
.L35:
	out 91-32,r24
.L36:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L29:
	movw r24,r18
/* epilogue start */
	pop r17
	ret
	.size	EXTI_Enable, .-EXTI_Enable
	.section	.text.EXTI_Disable,"ax",@progbits
.global	EXTI_Disable
	.type	EXTI_Disable, @function
EXTI_Disable:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(3)
	brlo .L38
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L39
.L38:
	cpi r24,lo8(1)
	breq .L42
	cpi r24,lo8(1)
	brlo .L41
	cpi r24,lo8(2)
	brne .L46
	rjmp .L43
.L41:
	in r24,91-32
	andi r24,lo8(-65)
	rjmp .L45
.L42:
	in r24,91-32
	andi r24,lo8(127)
	rjmp .L45
.L43:
	in r24,91-32
	andi r24,lo8(-33)
.L45:
	out 91-32,r24
.L46:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L39:
	movw r24,r18
/* epilogue start */
	ret
	.size	EXTI_Disable, .-EXTI_Disable
	.section	.text.EXTI_SetCallback,"ax",@progbits
.global	EXTI_SetCallback
	.type	EXTI_SetCallback, @function
EXTI_SetCallback:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(3)
	brsh .L48
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L48
	mov r30,r24
	ldi r31,lo8(0)
	lsl r30
	rol r31
	subi r30,lo8(-(callback))
	sbci r31,hi8(-(callback))
	std Z+1,r23
	st Z,r22
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L49
.L48:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
.L49:
	movw r24,r18
/* epilogue start */
	ret
	.size	EXTI_SetCallback, .-EXTI_SetCallback
	.section	.text.__vector_1,"ax",@progbits
.global	__vector_1
	.type	__vector_1, @function
__vector_1:
	push __zero_reg__
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
	lds r24,callback
	lds r25,(callback)+1
	or r24,r25
	breq .L53
	lds r30,callback
	lds r31,(callback)+1
	icall
.L53:
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
	pop __zero_reg__
	reti
	.size	__vector_1, .-__vector_1
	.section	.text.__vector_2,"ax",@progbits
.global	__vector_2
	.type	__vector_2, @function
__vector_2:
	push __zero_reg__
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
	lds r24,callback+2
	lds r25,(callback+2)+1
	or r24,r25
	breq .L56
	lds r30,callback+2
	lds r31,(callback+2)+1
	icall
.L56:
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
	pop __zero_reg__
	reti
	.size	__vector_2, .-__vector_2
	.section	.text.__vector_3,"ax",@progbits
.global	__vector_3
	.type	__vector_3, @function
__vector_3:
	push __zero_reg__
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
	lds r24,callback+4
	lds r25,(callback+4)+1
	or r24,r25
	breq .L59
	lds r30,callback+4
	lds r31,(callback+4)+1
	icall
.L59:
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
	pop __zero_reg__
	reti
	.size	__vector_3, .-__vector_3
	.section	.bss.callback,"aw",@nobits
	.type	callback, @object
	.size	callback, 6
callback:
	.skip 6,0
.global __do_clear_bss
