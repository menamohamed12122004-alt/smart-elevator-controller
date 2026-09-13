	.file	"GPIO.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.section	.text.GPIO_SetPinDirection,"ax",@progbits
.global	GPIO_SetPinDirection
	.type	GPIO_SetPinDirection, @function
GPIO_SetPinDirection:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(4)
	brlo .+2
	rjmp .L2
	cpi r22,lo8(8)
	brlo .+2
	rjmp .L2
	cpi r20,lo8(3)
	brlo .+2
	rjmp .L2
	tst r20
	breq .+2
	rjmp .L3
	cpi r24,lo8(1)
	breq .L6
	cpi r24,lo8(1)
	brlo .L5
	cpi r24,lo8(2)
	breq .L7
	cpi r24,lo8(3)
	breq .+2
	rjmp .L4
	rjmp .L20
.L5:
	in r24,58-32
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp 2f
1:	lsl r18
	rol r19
2:	dec r22
	brpl 1b
	com r18
	and r24,r18
	out 58-32,r24
	in r24,59-32
	and r18,r24
	out 59-32,r18
	rjmp .L4
.L6:
	in r24,55-32
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp 2f
1:	lsl r18
	rol r19
2:	dec r22
	brpl 1b
	com r18
	and r24,r18
	out 55-32,r24
	in r24,56-32
	and r18,r24
	out 56-32,r18
	rjmp .L4
.L7:
	in r24,52-32
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp 2f
1:	lsl r18
	rol r19
2:	dec r22
	brpl 1b
	com r18
	and r24,r18
	out 52-32,r24
	in r24,53-32
	and r18,r24
	out 53-32,r18
	rjmp .L4
.L20:
	in r24,49-32
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp 2f
1:	lsl r18
	rol r19
2:	dec r22
	brpl 1b
	com r18
	and r24,r18
	out 49-32,r24
	in r24,50-32
	and r18,r24
	out 50-32,r18
	rjmp .L4
.L3:
	cpi r20,lo8(1)
	brne .L10
	cpi r24,lo8(1)
	breq .L12
	cpi r24,lo8(1)
	brlo .L11
	cpi r24,lo8(2)
	breq .L13
	cpi r24,lo8(3)
	breq .+2
	rjmp .L4
	rjmp .L21
.L11:
	in r18,58-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	or r18,r24
	out 58-32,r18
	rjmp .L4
.L12:
	in r18,55-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	or r18,r24
	out 55-32,r18
	rjmp .L4
.L13:
	in r18,52-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	or r18,r24
	out 52-32,r18
	rjmp .L4
.L21:
	in r18,49-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	or r18,r24
	out 49-32,r18
	rjmp .L4
.L10:
	cpi r24,lo8(1)
	breq .L16
	cpi r24,lo8(1)
	brlo .L15
	cpi r24,lo8(2)
	breq .L17
	cpi r24,lo8(3)
	breq .+2
	rjmp .L4
	rjmp .L22
.L15:
	in r19,58-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	mov r18,r24
	com r18
	and r18,r19
	out 58-32,r18
	in r18,59-32
	or r24,r18
	out 59-32,r24
	rjmp .L4
.L16:
	in r19,55-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	mov r18,r24
	com r18
	and r18,r19
	out 55-32,r18
	in r18,56-32
	or r24,r18
	out 56-32,r24
	rjmp .L4
.L17:
	in r19,52-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	mov r18,r24
	com r18
	and r18,r19
	out 52-32,r18
	in r18,53-32
	or r24,r18
	out 53-32,r24
	rjmp .L4
.L22:
	in r19,49-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	mov r18,r24
	com r18
	and r18,r19
	out 49-32,r18
	in r18,50-32
	or r24,r18
	out 50-32,r24
	rjmp .L4
.L2:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L9
.L4:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L9:
	movw r24,r18
/* epilogue start */
	ret
	.size	GPIO_SetPinDirection, .-GPIO_SetPinDirection
	.section	.text.GPIO_SetPinValue,"ax",@progbits
.global	GPIO_SetPinValue
	.type	GPIO_SetPinValue, @function
GPIO_SetPinValue:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(4)
	brlo .+2
	rjmp .L24
	cpi r22,lo8(8)
	brlo .+2
	rjmp .L24
	cpi r20,lo8(2)
	brlo .+2
	rjmp .L24
	cpi r20,lo8(1)
	brne .L25
	cpi r24,lo8(1)
	breq .L28
	cpi r24,lo8(1)
	brlo .L27
	cpi r24,lo8(2)
	breq .L29
	cpi r24,lo8(3)
	breq .+2
	rjmp .L26
	rjmp .L37
.L27:
	in r18,59-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	or r18,r24
	out 59-32,r18
	rjmp .L26
.L28:
	in r18,56-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	or r18,r24
	out 56-32,r18
	rjmp .L26
.L29:
	in r18,53-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	or r18,r24
	out 53-32,r18
	rjmp .L26
.L37:
	in r18,50-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	or r18,r24
	out 50-32,r18
	rjmp .L26
.L25:
	cpi r24,lo8(1)
	breq .L33
	cpi r24,lo8(1)
	brlo .L32
	cpi r24,lo8(2)
	breq .L34
	cpi r24,lo8(3)
	brne .L26
	rjmp .L38
.L32:
	in r18,59-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	com r24
	and r24,r18
	out 59-32,r24
	rjmp .L26
.L33:
	in r18,56-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	com r24
	and r24,r18
	out 56-32,r24
	rjmp .L26
.L34:
	in r18,53-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	com r24
	and r24,r18
	out 53-32,r24
	rjmp .L26
.L38:
	in r18,50-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	com r24
	and r24,r18
	out 50-32,r24
	rjmp .L26
.L24:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L31
.L26:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L31:
	movw r24,r18
