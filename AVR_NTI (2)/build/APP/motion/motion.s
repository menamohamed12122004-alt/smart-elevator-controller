	.file	"motion.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.MOT_Init,"ax",@progbits
.global	MOT_Init
	.type	MOT_Init, @function
MOT_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts current_motion_state,__zero_reg__
	sts current_motion_state+1,__zero_reg__
	sts target_position_cm,__zero_reg__
	sts target_position_cm+1,__zero_reg__
	sts target_position_cm+2,__zero_reg__
	sts target_position_cm+3,__zero_reg__
	sts current_target_speed,__zero_reg__
	sts current_target_speed+1,__zero_reg__
	sts current_target_speed+2,__zero_reg__
	sts current_target_speed+3,__zero_reg__
	jmp PWM_Init
	.size	MOT_Init, .-MOT_Init
	.section	.text.MOT_GoTo,"ax",@progbits
.global	MOT_GoTo
	.type	MOT_GoTo, @function
MOT_GoTo:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts target_position_cm,r22
	sts target_position_cm+1,r23
	sts target_position_cm+2,r24
	sts target_position_cm+3,r25
	ldi r24,lo8(1)
	ldi r25,0
	sts current_motion_state,r24
	sts current_motion_state+1,__zero_reg__
	ldi r24,0
/* epilogue start */
	ret
	.size	MOT_GoTo, .-MOT_GoTo
	.section	.text.MOT_Stop,"ax",@progbits
.global	MOT_Stop
	.type	MOT_Stop, @function
MOT_Stop:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(5)
	sts current_motion_state,r24
	sts current_motion_state+1,__zero_reg__
	sts current_target_speed,__zero_reg__
	sts current_target_speed+1,__zero_reg__
	sts current_target_speed+2,__zero_reg__
	sts current_target_speed+3,__zero_reg__
	ldi r22,0
	ldi r24,0
	jmp PWM_SetDutyCycle
	.size	MOT_Stop, .-MOT_Stop
	.section	.text.MOT_Step,"ax",@progbits
.global	MOT_Step
	.type	MOT_Step, @function
MOT_Step:
	push r12
	push r13
	push r14
	push r15
	push r28
	push r29
	in r28,__SP_L__
	in r29,__SP_H__
	sbiw r28,8
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 8 */
/* stack size = 14 */
.L__stack_usage = 14
	std Y+1,__zero_reg__
	std Y+2,__zero_reg__
	std Y+3,__zero_reg__
	std Y+4,__zero_reg__
	movw r24,r28
	adiw r24,1
	call POS_GetCm
	or r24,r25
	breq .+2
	rjmp .L4
	ldd r18,Y+1
	ldd r19,Y+2
	ldd r20,Y+3
	ldd r21,Y+4
	lds r22,target_position_cm
	lds r23,target_position_cm+1
	lds r24,target_position_cm+2
	lds r25,target_position_cm+3
	call __subsf3
	movw r12,r22
	movw r14,r24
	ldi r20,0
	ldi r21,0
	movw r18,r20
	call __ltsf2
	sbrs r24,7
	rjmp .L6
	bst r15,7
	com r15
	bld r15,7
	com r15
.L6:
	lds r24,current_motion_state
	lds r25,current_motion_state+1
	cpi r24,3
	cpc r25,__zero_reg__
	brne .+2
	rjmp .L8
	brsh .L9
	cpi r24,1
	cpc r25,__zero_reg__
	breq .L10
	sbiw r24,2
	brne .L12
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(-64)
	ldi r21,lo8(64)
	movw r22,r12
	movw r24,r14
	call __lesf2
	cp __zero_reg__,r24
	brlt .+2
	rjmp .L20
	rjmp .L14
.L9:
	cpi r24,4
	cpc r25,__zero_reg__
	brne .+2
	rjmp .L13
	sbiw r24,5
	brne .L14
.L12:
	sts current_target_speed,__zero_reg__
	sts current_target_speed+1,__zero_reg__
	sts current_target_speed+2,__zero_reg__
	sts current_target_speed+3,__zero_reg__
.L14:
	lds r24,current_motion_state
	lds r25,current_motion_state+1
	cpi r24,5
	cpc r25,__zero_reg__
	breq .L26
	or r24,r25
	breq .+2
	rjmp .L27
.L26:
	ldi r22,0
.L39:
	ldi r24,0
	call PWM_SetDutyCycle
