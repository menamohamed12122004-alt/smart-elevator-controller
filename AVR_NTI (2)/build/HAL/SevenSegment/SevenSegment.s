	.file	"SevenSegment.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.SevenSegment_Display,"ax",@progbits
.global	SevenSegment_Display
	.type	SevenSegment_Display, @function
SevenSegment_Display:
/* prologue: function */
/* frame size = 0 */
	cpi r22,lo8(10)
	brlo .L2
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L3
.L2:
	mov r30,r22
	ldi r31,lo8(0)
	subi r30,lo8(-(segmentPatterns.1228))
	sbci r31,hi8(-(segmentPatterns.1228))
	ld r22,Z
	call GPIO_SetPortValue
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L3:
	movw r24,r18
/* epilogue start */
	ret
	.size	SevenSegment_Display, .-SevenSegment_Display
	.section	.text.SevenSegment_Init,"ax",@progbits
.global	SevenSegment_Init
	.type	SevenSegment_Init, @function
SevenSegment_Init:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(4)
	brlo .L6
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L7
.L6:
	ldi r22,lo8(-1)
	call GPIO_SetPortDirection
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L7:
	movw r24,r18
/* epilogue start */
	ret
	.size	SevenSegment_Init, .-SevenSegment_Init
	.section	.rodata.segmentPatterns.1228,"a",@progbits
	.type	segmentPatterns.1228, @object
	.size	segmentPatterns.1228, 10
segmentPatterns.1228:
	.byte	63
	.byte	6
	.byte	91
	.byte	79
	.byte	102
	.byte	109
	.byte	125
	.byte	7
	.byte	127
	.byte	111
.global __do_copy_data
