
  DC8   __FILE__
  ALIGNROM 2


mull: ; (n1,n2 -- LSp,MSp)  32*32-->64, signed
  smull x,w,n,t
  mov n,x
  mov t,w
  NEXT


udivmod:  ; (u1,u2 -- rem=u1.mod.u2, quo=u1/u2) 32/32-->32, un-signed
  teq t, #0
  moveq n, #0
  ldreq PC, [i], #4 ;
  teq n, #0
  moveq t, #0
  ldreq PC, [i], #4 ;

  mov w, #1   ; MOV Rcnt,#1 ; control bit for division.
_div1:  cmp t, #0x80000000  ; Div1 CMP Rb,#0x80000000 ; until Rb > Ra.
  cmplo t, n    ; CMPCC Rb,Ra
  movlo t, t, LSL#1 ; MOVCC Rb,Rb,ASL#1
  movlo w, w, LSL#1 ; MOVCC Rcnt,Rcnt,ASL#1
  blo _div1   ; BCC Div1
        ;
  mov x, #0   ; MOV Rc,#0
_div2:  cmp n, t    ; Div2 CMP Ra,Rb ; possible subtraction.
  subhs n, n, t   ; SUBCS Ra,Ra,Rb ; Subtract if ok,
  addhs x, x, w   ; ADDCS Rc,Rc,Rcnt ; relevant bit into result
  movs  w, w, LSR#1 ; MOVS Rcnt,Rcnt,LSR#1 ; shift control bit
  movne t, t, LSR#1 ; MOVNE Rb,Rb,LSR#1 ; halve unless finished.
  bne _div2   ; BNE Div2

  mov t, x
  NEXT


squo  ; ( n1, n2 -- quo ) 32/32-->32, signed
  NEST
  DC32  over,zlt,over,zlt,xorr, tor
  DC32  abs,swap,abs,swap
  DC32  udivmod,nip, rfrom,zbr,_pquo

  DC32  negg
_pquo
  DC32  nexit


sdiv32 ; ( n1, n2 -- quo=n1/n2 )  32/32-->32, signed
  sdiv  t,n,t
  NIP
  NEXT


udiv32 ; ( u1, u2 -- quo=u1/u2 )  32/32-->32, unsigned
  udiv  t,n,t
  NIP
  NEXT


umod32 ; ( u1, u2 -- modulus )  32 modulo 32 --> 32, unsigned
  udiv  w,n,t
  mul  x,w,t
  sub t,n,x
  NIP
  NEXT


usqrt
isqrt ; (u -- usqrt)  +ve integer only
  mov k, #16
  mov w, #8000h
  mov x, #8000h
_sqiter
  mul a, w, w
  cmp t, a    ; LSp.32
  eorlo w, w, x
  mov x, x, lsr #1
  eor w, w, x
  subs  k, k, #1
  bne _sqiter

  mov t, w
  NEXT


ifsqrt  ; (u -- usqrt.16:frac.16) int.frac
  mov k, #32
  mov w, #80000000h
  mov x, #80000000h
_sifter
  umull rb, a, w, w
  cmp t, a    ; MSp.32
  eorlo w, w, x
  mov x, x, lsr #1
  eor w, w, x
  subs  k, k, #1
  bne _sifter

  mov t, w
  NEXT


;   v4muldiv_a43;  multiply, divide, modulo, sqrt
;   mul2d  ; ( n1, n2 -- LSp,MSp )
;   umul2ud  ; ( u1, u2 -- uLSp,uMSp )
;   mulsat ; (n1, n2 -- n'.16) saturates.16 if (discarded) signed MSproduct
;   umulsat  ; (u1, u2 -- u'.16)  saturates.16 if (discarded) unsigned MSproduct >0
;   uxmul  ; (ud1, ud2 -- uq)  .32*.32 --> .64, unsigned
;   xmul ; (d1, d2 -- q)   .32*.32 --> .64, signed
;   ifmulsat ; (i.f1, i.f2 -- i.f') 16.16*16.16 --> 16.16, signed, with saturation
;   mul2d  ; ( n1, n2 -- MSp, LSp )
;   umul2ud  ; ( u1, u2 -- uMSp, uLSp )
;   mulsat ; ( n1, n2 -- n.16 )  saturates.16 if (discarded) signed MSproduct
;   umulsat  ; ( u1, u2 -- u.16 ) saturates.16 if (discarded) unsigned MSproduct >0
;   uxmul  ; (ud1, ud2 -- uq)  .32*.32 --> .64, unsigned
;   xmul ; (d1, d2 -- q)   .32*.32 --> .64, signed
;   ifmulsat ; (i.f1, i.f2 -- i.f') 16.16*16.16 --> 16.16, signed, with saturation
;   udivmod  ; ( u1, u2 -- uquo, urem ) nonsense if u2 > u1, use uxdiv <<<<<
;   udiv ; ( u1, u2 -- uquo )  ; unf
;   modd
;   umod ; ( u1, u2 -- mod ) ;
;   divmod ; ( n1, n2 -- quo, urem );
;   div  ; ( n1, n2 -- quo ) ; unf
;   #define  ah  r8  ;high word of a
;   #define  al  r9  ;low word of a
;   #define  xnh r10 ;high word of result
;   #define  xnl r11 ;low word of result
;   sqrt ; ( u -- u.frac )
;   ifsqrt ; ( u.frac -- u.frac' )   unsigned int.frac sqrt
;   div2if ; (n1, n2 -- int.frac') signed int.frac division
;   uifdiv ; (u.frac1, u.frac2 -- u.frac') unsigned int.frac division
;   ifdiv  ; (int.frac1, int.frac2 -- int.frac') signed int.frac division
;   urec ; (u -- .frac)  unsigned reciprocal <<<<< wrong nomen
;   rec  ; (n -- .frac)  reciprocal  <<<<<  (.frac -- n) ?????
;   uifrec ; (uint.frac -- .frac)  unsigned reciprocal <<<<< wrong nomen
;   ifrec  ; (int.frac -- .frac) reciprocal
