
  DC8   __FILE__
  ALIGNROM 2


AT  MACRO
  ldr t, [t]
  ENDM

ATN  MACRO
  DUP
  AT
  ENDM

atn ; (addr -- addr, x)
  DUP
at  ; (addr -- x)   fetch via TOS
  AT
  NEXT


ATK MACRO lit
  DUP
  mov32 t, lit
  ENDM

atk ; ( -- x)   fetch via ilk
  DUP
  ldr x, [i], #4
  ldr t, [x]
  NEXT


uatn  ; (addr -- addr, x) fetch via TOS, un-aligned, non-destructive
  DUP
uat ; (addr -- x)   fetch via TOS, un-aligned
  bic w, t, #3
  ldr x, [w]    ; lo word
  ldr y, [w, #4]  ; hi word
  ands  w, t, #3

  moveq t, x    ; done if 3 LSbits are 0
  ldreq PC, [i], #4 ; cond'l NEXT

  movs  w, w, lsl #3  ; ? aligned *8 bits?
  movne x, x, lsr w
  rsbne w, w, #32
  orrne t, x, y, lsl w
  NEXT


uatk  ; ( -- x)   fetch via ilk, un-aligned
  DUP
  ldr t, [i], #4

  b uat


BEatn ; (addr -- addr, x) fetch via TOS, un-aligned, BIG-endian
  DUP

BEat  ; (addr -- x)   fetch via TOS, un-aligned, BIG-endian
  mov x, t
  eor t, t, t
  ldrb  w, [x], #1
  orr t, w, t   ;, lsl #8
  ldrb  w, [x], #1
  orr t, w, t, lsl #8
  ldrb  w, [x], #1
  orr t, w, t, lsl #8
  ldrb  w, [x]    ;, #1
  orr t, w, t, lsl #8
  NEXT


BEatk ; ( -- x)   fetch via ilk, un-aligned, BIG-endian
  DUP
  ldr t, [i], #4

  b BEat


ustr  ; ( x, addr -- )  ! store un-aligned, little-endian
  strb  n, [t], #1  ; LSB
  mov n, n, lsr #8
  strb  n, [t], #1
  mov n, n, lsr #8
  strb  n, [t], #1
  mov n, n, lsr #8
  strb  n, [t]  ;, #1 ; MSB
  mov n, n  ;, lsr #8
  DDROP
  NEXT


BEstr ; ( x, addr -- )  ! store un-aligned, BIG-endian
  mov n, n, ror #24
  strb  n, [t], #1  ; MSB
  mov n, n, ror #24
  strb  n, [t], #1  ; 
  mov n, n, ror #24
  strb  n, [t], #1  ; 
  mov n, n, ror #24
  strb  n, [t]  ;, #1 ; LSB
  DDROP
  NEXT


stor  ; (x, addr -- )   store
  str n, [t]
  DDROP
  NEXT


strn  ; (x, addr -- x)  store, non-destructive
  str n, [t]
  DROP
  NEXT


strnn ; (x, addr -- x, addr)  store, doubly non-destructive
  str n, [t]
  NEXT


strr  ; ( addr, x -- )  store reversed
  str t, [n]
  DDROP
  NEXT


strrn ; ( addr, x -- addr ) store reversed, preserve addr
  str t, [n]
  DROP
  NEXT


strrnn  ; (  --  )  store reversed, preserve stack
  str t, [n]
  NEXT


strk  ; (x -- )   store via ilk
  ldr x, [i], #4
  str t, [x]
  DROP
  NEXT


strkk ; ( -- )    store ilk1 via ilk2
  ldr w, [i], #4
  ldr x, [i], #4
  str w, [x]
  NEXT


strkn ; (x -- x)    store via ilk, non-destructive
  ldr x, [i], #4
  str t, [x]
  NEXT


movkk ; ( -- )    move [src.ilk1] to [dst.ilk2]
  ldr w, [i], #4
  ldr x, [i], #4
  ldr w, [w]
  str w, [x]
  NEXT


pstrk ; ( x -- )    add ToS to ilk@
  ldr x, [i], #4
  ldr w, [x]
  add w, w, t
  str w, [x]
  DROP
  NEXT


pstrkk  ; ( -- )  delta.ilk1,  addr.ilk2
  ldr k, [i], #4
  ldr x, [i], #4
  ldr w, [x]
  add w, w, k
  str w, [x]
  NEXT


atkadd  ; ( x -- x + [@ilk])  addr.ilk -- @+, converse of +!
  ldr x, [i], #4
  ldr w, [x]
  add t, t, w
  NEXT


dpstrk  ; ( d -- )    add double to ilk@
  ldr y, [i], #4      ; ptr
  ldr x, [y], #4      ; lsW
  ldr w, [y], #-4     ; msW
  adds  n, n, x
  str     n, [y], #4
  adc     t, t, w
  str t, [y]
  DDROP
  NEXT


dstrk ; ( d -- )    add double to ilk@
  ldr x, [i], #4      ; ptr
;  strd n,t, [x], #8
  str n, [x], #4
  str t, [x]
  DDROP
  NEXT


dstrkk
  ldrd x,y, [i], #8
  ldr  w, [i], #4
  strd x,y, [w]
  NEXT
 

dsub  ; ( d1, d2 -- d ) subtract double
  ldrd  x,y, [p], #8      ; msW
; ldr x, [p], #4      ; lsW
; ldr y, [p], #4      ; msW
  subs  n, x, n      ; lsW
  sbc t, y, t      ; msW
  NEXT


datk  ; ( -- d )    fetch double, ilk@
  DDUP
  ldr x, [i], #4      ; ptr
;  ldrd  n,t, [x]      ; 
  ldr n, [x], #4      ; lsW
  ldr t, [x]         ; msW
  NEXT


//    >>> file:  v4memref.a43 
//   v4memref_a43;  simple memory-reference operators
//   datk ; ( -- d)   fetch double via ilk
//   datn ; (addr -- addr, x) fetch double, non-destructive
//   dat  ; (addr -- x)   fetch double
//   batn ; (addr -- addr, n.8) fetch signed byte,  non-destructive
//   bat  ; (addr -- n.8)   fetch signed byte (sign-extended)
//   batk ; ( -- n.8)   fetch  signed byte via ilk
//   ubatn  ; (addr -- addr, u.8) fetch  un-signed byte, non-destructive



uhatn ; (addr -- addr, x)
  DUP


uhat  ; (addr -- x)   fetch via TOS
  ldrh  t, [t]
  NEXT


uhatk ; ( -- x)   fetch via ilk
  DUP
  ldr x, [i], #4
  ldrh  t, [x]
  NEXT


shatn
hatn  ; (addr -- addr, x)
  DUP


shat
hat ; (addr -- x)   fetch via TOS
  ldrsh t, [t]
  NEXT


shatk
hatk  ; ( -- x)   fetch via ilk
  DUP
  ldr x, [i], #4
  ldrsh t, [x]
  NEXT


hstr  ; (x, @ -- )    store via ilk
  strh  n, [t]
  DDROP
  NEXT


hstrk ; (x -- )   store via ilk
  ldr x, [i], #4
  strh  t, [x]
  DROP
  NEXT


BAT MACRO
  ldrsb t, [t]
  ENDM


sbat
bat ; (addr -- u.8)   fetch  signed-extended byte
  BAT
  NEXT


sbatk
batk  ; ( -- x)   fetch signed-extended byte via ilk
  DUP
  ldr x, [i], #4
  ldrsb t, [x]
  NEXT


UBAT  MACRO
  ldrb  t, [t]
  ENDM


ubat  ; (addr -- u.8)   fetch  un-signed byte (zero-extended)
  UBAT
  NEXT


ubatn ; (addr -- addr, u.8)   fetch  un-signed byte (zero-extended)
  DUP
  UBAT
  NEXT


ubatk ; ( -- x)   fetch via ilk
  DUP
  ldr x, [i], #4
  ldrb  t, [x]
  NEXT


bstr  ; ( byte, @ -- )  store NOS.8 via TOS
  strb  n, [t]
  DDROP
  NEXT


bstrr ; ( @, byte -- )  store TOS.8 via NOS
  strb  t, [n]
  DDROP
  NEXT


bstrrn  ; ( @, byte -- @ )  store TOS.8 via NOS
  strb  t, [n]
  DROP
  NEXT


bstrk ; (x -- )   store byte.8 via ilk
  ldr x, [i], #4
  strb  t, [x]
  DROP
  NEXT


bstrkk  ; ( -- )    store byte.8.ilk1 via ilk2
  ldr w, [i], #4
  ldr x, [i], #4
  strb  w, [x]
  NEXT


rmwkk ; ( x -- )  addr.ilk1,  mask.ilk2
  ldr x, [i], #4
  ldr y, [i], #4
  ldr w, [x]
  bic w, w, y
  and t, t, y
  orr w, w, t
  str w, [x]
  DROP
  NEXT


rmwamd
rmwkkk  ; ( -- )  addr.ilk1,  mask.ilk2,  bits.ilk3
  ldr x, [i], #4
  ldr y, [i], #4
  ldr k, [i], #4
  ldr w, [x]
  bic w, w, y
  and k, k, y
  orr w, w, k
  str w, [x]
  NEXT


hrmwkk  ; ( x -- )  addr.ilk1,  mask.ilk2
  ldr x, [i], #4
  ldr y, [i], #4
  ldrh  w, [x]
  bic w, w, y
  and t, t, y
  orr w, w, t
  strh  w, [x]
  DROP
  NEXT


brmwkk  ; ( x -- )  addr.ilk1,  mask.ilk2
  ldr x, [i], #4
  ldr y, [i], #4
  ldrb  w, [x]
  bic w, w, y
  and t, t, y
  orr w, w, t
  strb  w, [x]
  DROP
  NEXT



//   ubatk  ; ( -- u.8)   fetch  un-signed byte via ilk
//   strrn  ; (addr, x -- addr) store-reversed, non-destructive
//   strrnn ; (addr, x -- addr, x)  store-reversed, doubly non-destructive
//   strrk  ; (addr -- )    store ilk via TOS
//   strrkn ; (addr -- addr)  store ilk via TOS, non-destructive
//   bstr ; (x.8, addr -- ) store byte
//   bstrn  ; (x.8, addr -- x.8)  store byte, non-destructive
//   bstrnn ; (x.8, addr -- x.8, addr)  store byte, doubly non-destructive
//   bstrk  ; (x.8 -- )   store byte via ilk
//   bstrkn ; (x.8 -- x.8)    store byte via ilk, non-destructive
//   bstrr  ; (addr, x.8 -- ) store byte, reversed
//   bstrrn ; (addr, x.8 -- addr) store byte, reversed, non-destructive
//   bstrrnn  ; (addr, x.8 -- addr, x.8)  store byte, reversed, doubly non-destructive
//   bstrrk ; (addr -- )    store ilk.8 via TOS
//   bstrrkn  ; (addr -- addr)  store ilk.8 via TOS, non-destructive
//   pstr ; (x, addr -- )   +!, add TOS to mem
//   pstrn  ; (x, addr -- x)  +!, non-destructive
//   pstrnn ; (x, addr -- x, addr)  +!, doubly non-destructive
//   pstrk  ; (x -- )   +! via ilk
//   pstrkn ; (x -- x)    +! via ilk, non-destructive
//   pstrr  ; (addr, x -- )   +!-reversed
//   pstrrn ; (addr, x -- addr) +!-reversed, non-destructive
//   pstrrnn  ; (addr, x -- addr, x)  +!-reversed, doubly non-destructive
//   pstrrk ; (addr -- )    +! ilk via TOS
//   pstrrkn  ; (addr -- addr)  +! ilk via TOS, non-destructive
//   bpstr  ; (x.8, addr -- ) +! byte
//   bpstrn ; (x.8, addr -- x.8)  +! byte, non-destructive
//   bpstrnn  ; (x.8, addr -- x.8, addr)  +! byte, doubly non-destructive
//   bpstrk ; (x.8 -- )   +! byte via ilk
//   bpstrkn  ; (x.8 -- x.8)    +! byte via ilk, non-destructive
//   bpstrr ; (addr, x.8 -- ) +! byte, reversed
//   bpstrrn  ; (addr, x.8 -- addr) +! byte, reversed, non-destructive
//   bpstrrnn ; (addr, x.8 -- addr, x.8) +! byte, reversed, doubly non-destructive
//   bpstrrk  ; (addr -- )    +! ilk.8 via TOS
//   bpstrrkn ; (addr -- addr)  +! ilk.8 via TOS, non-destructive
//   dstr ; (d, addr -- )
//   dstrn  ; (d, addr -- d)
//   dstrnn ; ( -- )
//   dstrk  ; (d -- )   store double via ilk
//   dstrkn ; ( -- )    store double via ilk, non-destructive
//   dstrkk ; ( -- )    store double-literal ilk2H:ilk1L via ilk3
//   dstrkkr  ; ( -- )    store double-literal ilk3H:ilk2L via ilk1
//   dstrr  ; unf
//   dstrrn ; unf
//   dstrrnn  ; unf
//   dstrrk ; unf
//   dstrrkn  ; unf
//   dpstrk ; (d -- )   +! double via ilk
//   
//   
