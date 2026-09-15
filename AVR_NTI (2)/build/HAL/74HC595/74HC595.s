	.file	"74HC595.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.HC595_Init,"ax",@progbits
.global	HC595_Init
	.type	HC595_Init, @function
HC595_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,lo8(3)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(3)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r20,lo8(1)
	ldi r22,lo8(4)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(5)
	ldi r24,lo8(2)
	call GPIO_SetPinDirection
	ldi r20,0
	ldi r22,lo8(4)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r20,0
	ldi r22,lo8(5)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r24,lo8(1)
	call SPI_InitMaster
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	HC595_Init, .-HC595_Init
	.section	.text.HC595_SendByte,"ax",@progbits
.global	HC595_SendByte
	.type	HC595_SendByte, @function
HC595_SendByte:
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
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	call SPI_Transceive
	ldi r20,lo8(1)
	ldi r22,lo8(3)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r20,0
	ldi r22,lo8(3)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r24,0
	ldi r25,0
/* epilogue start */
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	HC595_SendByte, .-HC595_SendByte
	.section	.text.HC595_DisplayFloor,"ax",@progbits
.global	HC595_DisplayFloor
	.type	HC595_DisplayFloor, @function
HC595_DisplayFloor:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r22
	cpi r24,lo8(4)
	brsh .L8
	mov r30,r24
	ldi r31,0
	subi r30,lo8(-(SEGMENT_MAP))
	sbci r31,hi8(-(SEGMENT_MAP))
	ld r24,Z
	call HC595_SendByte
	cpi r28,1
	cpc r29,__zero_reg__
	brne .L5
	ldi r20,lo8(1)
.L10:
	ldi r22,lo8(4)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r20,0
.L9:
	ldi r22,lo8(5)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r24,0
	ldi r25,0
.L3:
/* epilogue start */
	pop r29
	pop r28
	ret
.L5:
	ldi r20,0
	sbiw r28,2
	brne .L10
	ldi r22,lo8(4)
	ldi r24,lo8(2)
	call GPIO_SetPinValue
	ldi r20,lo8(1)
	rjmp .L9
.L8:
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L3
	.size	HC595_DisplayFloor, .-HC595_DisplayFloor
	.section	.text.HC595_DisplaySpecial,"ax",@progbits
.global	HC595_DisplaySpecial
	.type	HC595_DisplaySpecial, @function
HC595_DisplaySpecial:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(69)
	breq .L14
	cpi r24,lo8(70)
	brne .L13
	ldi r24,lo8(113)
.L12:
	jmp HC595_SendByte
.L14:
	ldi r24,lo8(121)
	rjmp .L12
.L13:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	HC595_DisplaySpecial, .-HC595_DisplaySpecial
	.section	.rodata.SEGMENT_MAP,"a"
	.type	SEGMENT_MAP, @object
	.size	SEGMENT_MAP, 4
SEGMENT_MAP:
	.ascii	"?\006[O"
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
