	.file	"elevator_app.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Elevator_Init,"ax",@progbits
.global	Elevator_Init
	.type	Elevator_Init, @function
Elevator_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	call Door_Init
	sts g_ElevatorState,__zero_reg__
	sts g_ElevatorState+1,__zero_reg__
/* epilogue start */
	ret
	.size	Elevator_Init, .-Elevator_Init
	.section	.text.Elevator_Run,"ax",@progbits
.global	Elevator_Run
	.type	Elevator_Run, @function
Elevator_Run:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_ElevatorState
	lds r25,g_ElevatorState+1
	cpi r24,2
	cpc r25,__zero_reg__
	breq .L3
	brlo .L2
	sbiw r24,3
	breq .L5
.L7:
	sts g_ElevatorState,__zero_reg__
	sts g_ElevatorState+1,__zero_reg__
.L2:
/* epilogue start */
	ret
.L3:
	call Door_Open
	rjmp .L7
.L5:
	call Door_Close
	ldi r24,lo8(1)
	sts g_ElevatorState,r24
	sts g_ElevatorState+1,__zero_reg__
	ret
	.size	Elevator_Run, .-Elevator_Run
	.section	.bss.g_ElevatorState,"aw",@nobits
	.type	g_ElevatorState, @object
	.size	g_ElevatorState, 2
g_ElevatorState:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
