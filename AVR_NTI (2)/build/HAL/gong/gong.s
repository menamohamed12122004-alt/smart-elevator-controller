	.file	"gong.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.GONG_Init,"ax",@progbits
.global	GONG_Init
	.type	GONG_Init, @function
GONG_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts s_currentMode,__zero_reg__
	sts s_currentMode+1,__zero_reg__
	sts s_timerTicks,__zero_reg__
	sts s_timerTicks+1,__zero_reg__
	sts s_sequenceStep,__zero_reg__
	call TIMER1_Init
	jmp TIMER1_Stop
	.size	GONG_Init, .-GONG_Init
	.section	.text.GONG_Stop,"ax",@progbits
.global	GONG_Stop
	.type	GONG_Stop, @function
GONG_Stop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call TIMER1_Stop
	sts s_currentMode,__zero_reg__
	sts s_currentMode+1,__zero_reg__
	sts s_timerTicks,__zero_reg__
	sts s_timerTicks+1,__zero_reg__
	sts s_sequenceStep,__zero_reg__
/* epilogue start */
	ret
	.size	GONG_Stop, .-GONG_Stop
	.section	.text.GONG_Play,"ax",@progbits
.global	GONG_Play
	.type	GONG_Play, @function
GONG_Play:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts s_currentMode,r24
	sts s_currentMode+1,r25
	sts s_timerTicks,__zero_reg__
	sts s_timerTicks+1,__zero_reg__
	sts s_sequenceStep,__zero_reg__
	cpi r24,3
	cpc r25,__zero_reg__
	breq .L4
	brsh .L5
	cpi r24,1
	cpc r25,__zero_reg__
	breq .L6
	sbiw r24,2
	breq .L7
.L8:
	jmp GONG_Stop
.L5:
	sbiw r24,4
	brne .L8
	ldi r22,lo8(50)
	ldi r24,lo8(-48)
	ldi r25,lo8(7)
	call TIMER1_PWM
	sts s_timerTicks,__zero_reg__
	sts s_timerTicks+1,__zero_reg__
/* epilogue start */
	ret
.L6:
	ldi r22,lo8(50)
	ldi r24,lo8(-24)
	ldi r25,lo8(3)
	call TIMER1_PWM
	ldi r24,lo8(50)
	sts s_timerTicks,r24
	sts s_timerTicks+1,__zero_reg__
	ret
.L7:
	ldi r22,lo8(50)
	ldi r24,lo8(-24)
	ldi r25,lo8(3)
	call TIMER1_PWM
	ldi r24,lo8(25)
.L11:
	sts s_timerTicks,r24
	sts s_timerTicks+1,__zero_reg__
	ldi r24,lo8(1)
	sts s_sequenceStep,r24
	ret
.L4:
	ldi r22,lo8(50)
	ldi r24,lo8(-48)
	ldi r25,lo8(7)
	call TIMER1_PWM
	ldi r24,lo8(20)
	rjmp .L11
	.size	GONG_Play, .-GONG_Play
	.section	.text.GONG_Update,"ax",@progbits
.global	GONG_Update
	.type	GONG_Update, @function
GONG_Update:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r18,s_currentMode
	lds r19,s_currentMode+1
	cp r18,__zero_reg__
	cpc r19,__zero_reg__
	breq .L12
	lds r24,s_timerTicks
	lds r25,s_timerTicks+1
	sbiw r24,0
	brne .L15
.L20:
	cpi r18,3
	cpc r19,__zero_reg__
	breq .L16
	cpi r18,4
	cpc r19,__zero_reg__
	breq .L12
	cpi r18,2
	cpc r19,__zero_reg__
	brne .L22
	lds r24,s_sequenceStep
	cpi r24,lo8(1)
	brne .L21
	call TIMER1_Stop
	ldi r24,lo8(10)
	sts s_timerTicks,r24
	sts s_timerTicks+1,__zero_reg__
	ldi r24,lo8(2)
.L28:
	sts s_sequenceStep,r24
.L12:
/* epilogue start */
	ret
.L15:
	sbiw r24,1
	sts s_timerTicks,r24
	sts s_timerTicks+1,r25
	or r24,r25
	breq .L20
	ret
.L21:
	cpi r24,lo8(2)
	brne .L22
	ldi r22,lo8(50)
	ldi r24,lo8(-18)
	ldi r25,lo8(2)
	call TIMER1_PWM
	ldi r24,lo8(25)
	sts s_timerTicks,r24
	sts s_timerTicks+1,__zero_reg__
	ldi r24,lo8(3)
	rjmp .L28
.L22:
	jmp GONG_Stop
.L16:
	lds r24,s_sequenceStep
	cpi r24,lo8(1)
	brne .L23
	call TIMER1_Stop
	ldi r24,lo8(20)
	sts s_timerTicks,r24
	sts s_timerTicks+1,__zero_reg__
	sts s_sequenceStep,__zero_reg__
	ret
.L23:
	ldi r22,lo8(50)
	ldi r24,lo8(-48)
	ldi r25,lo8(7)
	call TIMER1_PWM
	ldi r24,lo8(20)
	sts s_timerTicks,r24
	sts s_timerTicks+1,__zero_reg__
	ldi r24,lo8(1)
	rjmp .L28
	.size	GONG_Update, .-GONG_Update
	.section	.bss.s_sequenceStep,"aw",@nobits
	.type	s_sequenceStep, @object
	.size	s_sequenceStep, 1
s_sequenceStep:
	.zero	1
	.section	.bss.s_timerTicks,"aw",@nobits
	.type	s_timerTicks, @object
	.size	s_timerTicks, 2
s_timerTicks:
	.zero	2
	.section	.bss.s_currentMode,"aw",@nobits
	.type	s_currentMode, @object
	.size	s_currentMode, 2
s_currentMode:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
