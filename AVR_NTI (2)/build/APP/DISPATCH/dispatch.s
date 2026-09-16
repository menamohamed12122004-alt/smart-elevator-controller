	.file	"dispatch.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.Dispatch_Init,"ax",@progbits
.global	Dispatch_Init
	.type	Dispatch_Init, @function
Dispatch_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts g_u8FloorRequests,__zero_reg__
	sts g_u8FloorRequests+1,__zero_reg__
	sts g_u8FloorRequests+2,__zero_reg__
	sts g_u8FloorRequests+3,__zero_reg__
/* epilogue start */
	ret
	.size	Dispatch_Init, .-Dispatch_Init
	.section	.text.Dispatch_UpdateQueue,"ax",@progbits
.global	Dispatch_UpdateQueue
	.type	Dispatch_UpdateQueue, @function
Dispatch_UpdateQueue:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brsh .L2
	mov r30,r24
	ldi r31,0
	subi r30,lo8(-(g_u8FloorRequests))
	sbci r31,hi8(-(g_u8FloorRequests))
	st Z,r22
.L2:
/* epilogue start */
	ret
	.size	Dispatch_UpdateQueue, .-Dispatch_UpdateQueue
	.section	.text.Dispatch_ClearFloorRequest,"ax",@progbits
.global	Dispatch_ClearFloorRequest
	.type	Dispatch_ClearFloorRequest, @function
Dispatch_ClearFloorRequest:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	cpi r24,lo8(4)
	brsh .L4
	mov r30,r24
	ldi r31,0
	subi r30,lo8(-(g_u8FloorRequests))
	sbci r31,hi8(-(g_u8FloorRequests))
	st Z,__zero_reg__
.L4:
/* epilogue start */
	ret
	.size	Dispatch_ClearFloorRequest, .-Dispatch_ClearFloorRequest
	.section	.text.Dispatch_GetNextFloor,"ax",@progbits
.global	Dispatch_GetNextFloor
	.type	Dispatch_GetNextFloor, @function
Dispatch_GetNextFloor:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	mov r18,r24
	ldi r19,0
	cpi r22,1
	cpc r23,__zero_reg__
	brne .L7
	movw r24,r18
.L28:
	adiw r24,1
	cpi r24,4
	cpc r25,__zero_reg__
	brlt .L11
	movw r24,r18
.L29:
	sbiw r24,1
	brcc .L14
.L32:
	ldi r24,lo8(-1)
	ret
.L11:
	movw r30,r24
	subi r30,lo8(-(g_u8FloorRequests))
	sbci r31,hi8(-(g_u8FloorRequests))
	ld r20,Z
	cpi r20,lo8(1)
	brne .L28
.L10:
/* epilogue start */
	ret
.L14:
	movw r30,r24
	subi r30,lo8(-(g_u8FloorRequests))
	sbci r31,hi8(-(g_u8FloorRequests))
	ld r18,Z
	cpi r18,lo8(1)
	brne .L29
	ret
.L7:
	cpi r22,2
	cpc r23,__zero_reg__
	brne .L15
	movw r24,r18
.L30:
	sbiw r24,1
	brcc .L18
	movw r24,r18
.L31:
	adiw r24,1
	cpi r24,4
	cpc r25,__zero_reg__
	brge .L32
	movw r30,r24
	subi r30,lo8(-(g_u8FloorRequests))
	sbci r31,hi8(-(g_u8FloorRequests))
	ld r18,Z
	cpi r18,lo8(1)
	brne .L31
	ret
.L18:
	movw r30,r24
	subi r30,lo8(-(g_u8FloorRequests))
	sbci r31,hi8(-(g_u8FloorRequests))
	ld r20,Z
	cpi r20,lo8(1)
	brne .L30
	ret
.L15:
	subi r18,lo8(-(g_u8FloorRequests))
	sbci r19,hi8(-(g_u8FloorRequests))
	movw r30,r18
	ld r25,Z
	cpi r25,lo8(1)
	breq .L10
	ldi r30,lo8(g_u8FloorRequests)
	ldi r31,hi8(g_u8FloorRequests)
	ldi r24,0
	ldi r25,0
.L23:
	ld r18,Z
	cpi r18,lo8(1)
	breq .L10
	adiw r30,1
	adiw r24,1
	cpi r24,4
	cpc r25,__zero_reg__
	brne .L23
	rjmp .L32
	.size	Dispatch_GetNextFloor, .-Dispatch_GetNextFloor
	.section	.bss.g_u8FloorRequests,"aw",@nobits
	.type	g_u8FloorRequests, @object
	.size	g_u8FloorRequests, 4
g_u8FloorRequests:
	.zero	4
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
