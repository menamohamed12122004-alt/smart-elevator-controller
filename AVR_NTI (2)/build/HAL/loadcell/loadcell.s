	.file	"loadcell.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
	.section	.text.LOADCELL_Init,"ax",@progbits
.global	LOADCELL_Init
	.type	LOADCELL_Init, @function
LOADCELL_Init:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sts s_isOverloaded,__zero_reg__
	sts s_sampleIdx,__zero_reg__
	sts s_samples,__zero_reg__
	sts s_samples+1,__zero_reg__
	sts s_samples+2,__zero_reg__
	sts s_samples+3,__zero_reg__
	sts s_samples+4,__zero_reg__
	sts s_samples+5,__zero_reg__
/* epilogue start */
	ret
	.size	LOADCELL_Init, .-LOADCELL_Init
	.section	.text.LOADCELL_ReadKg,"ax",@progbits
.global	LOADCELL_ReadKg
	.type	LOADCELL_ReadKg, @function
LOADCELL_ReadKg:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	movw r22,r28
	subi r22,-1
	sbci r23,-1
	ldi r24,lo8(1)
	call ADC_ReadChannel
	lds r24,s_sampleIdx
	ldi r25,0
	movw r30,r24
	lsl r30
	rol r31
	subi r30,lo8(-(s_samples))
	sbci r31,hi8(-(s_samples))
	ldd r18,Y+1
	ldd r19,Y+2
	st Z,r18
	std Z+1,r19
	adiw r24,1
	ldi r22,lo8(3)
	ldi r23,0
	call __udivmodhi4
	sts s_sampleIdx,r24
	lds r20,s_samples+4
	lds r21,s_samples+5
	lds r24,s_samples+2
	lds r25,s_samples+3
	lds r18,s_samples
	lds r19,s_samples+1
	cp r18,r24
	cpc r19,r25
	brlo .L3
	cp r20,r18
	cpc r21,r19
	brsh .L4
	cp r24,r18
	cpc r25,r19
	brne .L11
.L4:
	ldi r26,lo8(-24)
	ldi r27,lo8(3)
	call __umulhisi3
	ldi r18,lo8(-1)
	ldi r19,lo8(3)
	ldi r20,0
	ldi r21,0
	call __udivmodsi4
	cpi r18,-123
	ldi r22,3
	cpc r19,r22
	brlo .L8
	ldi r24,lo8(1)
	sts s_isOverloaded,r24
.L2:
	movw r24,r18
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
.L11:
	movw r18,r20
	cp r18,r24
	cpc r19,r25
	rjmp .L14
.L8:
	cpi r18,82
	ldi r22,3
	cpc r19,r22
	brsh .L2
	sts s_isOverloaded,__zero_reg__
	rjmp .L2
.L3:
	cp r18,r20
	cpc r19,r21
	brsh .L4
	movw r18,r20
	cp r24,r20
	cpc r25,r21
.L14:
	brsh .L4
	movw r18,r24
	rjmp .L4
	.size	LOADCELL_ReadKg, .-LOADCELL_ReadKg
	.section	.text.LOADCELL_IsOverloaded,"ax",@progbits
.global	LOADCELL_IsOverloaded
	.type	LOADCELL_IsOverloaded, @function
LOADCELL_IsOverloaded:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	lds r24,s_isOverloaded
/* epilogue start */
	ret
	.size	LOADCELL_IsOverloaded, .-LOADCELL_IsOverloaded
	.section	.bss.s_sampleIdx,"aw",@nobits
	.type	s_sampleIdx, @object
	.size	s_sampleIdx, 1
s_sampleIdx:
	.zero	1
	.section	.bss.s_samples,"aw",@nobits
	.type	s_samples, @object
	.size	s_samples, 6
s_samples:
	.zero	6
	.section	.bss.s_isOverloaded,"aw",@nobits
	.type	s_isOverloaded, @object
	.size	s_isOverloaded, 1
s_isOverloaded:
	.zero	1
	.ident	"GCC: (GNU) 15.2.0"
.global __do_clear_bss
