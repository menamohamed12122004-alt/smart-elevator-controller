	.file	"main.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.INT0_Handler,"ax",@progbits
.global	INT0_Handler
	.type	INT0_Handler, @function
INT0_Handler:
/* prologue: function */
/* frame size = 0 */
	ldi r24,lo8(0)
	ldi r22,lo8(6)
	call GPIO_TogglePinValue
/* epilogue start */
	ret
	.size	INT0_Handler, .-INT0_Handler
	.section	.text.main,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
	ldi r24,lo8(0)
	ldi r22,lo8(5)
	ldi r20,lo8(1)
	call GPIO_SetPinDirection
	ldi r24,lo8(0)
	ldi r22,lo8(6)
	ldi r20,lo8(1)
	call GPIO_SetPinDirection
	ldi r24,lo8(3)
	ldi r22,lo8(2)
	ldi r20,lo8(0)
	call GPIO_SetPinDirection
	call TIMER0_Init
	ldi r24,lo8(0)
	ldi r22,lo8(gs(INT0_Handler))
	ldi r23,hi8(gs(INT0_Handler))
	call EXTI_SetCallback
	ldi r24,lo8(0)
	ldi r22,lo8(1)
	call EXTI_SetSense
	ldi r24,lo8(0)
	call EXTI_Enable
	call INTERRUPT_EnableGlobal
.L4:
	ldi r24,lo8(0)
	ldi r22,lo8(5)
	call GPIO_TogglePinValue
	ldi r24,lo8(1000)
	ldi r25,hi8(1000)
	call TIMER0_DelayMS
	rjmp .L4
	.size	main, .-main
