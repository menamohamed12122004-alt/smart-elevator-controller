	.file	"ADC.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.ADC_Init,"ax",@progbits
.global	ADC_Init
	.type	ADC_Init, @function
ADC_Init:
/* prologue: function */
/* frame size = 0 */
	mov r25,r24
	cpi r24,lo8(2)
	brlo .L2
	cpi r24,lo8(3)
	brne .L3
.L2:
	mov r24,r22
	subi r24,lo8(-(-1))
	cpi r24,lo8(7)
	brsh .L3
	swap r25
	lsl r25
	lsl r25
	andi r25,lo8(-64)
	out 39-32,r25
	andi r22,lo8(7)
	ori r22,lo8(-128)
	out 38-32,r22
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L4
.L3:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
.L4:
	movw r24,r18
/* epilogue start */
	ret
	.size	ADC_Init, .-ADC_Init
	.section	.text.ADC_ReadChannel,"ax",@progbits
.global	ADC_ReadChannel
	.type	ADC_ReadChannel, @function
ADC_ReadChannel:
/* prologue: function */
/* frame size = 0 */
	mov r25,r24
	movw r30,r22
	cpi r24,lo8(8)
	brsh .L7
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L7
	in r24,39-32
	andi r25,lo8(31)
	or r24,r25
	out 39-32,r24
	sbi 38-32,6
.L8:
	sbis 38-32,4
	rjmp .L8
	sbi 38-32,4
	in r24,36-32
	in r20,37-32
	mov r19,r20
	ldi r18,lo8(0)
	ldi r25,lo8(0)
	or r18,r24
	or r19,r25
	std Z+1,r19
	st Z,r18
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L9
.L7:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
.L9:
	movw r24,r18
/* epilogue start */
	ret
	.size	ADC_ReadChannel, .-ADC_ReadChannel
