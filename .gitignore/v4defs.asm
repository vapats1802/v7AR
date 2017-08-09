
NEXT	MACRO
	ldr	PC, [i], #4	; xeq next metacodon @IP
	ENDM


NEST	MACRO
	str	i, [R, #-4]!	; save IP to Rstack
	mov	i, PC		; no adj. needed for ARM7 pipeline
	NEXT			; begin metacode xeq'n
	ENDM


NEXIT	MACRO
	ldr	i, [R], #4	; restore IP from Rstack
	NEXT
	ENDM

next:				; use instead of "recode \n\t NEXT"
nexit:	ldr	i, [R], #4	; restore IP from Rstack
	ldr	PC, [i], #4



tocode:	mov	PC, i


RE4TH	MACRO
	mov	i, PC		; no adjust't needed for ARM7 pipeline
	NEXT			; begin metacode xeq'n
	ENDM



TO4TH	MACRO			; save IP to Rstack
	NEST
	ENDM


recode:	mov	x, i		; deek around IP --> PC chicken/egg quandary
	ldr	i, [R], #4	; restore IP from Rstack
	mov	pc, x



DN12	MACRO
	str	n, [P, #-4]!
	ENDM


DN1	MACRO
	DN12
	mov	n, t
	ENDM


DN2	MACRO
	str	n, [P, #-4]!
	str	t, [P, #-4]!
	ENDM


UP12	MACRO
	ldr	n, [P], #4
	ENDM


UP1	MACRO
	mov	t, n
	UP12
	ENDM


TUCK	MACRO
	DN12
	ENDM

tuck:	TUCK
	NEXT


DUP	MACRO
	DN1
	ENDM

dup:	DUP
	NEXT


NIP	MACRO
	UP12
	ENDM

nip:	NIP
	NEXT


DROP	MACRO
	UP1
	ENDM

drop:	DROP
	NEXT


movILK	MACRO	literal
	DN1
	mov	t, #literal
	ENDM

adrILK	MACRO	literal
	DN1
	adr	t, #literal	; 1 clk
	ENDM

ILK	MACRO	literal
	DN1
	ldr	t, [pc]		; 6 clk
	b	.+8		; branch ofst=0 in opcode
	DC32	literal
	ENDM

////ILK	MACRO	literal
////	DN1
////	ldr	t, [pc]		; 6 clk
////	add	pc,pc,#0	; pipeline is correct, = .+8
////	DD	literal
////	ENDM
////
////ILK	MACRO	literal
////	DN1
////	mov	t, # BYTE0 literal
////	mov	w, # BYTE1 literal
////	mov	x, # BYTE2 literal
////	mov	k, # BYTE3 literal
////	orr	t,t,w,lsl #8
////	orr	t,t,x,lsl #16
////	orr	t,t,k,lsl #24
////	ENDM

ilk:	DN1
	ldr	t, [i], #4
	NEXT


TRUE	MACRO
	DN1
	ldr	t, =(-1)
	ENDM

true:	TRUE
	NEXT


INC	MACRO
	add	t, t, #1
	ENDM

inc:	INC
	NEXT


ADDD	MACRO
	add	t, t, n
	UP12
	ENDM

addd:	ADDD
	NEXT


ADDK	MACRO	literal
	ldr	w, [pc,#4]	;
	add	t,t,w
	b	.+8		; branch ofst=0 in opcode
	DD	literal
	ENDM

addk:	ldr	w, [i], #4
	add	t, t, w
	UP12
	NEXT


NOTT	MACRO
	mvn	t, t
	ENDM

nott:	NOTT
	NEXT


NEGG	MACRO
	rsb	t, t, #0
	ENDM

negg:	NEGG
	NEXT


ABS	MACRO
	teq	t, #0
	rsbmi	t, t, #0
	ENDM

abs:	ABS
	NEXT


BEGIN	MACRO
	mov	x, pc		; pipeline comp'n
	str	x, [r,#-4]!
	ENDM

begin:	str	i, [r,#-4]!
	NEXT


AGAIN	MACRO
	ldr	PC, [r]
	ENDM

again:	ldr	i, [r]
	NEXT


nopp:	NEXT



mull:	; (n1,n2 -- LSp,MSp)
	smull	x,w,n,t
	mov	n,x
	mov	t,w
	NEXT



udiv:	; (u1,u2 -- rem, quo=u1/u2)
	mov	w,#1		; MOV Rcnt,#1 ; control bit for division.
_div1:	cmp	t,#0x80000000	; Div1 CMP Rb,#0x80000000 ; until Rb > Ra.
	cmplo	t,n		; CMPCC Rb,Ra
	movlo	t,t,ASL#1	; MOVCC Rb,Rb,ASL#1
	movlo	w,w,ASL#1	; MOVCC Rcnt,Rcnt,ASL#1
	blo	_div1		; BCC Div1
				; 
	mov	x,#0		; MOV Rc,#0
_div2:	cmp	n,t		; Div2 CMP Ra,Rb ; possible subtraction.
	subhs	n,n,t		; SUBCS Ra,Ra,Rb ; Subtract if ok,
	addhs	x,x,w		; ADDCS Rc,Rc,Rcnt ; relevant bit into result
	movs	w,w,LSR#1	; MOVS Rcnt,Rcnt,LSR#1 ; shift control bit
	movne	t,t,LSR#1	; MOVNE Rb,Rb,LSR#1 ; halve unless finished.
	bne	_div2		; BNE Div2
                                  
	mov	t,x
	NEXT



mseq33:	ldr	r0, =-1
	ldr	r10, =(-1)
	ldr	r11, =(-1)
	ldr	r12, =(-1)
	ldr	r1, =1

	adds	r0,r0,#1
	ands	r0,r0,#3
	movne	r1,r1,ror #1
	eor	r2,r1,r0
	tst 	r11,r11,LSR#1
	movs	r12,r10,RRX
	adc 	r11,r11,r11
	eor 	r12,r12,r10,LSL#12
	eor 	r10,r12,r12,LSR#20

