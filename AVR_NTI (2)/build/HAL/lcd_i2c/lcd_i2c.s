	.file	"lcd_i2c.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LCD_I2C_WritePulse,"ax",@progbits
	.type	LCD_I2C_WritePulse, @function
LCD_I2C_WritePulse:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	call I2C_SendStart
	lds r24,Global_u8SlaveAddress
	call I2C_SendSlaveAddressWithWrite
	mov r24,r28
	ori r24,lo8(12)
	call I2C_SendByte
	ldi r24,lo8(2)
1:	dec r24
	brne 1b
	rjmp .
	mov r24,r28
	ori r24,lo8(8)
	call I2C_SendByte
	ldi r24,lo8(-123)
1:	dec r24
	brne 1b
	nop
/* epilogue start */
	pop r28
	jmp I2C_SendStop
	.size	LCD_I2C_WritePulse, .-LCD_I2C_WritePulse
	.section	.text.LCD_I2C_SendCommand,"ax",@progbits
.global	LCD_I2C_SendCommand
	.type	LCD_I2C_SendCommand, @function
LCD_I2C_SendCommand:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	andi r24,lo8(-16)
	call LCD_I2C_WritePulse
	mov r24,r28
	swap r24
	andi r24,lo8(-16)
	call LCD_I2C_WritePulse
	ldi r24,lo8(3999)
	ldi r25,hi8(3999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
/* epilogue start */
	pop r28
	ret
	.size	LCD_I2C_SendCommand, .-LCD_I2C_SendCommand
	.section	.text.LCD_I2C_SendData,"ax",@progbits
.global	LCD_I2C_SendData
	.type	LCD_I2C_SendData, @function
LCD_I2C_SendData:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r24
	andi r24,lo8(-16)
	ori r24,lo8(1)
	call LCD_I2C_WritePulse
	mov r24,r28
	swap r24
	andi r24,lo8(-16)
	ori r24,lo8(1)
	call LCD_I2C_WritePulse
	ldi r24,lo8(3999)
	ldi r25,hi8(3999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
/* epilogue start */
	pop r28
	ret
	.size	LCD_I2C_SendData, .-LCD_I2C_SendData
	.section	.text.LCD_I2C_SendString,"ax",@progbits
.global	LCD_I2C_SendString
	.type	LCD_I2C_SendString, @function
LCD_I2C_SendString:
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
/* stack size = 2 */
.L__stack_usage = 2
	movw r28,r24
.L5:
	ld r24,Y
	cpse r24,__zero_reg__
	rjmp .L6
/* epilogue start */
	pop r29
	pop r28
	ret
.L6:
	adiw r28,1
	call LCD_I2C_SendData
	rjmp .L5
	.size	LCD_I2C_SendString, .-LCD_I2C_SendString
	.section	.text.LCD_I2C_SetCursor,"ax",@progbits
.global	LCD_I2C_SetCursor
	.type	LCD_I2C_SetCursor, @function
LCD_I2C_SetCursor:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(1)
	brsh .L8
	ldi r24,lo8(-128)
.L11:
	add r24,r22
.L9:
	jmp LCD_I2C_SendCommand
.L8:
	brne .L10
	ldi r24,lo8(-64)
	rjmp .L11
.L10:
	ldi r24,0
	rjmp .L9
	.size	LCD_I2C_SetCursor, .-LCD_I2C_SetCursor
	.section	.text.LCD_I2C_Clear,"ax",@progbits
.global	LCD_I2C_Clear
	.type	LCD_I2C_Clear, @function
LCD_I2C_Clear:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(1)
	call LCD_I2C_SendCommand
	ldi r24,lo8(3999)
	ldi r25,hi8(3999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
/* epilogue start */
	ret
	.size	LCD_I2C_Clear, .-LCD_I2C_Clear
	.section	.text.LCD_I2C_Init,"ax",@progbits
.global	LCD_I2C_Init
	.type	LCD_I2C_Init, @function
LCD_I2C_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts Global_u8SlaveAddress,r24
	ldi r18,lo8(79999)
	ldi r24,hi8(79999)
	ldi r25,hlo8(79999)
1:	subi r18,1
	sbci r24,0
	sbci r25,0
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(-25537)
	ldi r25,hi8(-25537)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(48)
	call LCD_I2C_WritePulse
	ldi r24,lo8(9999)
	ldi r25,hi8(9999)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(48)
	call LCD_I2C_WritePulse
	ldi r24,lo8(299)
	ldi r25,hi8(299)
1:	sbiw r24,1
	brne 1b
	rjmp .
	nop
	ldi r24,lo8(48)
	call LCD_I2C_WritePulse
	ldi r24,lo8(32)
	call LCD_I2C_WritePulse
	ldi r24,lo8(40)
	call LCD_I2C_SendCommand
	ldi r24,lo8(12)
	call LCD_I2C_SendCommand
	call LCD_I2C_Clear
	ldi r24,lo8(6)
	jmp LCD_I2C_SendCommand
	.size	LCD_I2C_Init, .-LCD_I2C_Init
	.section	.data.Global_u8SlaveAddress,"aw"
	.type	Global_u8SlaveAddress, @object
	.size	Global_u8SlaveAddress, 1
Global_u8SlaveAddress:
	.byte	39
	.ident	"GCC: (GNU) 15.2.0"
.global __do_copy_data
