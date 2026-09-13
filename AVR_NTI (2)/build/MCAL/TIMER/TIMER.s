	.file	"TIMER.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.TIMER0_Init,"ax",@progbits
.global	TIMER0_Init
	.type	TIMER0_Init, @function
TIMER0_Init:
/* prologue: function */
/* frame size = 0 */
	ldi r24,lo8(8)
	out 83-32,r24
	ldi r24,lo8(124)
	out 92-32,r24
	out 82-32,__zero_reg__
	ldi r24,lo8(0)
	ldi r25,hi8(0)
/* epilogue start */
	ret
	.size	TIMER0_Init, .-TIMER0_Init
	.section	.text.TIMER0_DelayMS,"ax",@progbits
.global	TIMER0_DelayMS
	.type	TIMER0_DelayMS, @function
TIMER0_DelayMS:
/* prologue: function */
/* frame size = 0 */
	movw r20,r24
	in r24,88-32
	ori r24,lo8(2)
	out 88-32,r24
	in r24,83-32
	ori r24,lo8(3)
	out 83-32,r24
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L4
.L7:
	in __tmp_reg__,88-32
	sbrs __tmp_reg__,1
	rjmp .L7
	in r24,88-32
	ori r24,lo8(2)
	out 88-32,r24
	subi r18,lo8(-(1))
	sbci r19,hi8(-(1))
.L4:
	cp r18,r20
	cpc r19,r21
	brlo .L7
	in r24,83-32
	andi r24,lo8(-8)
	out 83-32,r24
	ldi r24,lo8(0)
	ldi r25,hi8(0)
/* epilogue start */
	ret
	.size	TIMER0_DelayMS, .-TIMER0_DelayMS
	.section	.text.TIMER0_DelayS,"ax",@progbits
.global	TIMER0_DelayS
	.type	TIMER0_DelayS, @function
TIMER0_DelayS:
/* prologue: function */
/* frame size = 0 */
/* epilogue start */
	ret
	.size	TIMER0_DelayS, .-TIMER0_DelayS
	.section	.text.TIMER0_PWM,"ax",@progbits
.global	TIMER0_PWM
	.type	TIMER0_PWM, @function
TIMER0_PWM:
/* prologue: function */
/* frame size = 0 */
/* epilogue start */
	ret
	.size	TIMER0_PWM, .-TIMER0_PWM
	.section	.text.TIMER0_Stop,"ax",@progbits
.global	TIMER0_Stop
	.type	TIMER0_Stop, @function
TIMER0_Stop:
/* prologue: function */
/* frame size = 0 */
/* epilogue start */
	ret
	.size	TIMER0_Stop, .-TIMER0_Stop
	.section	.text.TIMER1_Init,"ax",@progbits
.global	TIMER1_Init
	.type	TIMER1_Init, @function
TIMER1_Init:
/* prologue: function */
/* frame size = 0 */
/* epilogue start */
	ret
	.size	TIMER1_Init, .-TIMER1_Init
	.section	.text.TIMER1_DelayMS,"ax",@progbits
.global	TIMER1_DelayMS
	.type	TIMER1_DelayMS, @function
TIMER1_DelayMS:
/* prologue: function */
/* frame size = 0 */
/* epilogue start */
	ret
	.size	TIMER1_DelayMS, .-TIMER1_DelayMS
	.section	.text.TIMER1_PWM,"ax",@progbits
.global	TIMER1_PWM
	.type	TIMER1_PWM, @function
TIMER1_PWM:
/* prologue: function */
/* frame size = 0 */
/* epilogue start */
	ret
	.size	TIMER1_PWM, .-TIMER1_PWM
	.section	.text.TIMER1_Stop,"ax",@progbits
.global	TIMER1_Stop
	.type	TIMER1_Stop, @function
TIMER1_Stop:
/* prologue: function */
/* frame size = 0 */
/* epilogue start */
	ret
	.size	TIMER1_Stop, .-TIMER1_Stop