.L4:
/* epilogue start */
	adiw r28,8
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r15
	pop r14
	pop r13
	pop r12
	ret
.L10:
	lds r24,current_target_speed
	lds r25,current_target_speed+1
	lds r26,current_target_speed+2
	lds r27,current_target_speed+3
	std Y+5,r24
	std Y+6,r25
	std Y+7,r26
	std Y+8,r27
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(72)
	ldi r21,lo8(66)
	movw r22,r24
	movw r24,r26
	call __ltsf2
	sbrs r24,7
	rjmp .L15
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(32)
	ldi r21,lo8(65)
	ldd r22,Y+5
	ldd r23,Y+6
	ldd r24,Y+7
	ldd r25,Y+8
	call __addsf3
	sts current_target_speed,r22
	sts current_target_speed+1,r23
	sts current_target_speed+2,r24
	sts current_target_speed+3,r25
.L15:
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(-64)
	ldi r21,lo8(64)
	movw r22,r12
	movw r24,r14
	call __lesf2
	cp __zero_reg__,r24
	brlt .L37
.L20:
	ldi r24,lo8(3)
.L38:
	sts current_motion_state,r24
	sts current_motion_state+1,__zero_reg__
	rjmp .L14
.L37:
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(72)
	ldi r21,lo8(66)
	lds r22,current_target_speed
	lds r23,current_target_speed+1
	lds r24,current_target_speed+2
	lds r25,current_target_speed+3
	call __gesf2
	sbrc r24,7
	rjmp .L14
	ldi r24,lo8(2)
	rjmp .L38
.L8:
	lds r24,current_target_speed
	lds r25,current_target_speed+1
	lds r26,current_target_speed+2
	lds r27,current_target_speed+3
	std Y+5,r24
	std Y+6,r25
	std Y+7,r26
	std Y+8,r27
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(-96)
	ldi r21,lo8(64)
	movw r22,r24
	movw r24,r26
	call __gtsf2
	cp __zero_reg__,r24
	brge .L22
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(32)
	ldi r21,lo8(65)
	ldd r22,Y+5
	ldd r23,Y+6
	ldd r24,Y+7
	ldd r25,Y+8
	call __subsf3
	sts current_target_speed,r22
	sts current_target_speed+1,r23
	sts current_target_speed+2,r24
	sts current_target_speed+3,r25
.L22:
	ldi r18,0
	ldi r19,0
	ldi r20,0
	ldi r21,lo8(64)
	movw r22,r12
	movw r24,r14
	call __lesf2
	cp __zero_reg__,r24
	brge .+2
	rjmp .L14
	ldi r24,lo8(4)
	rjmp .L38
.L13:
	ldi r26,lo8(-96)
	ldi r27,lo8(64)
	sts current_target_speed,__zero_reg__
	sts current_target_speed+1,__zero_reg__
	sts current_target_speed+2,r26
	sts current_target_speed+3,r27
	ldi r18,lo8(-51)
	ldi r19,lo8(-52)
	ldi r20,lo8(76)
	ldi r21,lo8(62)
	movw r22,r12
	movw r24,r14
	call __lesf2
	cp __zero_reg__,r24
	brge .+2
	rjmp .L14
	call MOT_Stop
	rjmp .L14
.L27:
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(72)
	ldi r21,lo8(66)
	lds r22,current_target_speed
	lds r23,current_target_speed+1
	lds r24,current_target_speed+2
	lds r25,current_target_speed+3
	call __divsf3
	ldi r18,0
	ldi r19,0
	ldi r20,lo8(127)
	ldi r21,lo8(67)
	call __mulsf3
	call __fixunssfsi
	rjmp .L39
	.size	MOT_Step, .-MOT_Step
	.section	.bss.current_target_speed,"aw",@nobits
	.type	current_target_speed, @object
	.size	current_target_speed, 4
current_target_speed:
	.zero	4
	.section	.bss.target_position_cm,"aw",@nobits
	.type	target_position_cm, @object
	.size	target_position_cm, 4
target_position_cm:
	.zero	4
	.section	.bss.current_motion_state,"aw",@nobits
	.type	current_motion_state, @object
	.size	current_motion_state, 2
current_motion_state:
	.zero	2
.global	__fixunssfsi
.global	__mulsf3
.global	__divsf3
.global	__gtsf2
.global	__gesf2
.global	__lesf2
.global	__addsf3
.global	__ltsf2
.global	__subsf3
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
