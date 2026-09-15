	.file	"dio.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Elevator_InitButtons,"ax",@progbits
.global	Elevator_InitButtons
	.type	Elevator_InitButtons, @function
Elevator_InitButtons:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(2)
	ldi r22,0
	ldi r24,0
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(1)
	ldi r24,0
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(2)
	ldi r24,0
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(3)
	ldi r24,0
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(4)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(5)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(6)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(2)
	ldi r22,lo8(7)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	Elevator_InitButtons, .-Elevator_InitButtons
	.section	.text.Elevator_ReadCarButton,"ax",@progbits
.global	Elevator_ReadCarButton
	.type	Elevator_ReadCarButton, @function
Elevator_ReadCarButton:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r20,r22
	ldi r22,lo8(-1)
	add r22,r24
	cpi r22,lo8(4)
	brsh .L3
	ldi r24,0
	jmp GPIO_GetPinValue
.L3:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	Elevator_ReadCarButton, .-Elevator_ReadCarButton
	.section	.text.Elevator_ReadFloorButton,"ax",@progbits
.global	Elevator_ReadFloorButton
	.type	Elevator_ReadFloorButton, @function
Elevator_ReadFloorButton:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r20,r22
	ldi r25,lo8(-1)
	add r25,r24
	cpi r25,lo8(4)
	brsh .L5
	ldi r22,lo8(3)
	add r22,r24
	ldi r24,lo8(1)
	jmp GPIO_GetPinValue
.L5:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	Elevator_ReadFloorButton, .-Elevator_ReadFloorButton
	.ident	"GCC: (GNU) 15.2.0"
