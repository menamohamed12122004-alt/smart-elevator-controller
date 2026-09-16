	.file	"HC165.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.HC165_Init,"ax",@progbits
.global	HC165_Init
	.type	HC165_Init, @function
HC165_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(3)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(3)
	call GPIO_SetPinValue
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	HC165_Init, .-HC165_Init
	.section	.text.HC165_ReadByte,"ax",@progbits
.global	HC165_ReadByte
	.type	HC165_ReadByte, @function
HC165_ReadByte:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
	or r24,r25
	breq .L3
	ldi r20,0
	ldi r22,0
	ldi r24,lo8(3)
	call GPIO_SetPinValue
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(3)
	call GPIO_SetPinValue
	movw r22,r28
	ldi r24,lo8(-1)
/* epilogue start */
	pop r29
	pop r28
	jmp SPI_Transceive
.L3:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	pop r29
	pop r28
	ret
	.size	HC165_ReadByte, .-HC165_ReadByte
	.section	.text.HC165_ReadMultiple,"ax",@progbits
.global	HC165_ReadMultiple
	.type	HC165_ReadMultiple, @function
HC165_ReadMultiple:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 4 */
.L__stack_usage = 4
	movw r28,r24
	mov r17,r22
	or r24,r25
	breq .L5
	cp r22, __zero_reg__
	breq .L5
	ldi r20,0
	ldi r22,0
	ldi r24,lo8(3)
	call GPIO_SetPinValue
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(3)
	call GPIO_SetPinValue
	movw r24,r28
	add r24,r17
	adc r25,__zero_reg__
	movw r16,r24
.L6:
	movw r22,r28
	ldi r24,lo8(-1)
	call SPI_Transceive
	sbiw r24,0
	brne .L5
	adiw r28,1
	cp r28,r16
	cpc r29,r17
	brne .L6
.L4:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L5:
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L4
	.size	HC165_ReadMultiple, .-HC165_ReadMultiple
	.section	.text.HC165_Read16Bits,"ax",@progbits
.global	HC165_Read16Bits
	.type	HC165_Read16Bits, @function
HC165_Read16Bits:
	push r16
	push r17
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 6 */
.L__stack_usage = 6
	movw r16,r24
	std Y+1,__zero_reg__
	std Y+2,__zero_reg__
	or r24,r25
	brne .L16
.L18:
	ldi r24,lo8(1)
	ldi r25,0
.L15:
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	pop r17
	pop r16
	ret
.L16:
	ldi r22,lo8(2)
	movw r24,r28
	adiw r24,1
	call HC165_ReadMultiple
	sbiw r24,0
	brne .L18
	ldd r18,Y+1
	ldd r19,Y+2
	movw r30,r16
	st Z,r18
	std Z+1,r19
	rjmp .L15
	.size	HC165_Read16Bits, .-HC165_Read16Bits
	.ident	"GCC: (GNU) 15.2.0"
