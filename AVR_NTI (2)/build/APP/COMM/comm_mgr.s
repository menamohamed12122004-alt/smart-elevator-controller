	.file	"comm_mgr.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Comm_SendNum,"ax",@progbits
	.type	Comm_SendNum, @function
Comm_SendNum:
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
/* stack size = 12 */
.L__stack_usage = 12
	movw r18,r24
	or r24,r25
	brne .L2
	ldi r24,lo8(48)
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
	jmp UART_SendByte
.L2:
	movw r14,r28
	ldi r24,-1
	sub r14,r24
	sbc r15,r24
	movw r30,r14
	ldi r16,0
	ldi r17,0
.L3:
	movw r24,r18
	ldi r22,lo8(10)
	ldi r23,0
	call __udivmodhi4
	subi r16,-1
	sbci r17,-1
	subi r24,lo8(-(48))
	st Z+,r24
	movw r24,r18
	movw r18,r22
	sbiw r24,10
	brsh .L3
	add r16,r14
	adc r17,r15
.L4:
	movw r30,r16
	ld r24,-Z
	movw r16,r30
	call UART_SendByte
	cp r16,r14
	cpc r17,r15
	brne .L4
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
	ret
	.size	Comm_SendNum, .-Comm_SendNum
	.section	.text.Comm_Init,"ax",@progbits
.global	Comm_Init
	.type	Comm_Init, @function
Comm_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r22,lo8(-128)
	ldi r23,lo8(37)
	ldi r24,0
	ldi r25,0
	jmp UART_Init
	.size	Comm_Init, .-Comm_Init
	.section	.rodata.Comm_SendTelemetry.str1.1,"aMS",@progbits,1
.LC0:
	.string	"[FLR:"
.LC1:
	.string	"|WGT:"
.LC2:
	.string	"|DR:"
.LC3:
	.string	"|EMG:"
.LC4:
	.string	"]\r\n"
	.section	.text.Comm_SendTelemetry,"ax",@progbits
.global	Comm_SendTelemetry
	.type	Comm_SendTelemetry, @function
Comm_SendTelemetry:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	or r24,r25
	breq .L8
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	call UART_SendString
	ld r24,Y
	ldi r25,0
	call Comm_SendNum
	ldi r24,lo8(.LC1)
	ldi r25,hi8(.LC1)
	call UART_SendString
	ldd r24,Y+1
	ldd r25,Y+2
	call Comm_SendNum
	ldi r24,lo8(.LC2)
	ldi r25,hi8(.LC2)
	call UART_SendString
	ldd r24,Y+3
	ldi r25,0
	call Comm_SendNum
	ldi r24,lo8(.LC3)
	ldi r25,hi8(.LC3)
	call UART_SendString
	ldd r24,Y+4
	ldi r25,0
	call Comm_SendNum
	ldi r24,lo8(.LC4)
	ldi r25,hi8(.LC4)
/* epilogue start */
	pop r29
	pop r28
	jmp UART_SendString
.L8:
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	Comm_SendTelemetry, .-Comm_SendTelemetry
	.section	.text.Comm_ReceiveCommand,"ax",@progbits
.global	Comm_ReceiveCommand
	.type	Comm_ReceiveCommand, @function
Comm_ReceiveCommand:
	push r28
	push r29
	push __tmp_reg__
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 1 */
/* stack size = 3 */
.L__stack_usage = 3
	std Y+1,__zero_reg__
	call UART_IsDataReady
	or r24,r25
	breq .L11
.L13:
	ldi r24,0
	ldi r25,0
.L10:
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L11:
	movw r24,r28
	adiw r24,1
	call UART_ReceiveByte
	or r24,r25
	brne .L13
	ldd r18,Y+1
	ldi r24,lo8(3)
	ldi r25,0
	cpi r18,lo8(82)
	breq .L10
	ldi r24,lo8(1)
	ldi r25,0
	cpi r18,lo8(83)
	breq .L10
	cpi r18,lo8(79)
	breq .L14
	ldi r24,0
.L14:
	lsl r24
	rol r25
	rjmp .L10
	.size	Comm_ReceiveCommand, .-Comm_ReceiveCommand
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
