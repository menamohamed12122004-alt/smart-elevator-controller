	.file	"UART.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.UART_Init,"ax",@progbits
.global	UART_Init
	.type	UART_Init, @function
UART_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	sbci r23,hi8(0)
	sbci r22,lo8(0)
	breq .L3
	movw r18,r22
	movw r20,r24
	ldi r24,4
	1:
	lsl r18
	rol r19
	rol r20
	rol r21
	dec r24
	brne 1b
	ldi r22,0
	ldi r23,lo8(18)
	ldi r24,lo8(122)
	ldi r25,0
	call __udivmodsi4
	subi r18,1
	sbc r19,__zero_reg__
	out 0x20,r19
	out 0x9,r18
	ldi r24,lo8(-122)
	out 0x20,r24
	ldi r24,lo8(-104)
	out 0xa,r24
	ldi r24,0
	ldi r25,0
	ret
.L3:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_Init, .-UART_Init
	.section	.text.UART_SendByte,"ax",@progbits
.global	UART_SendByte
	.type	UART_SendByte, @function
UART_SendByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
.L5:
	sbis 0xb,5
	rjmp .L5
	out 0xc,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_SendByte, .-UART_SendByte
	.section	.text.UART_ReceiveByte,"ax",@progbits
.global	UART_ReceiveByte
	.type	UART_ReceiveByte, @function
UART_ReceiveByte:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sbiw r24,0
	breq .L11
.L10:
	sbis 0xb,7
	rjmp .L10
	in r18,0xc
	movw r30,r24
	st Z,r18
	ldi r24,0
	ldi r25,0
	ret
.L11:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	UART_ReceiveByte, .-UART_ReceiveByte
	.ident	"GCC: (GNU) 15.2.0"
