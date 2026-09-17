	.file	"safety.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.SAF_Init,"ax",@progbits
.global	SAF_Init
	.type	SAF_Init, @function
SAF_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts g_eActiveFault,__zero_reg__
	sts g_eActiveFault+1,__zero_reg__
/* epilogue start */
	ret
	.size	SAF_Init, .-SAF_Init
	.section	.text.SAF_Evaluate,"ax",@progbits
.global	SAF_Evaluate
	.type	SAF_Evaluate, @function
SAF_Evaluate:
	push r16
/* prologue: function */
/* frame size = 0 */
/* stack size = 1 */
.L__stack_usage = 1
	cpi r24,lo8(1)
	breq .L4
	ldi r24,lo8(2)
	ldi r25,0
	cpi r22,lo8(1)
	breq .L3
	ldi r24,lo8(3)
	ldi r25,0
	cpi r20,lo8(1)
	breq .L3
	cpi r18,-23
	sbci r19,-3
	brsh .L7
	ldi r24,0
	ldi r25,0
	cpi r16,lo8(1)
	brne .L3
	ldi r24,lo8(5)
	ldi r25,0
	rjmp .L3
.L4:
	ldi r24,lo8(1)
	ldi r25,0
.L3:
	sts g_eActiveFault,r24
	sts g_eActiveFault+1,__zero_reg__
/* epilogue start */
	pop r16
	ret
.L7:
	ldi r24,lo8(4)
	ldi r25,0
	rjmp .L3
	.size	SAF_Evaluate, .-SAF_Evaluate
	.section	.text.SAF_IsActive,"ax",@progbits
.global	SAF_IsActive
	.type	SAF_IsActive, @function
SAF_IsActive:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	ldi r24,lo8(1)
	lds r18,g_eActiveFault
	lds r19,g_eActiveFault+1
	or r18,r19
	brne .L10
	ldi r24,0
.L10:
/* epilogue start */
	ret
	.size	SAF_IsActive, .-SAF_IsActive
	.section	.text.SAF_GetActiveFault,"ax",@progbits
.global	SAF_GetActiveFault
	.type	SAF_GetActiveFault, @function
SAF_GetActiveFault:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,g_eActiveFault
	lds r25,g_eActiveFault+1
/* epilogue start */
	ret
	.size	SAF_GetActiveFault, .-SAF_GetActiveFault
	.section	.bss.g_eActiveFault,"aw",@nobits
	.type	g_eActiveFault, @object
	.size	g_eActiveFault, 2
g_eActiveFault:
	.zero	2
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
