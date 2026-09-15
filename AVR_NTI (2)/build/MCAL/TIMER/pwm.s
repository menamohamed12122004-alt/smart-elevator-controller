	.file	"pwm.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.PWM_Init,"ax",@progbits
.global	PWM_Init
	.type	PWM_Init, @function
PWM_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x2f
	ori r24,lo8(2)
	out 0x2f,r24
	in r24,0x2f
	andi r24,lo8(-2)
	out 0x2f,r24
	in r24,0x2e
	ori r24,lo8(16)
	out 0x2e,r24
	in r24,0x2e
	ori r24,lo8(8)
	out 0x2e,r24
	in r24,0x2f
	andi r24,lo8(-65)
	out 0x2f,r24
	in r24,0x2f
	ori r24,lo8(-128)
	out 0x2f,r24
	ldi r24,lo8(31)
	ldi r25,lo8(3)
	out 0x26+1,r25
	out 0x26,r24
	in r24,0x2e
	ori r24,lo8(1)
	out 0x2e,r24
	in r24,0x2e
	andi r24,lo8(-3)
	out 0x2e,r24
	in r24,0x2e
	andi r24,lo8(-5)
	out 0x2e,r24
/* epilogue start */
	ret
	.size	PWM_Init, .-PWM_Init
	.section	.text.PWM_SetDutyCycle,"ax",@progbits
.global	PWM_SetDutyCycle
	.type	PWM_SetDutyCycle, @function
PWM_SetDutyCycle:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpse r24,__zero_reg__
	rjmp .L2
	mov r18,r22
	ldi r19,0
	ldi r26,lo8(31)
	ldi r27,lo8(3)
	call __umulhisi3
	ldi r18,lo8(100)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	out 0x2a+1,r19
	out 0x2a,r18
.L2:
/* epilogue start */
	ret
	.size	PWM_SetDutyCycle, .-PWM_SetDutyCycle
	.ident	"GCC: (GNU) 15.2.0"
