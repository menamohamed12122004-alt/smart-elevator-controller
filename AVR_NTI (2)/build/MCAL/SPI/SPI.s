	.file	"SPI.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SPI_InitMaster,"ax",@progbits
.global	SPI_InitMaster
	.type	SPI_InitMaster, @function
SPI_InitMaster:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	ldi r24,lo8(1)
	ldi r25,0
	cpi r28,lo8(4)
	brsh .L1
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(5)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(7)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(6)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ori r28,lo8(96)
	out 0xd,r28
	ldi r24,0
	ldi r25,0
.L1:
/* epilogue start */
	pop r28
	ret
	.size	SPI_InitMaster, .-SPI_InitMaster
	.section	.text.SPI_InitSlave,"ax",@progbits
.global	SPI_InitSlave
	.type	SPI_InitSlave, @function
SPI_InitSlave:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,lo8(6)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(5)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(7)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r24,lo8(64)
	out 0xd,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	SPI_InitSlave, .-SPI_InitSlave
	.section	.text.SPI_Transceive,"ax",@progbits
.global	SPI_Transceive
	.type	SPI_Transceive, @function
SPI_Transceive:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L8
	out 0xf,r24
.L7:
	sbis 0xe,7
	rjmp .L7
	in r24,0xf
	movw r30,r22
	st Z,r24
	ldi r24,0
	ldi r25,0
	ret
.L8:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	SPI_Transceive, .-SPI_Transceive
	.ident	"GCC: (GNU) 15.2.0"
