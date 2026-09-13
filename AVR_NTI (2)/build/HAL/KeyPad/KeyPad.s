	.file	"KeyPad.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.KeyPad_Init,"ax",@progbits
.global	KeyPad_Init
	.type	KeyPad_Init, @function
KeyPad_Init:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(4)
	brlo .L2
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L3
.L2:
	ldi r22,lo8(-16)
	call GPIO_SetPortDirection
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L3:
	movw r24,r18
/* epilogue start */
	ret
	.size	KeyPad_Init, .-KeyPad_Init
	.section	.text.KeyPad_GetPressedKey,"ax",@progbits
.global	KeyPad_GetPressedKey
	.type	KeyPad_GetPressedKey, @function
KeyPad_GetPressedKey:
	push r6
	push r7
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	push r16
	push r17
	push r29
	push r28
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
	mov r12,r24
	movw r10,r22
	ldi r24,lo8(3)
	cp r24,r12
	brsh .+2
	rjmp .L6
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	brne .+2
	rjmp .L6
	mov r24,r12
	ldi r22,lo8(-16)
	call GPIO_SetPortDirection
	mov r24,r12
	movw r8,r28
	sec
	adc r8,__zero_reg__
	adc r9,__zero_reg__
	movw r22,r8
	call GPIO_GetPortValue
	ldi r16,lo8(0)
	ldi r17,hi8(0)
	ldi r25,lo8(1)
	mov r6,r25
	mov r7,__zero_reg__
.L10:
	subi r16,lo8(-(4))
	sbci r17,hi8(-(4))
	movw r22,r6
	mov r0,r16
	rjmp 2f
1:	lsl r22
	rol r23
2:	dec r0
	brpl 1b
	subi r16,lo8(-(-4))
	sbci r17,hi8(-(-4))
	com r22
	mov r24,r12
	call GPIO_SetPortValue
	clr r14
	clr r15
.L9:
	mov r13,r14
	mov r24,r12
	movw r22,r8
	call GPIO_GetPortValue
	ldd r24,Y+1
	ldi r25,lo8(0)
	mov r0,r14
	rjmp 2f
1:	asr r25
	ror r24
2:	dec r0
	brpl 1b
	sbrc r24,0
	rjmp .L7
	lsl r16
	rol r17
	lsl r16
	rol r17
	add r13,r16
	movw r30,r10
	st Z,r13
	rjmp .L14
.L7:
	sec
	adc r14,__zero_reg__
	adc r15,__zero_reg__
	ldi r31,lo8(4)
	cp r14,r31
	cpc r15,__zero_reg__
	brne .L9
	subi r16,lo8(-(1))
	sbci r17,hi8(-(1))
	cpi r16,4
	cpc r17,__zero_reg__
	brne .L10
	ldi r24,lo8(-1)
	movw r30,r10
	st Z,r24
.L14:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L8
.L6:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
.L8:
	movw r24,r18
/* epilogue start */
	pop __tmp_reg__
	pop r28
	pop r29
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop r7
	pop r6
	ret
	.size	KeyPad_GetPressedKey, .-KeyPad_GetPressedKey
