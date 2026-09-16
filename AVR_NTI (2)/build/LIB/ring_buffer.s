	.file	"ring_buffer.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Buffer_Init,"ax",@progbits
.global	Buffer_Init
	.type	Buffer_Init, @function
Buffer_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	or r24,r25
	breq .L1
	st Z,r22
	std Z+1,r23
	std Z+2,r20
	std Z+3,__zero_reg__
	std Z+4,__zero_reg__
	std Z+5,__zero_reg__
.L1:
/* epilogue start */
	ret
	.size	Buffer_Init, .-Buffer_Init
	.section	.text.RingBuffer_Init,"ax",@progbits
.global	RingBuffer_Init
	.type	RingBuffer_Init, @function
RingBuffer_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	jmp Buffer_Init
	.size	RingBuffer_Init, .-RingBuffer_Init
	.section	.text.Buffer_IsEmpty,"ax",@progbits
.global	Buffer_IsEmpty
	.type	Buffer_IsEmpty, @function
Buffer_IsEmpty:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	ldi r24,lo8(1)
	sbiw r30,0
	breq .L7
	ldd r25,Z+5
	cp r25, __zero_reg__
	breq .L7
	ldi r24,0
	ret
.L7:
/* epilogue start */
	ret
	.size	Buffer_IsEmpty, .-Buffer_IsEmpty
	.section	.text.Buffer_IsFull,"ax",@progbits
.global	Buffer_IsFull
	.type	Buffer_IsFull, @function
Buffer_IsFull:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r30,r24
	ldi r24,lo8(1)
	sbiw r30,0
	breq .L14
	ldd r18,Z+5
	ldd r25,Z+2
	cp r18,r25
	brsh .L14
	ldi r24,0
	ret
.L14:
/* epilogue start */
	ret
	.size	Buffer_IsFull, .-Buffer_IsFull
	.section	.text.Buffer_GetCount,"ax",@progbits
.global	Buffer_GetCount
	.type	Buffer_GetCount, @function
Buffer_GetCount:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L20
	movw r30,r24
	ldd r24,Z+5
	ret
.L20:
	ldi r24,0
/* epilogue start */
	ret
	.size	Buffer_GetCount, .-Buffer_GetCount
	.section	.text.Buffer_Enqueue,"ax",@progbits
.global	Buffer_Enqueue
	.type	Buffer_Enqueue, @function
Buffer_Enqueue:
	push r16
	push r17
	push r28
	push r29
	rcall .
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 3 */
/* stack size = 7 */
.L__stack_usage = 7
	std Y+2,r24
	std Y+3,r25
	std Y+1,r22
	sbiw r24,0
	breq .L26
	movw r30,r24
	ld r16,Z
	ldd r17,Z+1
	cp r16,__zero_reg__
	cpc r17,__zero_reg__
	breq .L26
	ldd r24,Z+2
	cp r24, __zero_reg__
	breq .L26
	movw r24,r30
	call Buffer_IsFull
	cpse r24,__zero_reg__
	rjmp .L26
	ldd r30,Y+2
	ldd r31,Y+3
	ldd r24,Z+3
	movw r30,r16
	add r30,r24
	adc r31,__zero_reg__
	ldd r24,Y+1
	st Z,r24
	ldd r30,Y+2
	ldd r31,Y+3
	ldd r24,Z+3
	ldi r25,0
	adiw r24,1
	ldd r22,Z+2
	ldi r23,0
	call __udivmodhi4
	std Z+3,r24
	ldd r24,Z+5
	subi r24,lo8(-(1))
	std Z+5,r24
	ldi r24,0
	ldi r25,0
.L21:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L26:
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L21
	.size	Buffer_Enqueue, .-Buffer_Enqueue
	.section	.text.RingBuffer_Enqueue,"ax",@progbits
.global	RingBuffer_Enqueue
	.type	RingBuffer_Enqueue, @function
RingBuffer_Enqueue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	jmp Buffer_Enqueue
	.size	RingBuffer_Enqueue, .-RingBuffer_Enqueue
	.section	.text.Buffer_Dequeue,"ax",@progbits
.global	Buffer_Dequeue
	.type	Buffer_Dequeue, @function
Buffer_Dequeue:
	push r14
	push r15
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 6 */
.L__stack_usage = 6
	movw r28,r24
	movw r14,r22
	sbiw r24,0
	breq .L33
	or r22,r23
	breq .L33
	ld r16,Y
	ldd r17,Y+1
	cp r16,__zero_reg__
	cpc r17,__zero_reg__
	breq .L33
	call Buffer_IsEmpty
	cpse r24,__zero_reg__
	rjmp .L33
	ldd r24,Y+4
	movw r30,r16
	add r30,r24
	adc r31,__zero_reg__
	ld r24,Z
	movw r30,r14
	st Z,r24
	ldd r24,Y+4
	ldi r25,0
	adiw r24,1
	ldd r22,Y+2
	ldi r23,0
	call __udivmodhi4
	std Y+4,r24
	ldd r24,Y+5
	subi r24,lo8(-(-1))
	std Y+5,r24
	ldi r24,0
	ldi r25,0
.L28:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	ret
.L33:
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L28
	.size	Buffer_Dequeue, .-Buffer_Dequeue
	.section	.text.RingBuffer_Dequeue,"ax",@progbits
.global	RingBuffer_Dequeue
	.type	RingBuffer_Dequeue, @function
RingBuffer_Dequeue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	jmp Buffer_Dequeue
	.size	RingBuffer_Dequeue, .-RingBuffer_Dequeue
	.ident	"GCC: (GNU) 15.2.0"
