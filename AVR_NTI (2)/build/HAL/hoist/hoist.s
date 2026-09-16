	.file	"hoist.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Motor_MoveUp,"ax",@progbits
.global	Motor_MoveUp
	.type	Motor_MoveUp, @function
Motor_MoveUp:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r20,0
	ldi r22,lo8(1)
	ldi r24,lo8(1)
	jmp GPIO_SetPinValue
	.size	Motor_MoveUp, .-Motor_MoveUp
	.section	.text.Motor_MoveDown,"ax",@progbits
.global	Motor_MoveDown
	.type	Motor_MoveDown, @function
Motor_MoveDown:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,0
	ldi r22,0
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r20,lo8(1)
	ldi r22,lo8(1)
	ldi r24,lo8(1)
	jmp GPIO_SetPinValue
	.size	Motor_MoveDown, .-Motor_MoveDown
	.section	.text.Motor_SetSpeed,"ax",@progbits
.global	Motor_SetSpeed
	.type	Motor_SetSpeed, @function
Motor_SetSpeed:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	mov r22,r24
	ldi r24,0
	jmp PWM_SetDutyCycle
	.size	Motor_SetSpeed, .-Motor_SetSpeed
	.section	.text.Motor_Stop,"ax",@progbits
.global	Motor_Stop
	.type	Motor_Stop, @function
Motor_Stop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,0
	ldi r22,0
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r20,0
	ldi r22,lo8(1)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r24,0
	jmp Motor_SetSpeed
	.size	Motor_Stop, .-Motor_Stop
	.section	.text.Motor_Init,"ax",@progbits
.global	Motor_Init
	.type	Motor_Init, @function
Motor_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	ldi r20,lo8(1)
	ldi r22,lo8(1)
	ldi r24,lo8(1)
	call GPIO_SetPinDirection
	jmp Motor_Stop
	.size	Motor_Init, .-Motor_Init
	.ident	"GCC: (GNU) 15.2.0"
