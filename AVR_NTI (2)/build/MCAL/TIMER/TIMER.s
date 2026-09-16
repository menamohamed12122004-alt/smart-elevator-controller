	.file	"TIMER.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.TIMER0_Init,"ax",@progbits
.global	TIMER0_Init
	.type	TIMER0_Init, @function
TIMER0_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(8)
	out 0x33,r24
	ldi r24,lo8(124)
	out 0x3c,r24
	out 0x32,__zero_reg__
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	TIMER0_Init, .-TIMER0_Init
	.section	.text.TIMER0_DelayMS,"ax",@progbits
.global	TIMER0_DelayMS
	.type	TIMER0_DelayMS, @function
TIMER0_DelayMS:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r20,r24
	ldi r24,lo8(2)
	out 0x38,r24
	in r25,0x33
	andi r25,lo8(-8)
	out 0x33,r25
	in r25,0x33
	ori r25,lo8(3)
	out 0x33,r25
	ldi r18,0
	ldi r19,0
.L3:
	cp r18,r20
	cpc r19,r21
	brne .L4
	in r24,0x33
	andi r24,lo8(-8)
	out 0x33,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
.L4:
	in __tmp_reg__,0x38
	sbrs __tmp_reg__,1
	rjmp .L4
	out 0x38,r24
	subi r18,-1
	sbci r19,-1
	rjmp .L3
	.size	TIMER0_DelayMS, .-TIMER0_DelayMS
	.section	.text.TIMER0_DelayS,"ax",@progbits
.global	TIMER0_DelayS
	.type	TIMER0_DelayS, @function
TIMER0_DelayS:
	push r28
	push r29
	rcall .
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 4 */
/* stack size = 6 */
.L__stack_usage = 6
	std Y+1,r24
	std Y+2,r25
	std Y+3,__zero_reg__
	std Y+4,__zero_reg__
.L9:
	ldd r24,Y+3
	ldd r25,Y+4
	ldd r18,Y+1
	ldd r19,Y+2
	cp r24,r18
	cpc r25,r19
	brne .L10
	ldi r24,0
	ldi r25,0
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L10:
	ldi r24,lo8(-24)
	ldi r25,lo8(3)
	call TIMER0_DelayMS
	ldd r18,Y+3
	ldd r19,Y+4
	subi r18,-1
	sbci r19,-1
	std Y+3,r18
	std Y+4,r19
	rjmp .L9
	.size	TIMER0_DelayS, .-TIMER0_DelayS
	.section	.text.TIMER0_PWM,"ax",@progbits
.global	TIMER0_PWM
	.type	TIMER0_PWM, @function
TIMER0_PWM:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(101)
	brsh .L13
	sbi 0x17,3
	ldi r25,lo8(104)
	out 0x33,r25
	ldi r26,0
	ldi r27,0
	ldi r22,0
	mov r23,r24
	movw r24,r26
	movw r20,r24
	ldi r18,lo8(100)
	ldi r19,0
	call __udivmodsi4
	out 0x3c,r18
	in r24,0x33
	ori r24,lo8(3)
	out 0x33,r24
	ldi r24,0
	ldi r25,0
	ret
.L13:
	ldi r24,lo8(1)
	ldi r25,0
/* epilogue start */
	ret
	.size	TIMER0_PWM, .-TIMER0_PWM
	.section	.text.TIMER0_Stop,"ax",@progbits
.global	TIMER0_Stop
	.type	TIMER0_Stop, @function
TIMER0_Stop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x33
	andi r24,lo8(-8)
	out 0x33,r24
	in r24,0x33
	andi r24,lo8(-49)
	out 0x33,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	TIMER0_Stop, .-TIMER0_Stop
	.section	.text.TIMER1_Init,"ax",@progbits
.global	TIMER1_Init
	.type	TIMER1_Init, @function
TIMER1_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x2f
	andi r24,lo8(-4)
	out 0x2f,r24
	in r24,0x2e
	andi r24,lo8(-17)
	out 0x2e,r24
	in r24,0x2e
	ori r24,lo8(8)
	out 0x2e,r24
	ldi r24,lo8(-25)
	ldi r25,lo8(3)
	out 0x2a+1,r25
	out 0x2a,r24
	out 0x2c+1,__zero_reg__
	out 0x2c,__zero_reg__
	in r24,0x2e
	andi r24,lo8(-8)
	out 0x2e,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	TIMER1_Init, .-TIMER1_Init
	.section	.text.TIMER1_DelayMS,"ax",@progbits
.global	TIMER1_DelayMS
	.type	TIMER1_DelayMS, @function
TIMER1_DelayMS:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r20,r24
	ldi r24,lo8(16)
	out 0x38,r24
	in r25,0x2e
	andi r25,lo8(-8)
	out 0x2e,r25
	in r25,0x2e
	ori r25,lo8(2)
	out 0x2e,r25
	ldi r18,0
	ldi r19,0
.L17:
	cp r18,r20
	cpc r19,r21
	brne .L18
	in r24,0x2e
	andi r24,lo8(-8)
	out 0x2e,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
.L18:
	in __tmp_reg__,0x38
	sbrs __tmp_reg__,4
	rjmp .L18
	out 0x38,r24
	subi r18,-1
	sbci r19,-1
	rjmp .L17
	.size	TIMER1_DelayMS, .-TIMER1_DelayMS
	.section	.text.TIMER1_PWM,"ax",@progbits
.global	TIMER1_PWM
	.type	TIMER1_PWM, @function
TIMER1_PWM:
	push r28
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	mov r28,r22
	cpi r22,lo8(101)
	brsh .L25
	movw r18,r24
	subi r18,16
	sbc r19,__zero_reg__
	cpi r18,17
	sbci r19,78
	brsh .L25
	sbi 0x11,5
	ldi r18,lo8(-126)
	out 0x2f,r18
	ldi r18,lo8(26)
	out 0x2e,r18
	movw r18,r24
	ldi r20,0
	ldi r21,0
	ldi r22,lo8(64)
	ldi r23,lo8(66)
	ldi r24,lo8(15)
	ldi r25,0
	call __udivmodsi4
	movw r24,r18
	movw r26,r20
	sbiw r24,1
	out 0x26+1,r25
	out 0x26,r24
	in r18,0x26
	in r19,0x26+1
	subi r18,-1
	sbci r19,-1
	mov r26,r28
	ldi r27,0
	call __umulhisi3
	ldi r18,lo8(100)
	ldi r19,0
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	out 0x2a+1,r19
	out 0x2a,r18
	ldi r24,0
	ldi r25,0
.L22:
/* epilogue start */
	pop r28
	ret
.L25:
	ldi r24,lo8(1)
	ldi r25,0
	rjmp .L22
	.size	TIMER1_PWM, .-TIMER1_PWM
	.section	.text.TIMER1_Stop,"ax",@progbits
.global	TIMER1_Stop
	.type	TIMER1_Stop, @function
TIMER1_Stop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	in r24,0x2e
	andi r24,lo8(-8)
	out 0x2e,r24
	in r24,0x2f
	andi r24,lo8(63)
	out 0x2f,r24
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	TIMER1_Stop, .-TIMER1_Stop
	.ident	"GCC: (GNU) 15.2.0"
