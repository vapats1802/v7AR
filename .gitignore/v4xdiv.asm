


s2d	; ( n -- d )
	str	n, [p, #-4]!
	movs	n, t
	movmi	t, #-1
	movpl	t, #0
	NEXT




ifmul	; ( n1,n2 -- prod )  32*32-->32, signed
	smull	x,w,n,t
	mov	t, w, LSL #16		; MS.16
	orr	t, t, x, LSR #16	; LS.16
	NIP
	NEXT



midif2i	; ( n, d32.32 -- n )
        ldr     k, [p], #4
        mov     ra, #0
	movs	 t, t
	mvnmi	ra,ra	;eormi	 ra, ra, #-1
        bpl     _mmmpl

        rsbs  n, n, #0
        rsc   t, t, #0
_mmmpl
	movs	 k, k
	mvnmi	ra,ra	;eormi	 ra, ra, #-1
        rsbmi   k, k, #0

        mov     w, #0
        umull   y, x, k, n      ; LSP
        umlal   x, w, k, t      ; MSP

        movs    ra, ra
        bpl     _mmpl

        rsbs  y, y, #0
        rscs  x, x, #0
        rsc   w, w, #0
_mmpl
        adds    y, y, #1        ; compensate for floored fraction (not precise)
        adcs    x, x, #0
        adcs    w, w, #0

        mov     t, x
        NIP
        NEXT



divbrk	NEXT



xudivmod	; ( nL,nH, dL,dH -- rL,rH, qL,qH ) un-signed 64/64 divide/modulo

	ldr	w, [p], #4
	ldr	x, [p], #4
	mov	r9, #0
	mov	r8, #0
	mov	rA, w
	mov	rB, x
	orrs	k, t, n
	beq	x_264

	movs	k, #0

x_214	adds	n, n, n
	adcs	t, t, t
	bcs	x_234

	cmp	t, rA
	cmpeq	n, rB
	addls	k, k, #1
	bls	x_214

x_234
	adds	k, k, #0
	movs	t, t, rrx
	mov	n, n, rrx
x_23C
	subs	x, rB, n
	sbcs	w, rA, t
	movcs	rA, w
	movcs	rB, x
	adcs	r9, r9, r9
	adc	r8, r8, r8
	movs	t, t, lsr #1
	mov	n, n, rrx
	subs	k, k, #1
	bge	x_23C

x_264
	str	rB, [p, #-4]!	; rl
	str	rA, [p, #-4]!	; rh
	mov	n, r9	; ql
	mov	t, r8	; qh
	NEXT



xudiv	; ( nL,nH, dL,dH -- qL,qH ) un-signed 64/64 --> 64 divide

	ldr	w, [p], #4
	ldr	x, [p], #4
	mov	r9, #0
	mov	r8, #0
	mov	rA, w
	mov	rB, x
	orrs	k, t, n
	beq	y_264

	movs	k, #0

y_214	adds	n, n, n
	adcs	t, t, t
	bcs	y_234

	cmp	t, rA
	cmpeq	n, rB
	addls	k, k, #1
	bls	y_214

y_234
	adds	k, k, #0
	movs	t, t, rrx
	mov	n, n, rrx
y_23C
	subs	x, rB, n
	sbcs	w, rA, t
	movcs	rA, w
	movcs	rB, x
	adcs	r9, r9, r9
	adc	r8, r8, r8
	movs	t, t, lsr #1
	mov	n, n, rrx
	subs	k, k, #1
	bge	y_23C

y_264
	mov	n, r9	; ql
	mov	t, r8	; qh
//        add     n, n, #1        ; compensate for flooring
//        adc     t, t, #0
	NEXT



xsquo	; ( d1numer, d2denom -- dquo )	64/64-->64, signed
	NEST
 DC32 dover,nip,zlt,over,zlt,xorr, tor
 DC32 dabs,dswapfix,dabs,dswapfix
 DC32 xudiv			;xudivmod, ddnip,
 DC32 rfrom,zbr,_pxquo

 DC32 dneg
_pxquo
 DC32 divbrk,nexit



udiv2if	; ( numer, denom -- q16.16 ) un-signed 32/32 divide ---> 16.16

	mov	w, n	; MSint.32	ldr	w, [p], #4
	mov	x, #0	; LSfrac.32	ldr	x, [p], #4
	mov	n, t	; LSint.32
	mov	t, #0	; MSpad.32
	movs	n, n	; ? negative?
	mvnmi	t, t	; cond'l sign extend
	mov	r9, #0
	mov	r8, #0
	mov	rA, w
	mov	rB, x
	orrs	k, t, n
	beq	z_264

	movs	k, #0

z_214	adds	n, n, n
	adcs	t, t, t
	bcs	z_234

	cmp	t, rA
	cmpeq	n, rB
	addls	k, k, #1
	bls	z_214

z_234
	adds	k, k, #0
	movs	t, t, rrx
	mov	n, n, rrx
z_23C
	subs	x, rB, n
	sbcs	w, rA, t
	movcs	rA, w
	movcs	rB, x
	adcs	r9, r9, r9
	adc	r8, r8, r8
	movs	t, t, lsr #1
	mov	n, n, rrx
	subs	k, k, #1
	bge	z_23C

z_264
	mov	t, r8, LSL #16	; int.16
	orr	t, t, r9, LSR #16	; frac.16
	NIP
	NEXT



msquo2if	; ( numer.32, denom.32 -- ifquo )	32/32-->16.16,
		; signed, guarded with defaults
	movs	n, n		; ? is numerator zero?
	moveq	t, #0		; cond'l zero quotient
	ldreq	n, [p], #4	; cond'l NIP
	ldreq	PC, [i], #4	; cond'l NEXT

	movs	t, t		; ? is denominator zero?
	bne	_mqok

	mov	t, #80000000h	; minint
	tst	n, #80000000h	; ? odd (negative) sign for numerator?
	NIP
	mvneq	t, t		; cond'l minint --> maxint
	NEXT


_mqok	NEST
 DC32 over,zlt,over,zlt,xorr, tor
 DC32 abs,swap,abs,swap
 DC32 udiv2if			;
 DC32 rfrom,zbr,_pmquo

 DC32 negg
_pmquo
 DC32 mxbrk
 DC32 nexit



mxbrk	NEXT



iifmul2i:	; (int, intfrac -- int)  32*16.16-->32, signed
ifimul2i:	; (intfrac, int -- int)  16.16*32-->32, signed
	smull	x,w,n,t
	NIP	; 
	adds	x, x, #8000h
	adc	w, w, #0
	mov	t,w, lsl #16
	orr	t,t,x, lsr #16
	NEXT



ifmul2i:	; (intfrac, intfrac -- int)  16.16*16.16-->32, signed
	smull	x,w,n,t
	NIP	; 
	mov	t,w
	adds	x, x, #80000000h
	adc	t, t, #0
	NEXT



DDNIP	MACRO
	add	p, p, #8	; old 5thOS is now 3rdOS
	ENDM

ddnip	; (x1, x2, x3, x4 -- x3, x4) 3rdOS and 4thOS disappear
	DDNIP
	NEXT



DNEG	MACRO
	rsbs	n, n, #0
	rsc	t, t, #0
	ENDM

dneg	; (x -- -x)
	DNEG
	NEXT



DABS	MACRO
	teq	t, #0
	bpl	.+12		; branch offset = 4 in opcode

	rsbs	n, n, #0
	rsc	t, t, #0
	ENDM

dabs     ; ( x -- |x| )		absolute value
	DABS
	NEXT



dswapfix	; (x1,x2, x3,x4 -- x3,x4, x1,x2)
	ldr	w, [p]
	str	t, [p]
	mov	t, w
	ldr	x, [p, #4]
	str	n, [p, #4]
	mov	n, x
	NEXT



umul:	; (n1,n2 -- LSp,MSp)  32*32-->64, un-signed
	umull	x,w,n,t
	mov	n,x
	mov	t,w
	NEXT



dstrkn
        ldr     x, [i], #4
	str	n, [x], #4
	str	t, [x]
	NEXT



dat	; ( addr -- xL,xH)	load double via TOS
	DNN
	ldr	n, [t], #4
	ldr	t, [t]
	NEXT



datk	; ( -- xL,xH)	load double via ilk
	DDUP
	ldr	x, [i], #4
	ldr	n, [x], #4
	ldr	t, [x]
	NEXT



xsr1	; ( x1, x2 -- x3 )	;
	movs	t, t, rrx
	movs	n, n, rrx
	NEXT



xsl1	; ( x1, x2 -- x3 )	;
	mov	t, t, lsl #1
	movs	n, n, lsl #1
	adc	t, t, #0
	NEXT



nzp	; ( x -- f3 )	f3 = -1, 0, or 1
	movs	t, t		;
	movmi	t, #-1
	movpl	t, #1
	moveq	t, #0
	NEXT



nzpn	; ( x -- x, f3 )	f3 = -1, 0, or 1
	str	n, [p, #-4]!
	movs	n, t		; DUP with cc update
	movmi	t, #-1
	movpl	t, #1
	moveq	t, #0
	NEXT



qnzp	; ( x, f3 -- [+|0|-]x )   apply f3's sign, or zero
	teq	t, #0
	rsbmi	t, n, #0
	movpl	t, n
	moveq	t, #0
	NIP
	NEXT





xsl8 ;<<<<<<<<<<<<<<<<< gibberish
	mov	t, t, lsl #24
	orr	t, t, n, lsr #8
	NIP
	NEXT



xlsrk
	ldr	w, [i], #4
	rsb	x, w, #32
	mov	t, t, lsl x
	orr	n, t, n, lsr w
	NEXT



xudivMonteCarlo
	NEST
 DC32 strkk,-1,CRC32

 DC32 begin
 DC32 zero, atk,CRC32,crc32g
/// DC32 dup,crc32g
// DC32 dstrkn,Svar	; num'r
 DC32 dup
/// DC32 andk,07FFFFFFFh
 DC32 strkn,(CRC32-16)	;
 DC32 swap,crc32g
 DC32 strkn,CRC32	;
/// DC32 andk,07FFFFFFFh
 DC32 zero	;dup,crc32g
// DC32 dstrkn,Rnum	; den'r
 DC32 udiv2if	;xudivmod
 DC32 drop			;ddrop,ddrop
 DC32 again

// DC32 atk,Rnum,atk,(Rnum+4)
// DC32 umul
// DC32 dadd
// DC32 





///// DC32 stopwatch	;CalibrateWait	;RPF
///// DC32 begin, inc, texthome,padi,i2x$,ilk,PAD,txt, again
 DC32 ilk,0FFh,ilk,0FFFh,ilk,07h,ilk,00h,xudivmod	;,stop
 DC32 xudivMonteCarlo