/* epilogue start */
	ret
	.size	GPIO_SetPinValue, .-GPIO_SetPinValue
	.section	.text.GPIO_GetPinValue,"ax",@progbits
.global	GPIO_GetPinValue
	.type	GPIO_GetPinValue, @function
GPIO_GetPinValue:
/* prologue: function */
/* frame size = 0 */
	movw r30,r20
	cpi r24,lo8(4)
	brsh .L40
	cpi r22,lo8(8)
	brsh .L40
	cp r20,__zero_reg__
	cpc r21,__zero_reg__
	breq .L40
	cpi r24,lo8(1)
	breq .L43
	cpi r24,lo8(1)
	brlo .L42
	cpi r24,lo8(2)
	breq .L44
	cpi r24,lo8(3)
	brne .L48
	rjmp .L45
.L42:
	in r24,57-32
.L49:
	ldi r25,lo8(0)
	rjmp 2f
1:	lsr r25
	ror r24
2:	dec r22
	brpl 1b
	andi r24,lo8(1)
	st Z,r24
.L48:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L46
.L43:
	in r24,54-32
	rjmp .L49
.L44:
	in r24,51-32
	rjmp .L49
.L45:
	in r24,48-32
	rjmp .L49
.L40:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
.L46:
	movw r24,r18
/* epilogue start */
	ret
	.size	GPIO_GetPinValue, .-GPIO_GetPinValue
	.section	.text.GPIO_TogglePinValue,"ax",@progbits
.global	GPIO_TogglePinValue
	.type	GPIO_TogglePinValue, @function
GPIO_TogglePinValue:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(4)
	brsh .L51
	cpi r22,lo8(8)
	brsh .L51
	cpi r24,lo8(1)
	breq .L54
	cpi r24,lo8(1)
	brlo .L53
	cpi r24,lo8(2)
	breq .L55
	cpi r24,lo8(3)
	brne .L59
	rjmp .L56
.L53:
	in r18,59-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	eor r18,r24
	out 59-32,r18
.L59:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L57
.L54:
	in r18,56-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	eor r18,r24
	out 56-32,r18
	rjmp .L59
.L55:
	in r18,53-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	eor r18,r24
	out 53-32,r18
	rjmp .L59
.L56:
	in r18,50-32
	ldi r24,lo8(1)
	ldi r25,hi8(1)
	rjmp 2f
1:	lsl r24
	rol r25
2:	dec r22
	brpl 1b
	eor r18,r24
	out 50-32,r18
	rjmp .L59
.L51:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
.L57:
	movw r24,r18
/* epilogue start */
	ret
	.size	GPIO_TogglePinValue, .-GPIO_TogglePinValue
	.section	.text.GPIO_SetPortDirection,"ax",@progbits
.global	GPIO_SetPortDirection
	.type	GPIO_SetPortDirection, @function
GPIO_SetPortDirection:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(4)
	brlo .L61
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L62
.L61:
	cpi r24,lo8(1)
	breq .L65
	cpi r24,lo8(1)
	brlo .L64
	cpi r24,lo8(2)
	breq .L66
	cpi r24,lo8(3)
	brne .L69
	rjmp .L67
.L64:
	out 58-32,r22
	rjmp .L69
.L65:
	out 55-32,r22
	rjmp .L69
.L66:
	out 52-32,r22
	rjmp .L69
.L67:
	out 49-32,r22
.L69:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L62:
	movw r24,r18
/* epilogue start */
	ret
	.size	GPIO_SetPortDirection, .-GPIO_SetPortDirection
	.section	.text.GPIO_SetPortValue,"ax",@progbits
.global	GPIO_SetPortValue
	.type	GPIO_SetPortValue, @function
GPIO_SetPortValue:
/* prologue: function */
/* frame size = 0 */
	cpi r24,lo8(4)
	brlo .L71
	ldi r18,lo8(1)
	ldi r19,hi8(1)
	rjmp .L72
.L71:
	cpi r24,lo8(1)
	breq .L75
	cpi r24,lo8(1)
	brlo .L74
	cpi r24,lo8(2)
	breq .L76
	cpi r24,lo8(3)
	brne .L79
	rjmp .L77
.L74:
	out 59-32,r22
	rjmp .L79
.L75:
	out 56-32,r22
	rjmp .L79
.L76:
	out 53-32,r22
	rjmp .L79
.L77:
	out 50-32,r22
.L79:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
.L72:
	movw r24,r18
/* epilogue start */
	ret
	.size	GPIO_SetPortValue, .-GPIO_SetPortValue
	.section	.text.GPIO_GetPortValue,"ax",@progbits
.global	GPIO_GetPortValue
	.type	GPIO_GetPortValue, @function
GPIO_GetPortValue:
/* prologue: function */
/* frame size = 0 */
	movw r30,r22
	cpi r24,lo8(4)
	brsh .L81
	cp r22,__zero_reg__
	cpc r23,__zero_reg__
	breq .L81
	cpi r24,lo8(1)
	breq .L84
	cpi r24,lo8(1)
	brlo .L83
	cpi r24,lo8(2)
	breq .L85
	cpi r24,lo8(3)
	brne .L89
	rjmp .L86
.L83:
	in r24,57-32
.L90:
	st Z,r24
.L89:
	ldi r18,lo8(0)
	ldi r19,hi8(0)
	rjmp .L87
.L84:
	in r24,54-32
	rjmp .L90
.L85:
	in r24,51-32
	rjmp .L90
.L86:
	in r24,48-32
	rjmp .L90
.L81:
	ldi r18,lo8(1)
	ldi r19,hi8(1)
.L87:
	movw r24,r18
/* epilogue start */
	ret
	.size	GPIO_GetPortValue, .-GPIO_GetPortValue
