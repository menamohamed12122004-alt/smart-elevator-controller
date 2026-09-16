	.file	"door.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Door_Init,"ax",@progbits
.global	Door_Init
	.type	Door_Init, @function
Door_Init:
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
	ldi r22,lo8(2)
	ldi r24,lo8(1)
	call EXTI_Init
	ldi r22,lo8(gs(Door_CheckSafety))
	ldi r23,hi8(gs(Door_CheckSafety))
	ldi r24,lo8(1)
	call EXTI_SetCallBack
	sts g_DoorState,__zero_reg__
	sts g_DoorState+1,__zero_reg__
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	Door_Init, .-Door_Init
	.section	.text.Door_Open,"ax",@progbits
.global	Door_Open
	.type	Door_Open, @function
Door_Open:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_DoorState
	lds r25,g_DoorState+1
	sbiw r24,1
	breq .L3
	ldi r20,0
	ldi r22,lo8(1)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r20,lo8(1)
	ldi r22,0
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r24,lo8(1)
	sts g_DoorState,r24
	sts g_DoorState+1,__zero_reg__
.L3:
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	Door_Open, .-Door_Open
	.section	.text.Door_CheckSafety,"ax",@progbits
.global	Door_CheckSafety
	.type	Door_CheckSafety, @function
Door_CheckSafety:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_DoorState
	lds r25,g_DoorState+1
	cpi r24,3
	cpc r25,__zero_reg__
	breq .L8
	or r24,r25
	brne .L7
.L8:
	jmp Door_Open
.L7:
/* epilogue start */
	ret
	.size	Door_CheckSafety, .-Door_CheckSafety
	.section	.text.Door_Close,"ax",@progbits
.global	Door_Close
	.type	Door_Close, @function
Door_Close:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_DoorState
	lds r25,g_DoorState+1
	sbiw r24,0
	breq .L14
	sbiw r24,3
	breq .L14
	ldi r20,0
	ldi r22,0
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	ldi r20,lo8(1)
	ldi r22,lo8(1)
	ldi r24,lo8(1)
	call GPIO_SetPinValue
	sts g_DoorState,__zero_reg__
	sts g_DoorState+1,__zero_reg__
.L14:
	ldi r24,0
	ldi r25,0
/* epilogue start */
	ret
	.size	Door_Close, .-Door_Close
	.section	.text.Door_GetState,"ax",@progbits
.global	Door_GetState
	.type	Door_GetState, @function
Door_GetState:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_DoorState
	lds r25,g_DoorState+1
/* epilogue start */
	ret
	.size	Door_GetState, .-Door_GetState
	.section	.bss.g_DoorState,"aw",@nobits
	.type	g_DoorState, @object
	.size	g_DoorState, 2
g_DoorState:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
