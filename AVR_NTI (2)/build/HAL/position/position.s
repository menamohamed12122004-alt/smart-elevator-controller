	.file	"position.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.POS_Init,"ax",@progbits
.global	POS_Init
	.type	POS_Init, @function
POS_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
/* epilogue start */
	ret
	.size	POS_Init, .-POS_Init
	.section	.text.POS_GetCm,"ax",@progbits
.global	POS_GetCm
	.type	POS_GetCm, @function
POS_GetCm:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 8 */
.L__stack_usage = 8
	movw r16,r24
	or r24,r25
	brne .L3
.L5:
	ldi r24,lo8(1)
	mov r14,r24
	mov r15,__zero_reg__
.L2:
	movw r24,r14
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
.L3:
	std Y+1,__zero_reg__
	std Y+2,__zero_reg__
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,0
	call ADC_ReadChannel
	movw r14,r24
	or r24,r25
	brne .L5
	ldd r22,Y+1
	ldd r23,Y+2
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	brne .L6
	movw r30,r16
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+2,__zero_reg__
	std Z+3,__zero_reg__
	rjmp .L2
.L6:
	cpi r22,-1
	ldi r31,3
	cpc r23,r31
	brlo .L8
	ldi r26,lo8(-31)
	ldi r27,lo8(67)
	movw r30,r16
	st Z,__zero_reg__
	std Z+1,__zero_reg__
	std Z+2,r26
	std Z+3,r27
	rjmp .L2
.L8:
	ldi r24,0
	ldi r25,0
	call __floatunsisf
	ldi r18,0
	ldi r19,lo8(-64)
	ldi r20,lo8(127)
	ldi r21,lo8(68)
	call __divsf3
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(-31)
	ldi r21,lo8(67)
	call __mulsf3
	ldi r20,0
	ldi r21,0
	movw r18,r20
	call __addsf3
	movw r30,r16
	st Z,r22
	std Z+1,r23
	std Z+2,r24
	std Z+3,r25
	rjmp .L2
	.size	POS_GetCm, .-POS_GetCm
	.section	.text.POS_GetNearestFloor,"ax",@progbits
.global	POS_GetNearestFloor
	.type	POS_GetNearestFloor, @function
POS_GetNearestFloor:
	push r2
	push r3
	push r4
	push r5
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
	push r28
	push r29
	rcall .
	rcall .
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 6 */
/* stack size = 24 */
.L__stack_usage = 24
	std Y+1,r22
	std Y+2,r23
	std Y+3,r24
	std Y+4,r25
	ldi r24,lo8(floor_positions)
	ldi r25,hi8(floor_positions)
	std Y+5,r24
	std Y+6,r25
	mov r10,__zero_reg__
	mov r11,__zero_reg__
	movw r8,r10
	mov r2,__zero_reg__
	ldi r24,lo8(36)
	mov r3,r24
	ldi r25,lo8(116)
	mov r4,r25
	ldi r25,lo8(73)
	mov r5,r25
	movw r6,r8
	movw r16,r8
.L13:
	ldd r30,Y+5
	ldd r31,Y+6
	ld r18,Z+
	ld r19,Z+
	ld r20,Z+
	ld r21,Z+
	std Y+5,r30
	std Y+6,r31
	ldd r22,Y+1
	ldd r23,Y+2
	ldd r24,Y+3
	ldd r25,Y+4
	call __subsf3
	movw r12,r22
	movw r14,r24
	ldi r20,0
	ldi r21,0
	movw r18,r20
	call __ltsf2
	sbrs r24,7
	rjmp .L10
	bst r15,7
	com r15
	bld r15,7
	com r15
.L10:
	movw r18,r2
	movw r20,r4
	movw r22,r12
	movw r24,r14
	call __ltsf2
	sbrs r24,7
	rjmp .L12
	movw r2,r12
	movw r4,r14
	movw r6,r8
	movw r16,r10
.L12:
	ldi r31,-1
	sub r8,r31
	sbc r9,r31
	sbc r10,r31
	sbc r11,r31
	ldi r24,4
	cp r8,r24
	cpc r9,__zero_reg__
	cpc r10,__zero_reg__
	cpc r11,__zero_reg__
	brne .L13
	movw r22,r6
	movw r24,r16
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
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
	pop r5
	pop r4
	pop r3
	pop r2
	ret
	.size	POS_GetNearestFloor, .-POS_GetNearestFloor
	.section	.rodata.floor_positions,"a"
	.type	floor_positions, @object
	.size	floor_positions, 16
floor_positions:
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	22
	.byte	67
	.byte	0
	.byte	0
	.byte	-106
	.byte	67
	.byte	0
	.byte	0
	.byte	-31
	.byte	67
.global	__ltsf2
.global	__subsf3
.global	__addsf3
.global	__mulsf3
.global	__divsf3
.global	__floatunsisf
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
