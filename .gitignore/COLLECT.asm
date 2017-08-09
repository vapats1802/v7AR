

ror8
  mov t, t, ror #8
  NEXT



GenHash8char
  NEST
  DC32  rrand,i2x8$d
  DC32  nexit



i2x8$d  ; ( -- )  uint-to-ASCIIz hex via PADx, (implicitly) non-destructive
  ldr x, PADxpp ; ptr to PADx
  ldr x, [x]    ; get PADx
  adr k, nybl2hex ; ptr to LUT

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov w, #0   ; print null
  strb  w, [x]    ; str to PAD

  ldr w, PADxpp ; ptr to PADx
  str x, [w]    ; PADx now points to next free 'printable' byte
  DROP
  NEXT


nybl2hex  DC8 '0123456789ABCDEF'  ; nybble-to-hex digit LUT
PADxpp  DC32  PADx    ; lit ptr to PADx



bickk:  ; ( -- )
  ldr w, [i], #4
  ldr X, [i], #4
  ldr Y, [X]
  bic Y, Y, w
  str Y, [X]
  NEXT



delay
wt  ; spin/wait
  nop
_wt subs  t, t, #1
  bne _wt

  DROP
  NEXT



wk  ; spin/wait
  ldr k, [i], #4
_wk subs  k, k, #1
  bne _wk

  NEXT



bstrn ; ( byte, @ -- byte ) store TOS.8 via NOS
  strb  n, [t]
  DROP
  NEXT



hpsa16gen ; (x -- x') ; HPSA16 m-seq generator
  mov w, #0
  movs  x, t, lsl #17
  adc w, w, #0
  movs  x, t, lsl #21
  adc w, w, #0
  movs  x, t, lsl #24
  adc w, w, #0
  movs  x, t, lsl #26
  adc w, w, #0
  movs  t, t, lsl #1
  movs  w, w, rrx
  adc t, t, #0
  NEXT


lotfor  ; lesser on top, flag on Rstack TRUE iff t>n, ZERO if n>=t
  cmp t, n
  movle w, #0 ; t<=n
  movgt w, #-1  ; t>n
  str w, [r, #-4]!
  movgt w, t
  movgt t, n
  movgt n, w
  NEXT


gotfor  ; greater on top, flag on Rstack TRUE iff t>=n, ZERO if n>t
  cmp t, n
  movlt w, #0 ; t<n
  movge w, #-1  ; t>=n
  str w, [r, #-4]!
  movlt w, t
  movlt t, n
  movlt n, w
  NEXT


pstrkn  ; ( -- )    add ToS to ilk@, non-destructive
  ldr x, [i], #4
  ldr w, [x]
  add w, w, t
  str w, [x]
  NEXT


rpstrk  ; ( x -- x' )   reflective +! :  add ilk@ to ToS, update memory
  ldr x, [i], #4
  ldr w, [x]
  add t, w, t
  str t, [x]
  NEXT


uxsqrt  ; (+d -- +sqrt) 64 --> 32 +ve integer only
  mov k, #32
  mov w, #80000000h
  mov x, #80000000h
_uxsqiter
  umull Rb,a, w, w
  cmp t, a    ; MSp.32
  cmpeq n, Rb   ; LSp.32
  eorlo w, w, x
  mov x, x, lsr #1
  eor w, w, x
  subs  k, k, #1
  bne _uxsqiter

  mov t, w
  NIP
  NEXT



dadd
  ldr w, [p], #4  ; MS
  ldr x, [p], #4  ; LS
  adds  n, n, x   ; LS
  adc t, t, w   ; MS
  NEXT



dlslk8
//  mov t, t, lsl #8
  mov w, n, lsr #24
  orr t, w, t, lsl #8
  mov n, n, lsl #8
  NEXT



dlslk16
//  mov t, t, lsl #16
  mov w, n, lsr #16
  orr t, w, t, lsl #16
  mov n, n, lsl #16
  NEXT



rn48to24
  mov t, t, lsl #24
  mov n, n, lsr #8
  orr t, t, n
  NIP
  NEXT



lot ; lesser on top
  cmp t, n
  movgt w, t
  movgt t, n
  movgt n, w
  NEXT



got ; greater on top
  cmp t, n
  movlt w, t
  movlt t, n
  movlt n, w
  NEXT



u2BCD ; ( u -- 8bcd:8bcd )
  DUP
  mov x,t
  eor t,t,t
  eor n,n,n

  movs  n,x, lsr #29  ; 3 MSbs of x --> 3 LSbs of n
  movs  x,x, lsl #3 ; scrag 3 MSbs

  mov k, #29
_u2BCD
  and w,n,#0Fh  ; units
  cmp w,  #05h
  addhs n,n,#03h
  and w,n,#0F0h ; 10
  cmp w,  #050h
  addhs n,n,#030h
  and w,n,#0F00h  ; 100
  cmp w,  #0500h
  addhs n,n,#0300h
  and w,n,#0F000h ; kilo
  cmp w,  #05000h
  addhs n,n,#03000h
  and w,n,#0F0000h  ; 10k
  cmp w,  #050000h
  addhs n,n,#030000h
  and w,n,#0F00000h ; 100k
  cmp w,  #0500000h
  addhs n,n,#0300000h
  and w,n,#0F000000h  ; Mega
  cmp w,  #05000000h
  addhs n,n,#03000000h
  and w,n,#0F0000000h ; 10M
  cmp w,  #050000000h
  addhss  n,n,#030000000h

  adccs t,t,#0
  and w,t,#0Fh  ; 100M
  cmp w,#05h
  addhs t,t,#03h

  mov t,t, lsl #1
  movs  n,n, lsl #1
  adc t,t,#0
  movs  x,x, lsl #1
  adc n,n,#0

  adds  k,k,#-1
  bne _u2BCD

  NEXT



  and w,t,#0F0h ; Giga
  cmp w,  #050h
  addge t,t,#030h
  and w,t,#0F00h  ; 10G
  cmp w,  #0500h
  addge t,t,#0300h
  and w,t,#0F000h ; 100G
  cmp w,  #05000h
  addge t,t,#03000h
  and w,t,#0F0000h  ; Tera
  cmp w,  #050000h
  addge t,t,#030000h
  and w,t,#0F00000h ; 10T
  cmp w,  #0500000h
  addge t,t,#0300000h
  and w,t,#0F000000h  ; 100T
  cmp w,  #05000000h
  addge t,t,#03000000h
  and w,t,#0F0000000h ; Peta
  cmp w,  #050000000h
  addge t,t,#030000000h



u2BCDtest
  NEST
_u2BCDtest
  DC32  cls
  DC32  flushRX1
  DC32  EZbuttons
  DC32  killButs,okBut,canBut
  DC32  ripT1

  DC32  begin
_u2BCDtestloop
  DC32  padi,texthome
  DC32  rrand
  DC32  i2x$,char2k,"  ",crlf

  DC32  atk,T1TC,tor, uui2d$
  DC32  atk,T1TC,rfrom,subb,char3k,"   ",i2x$,drop,char2k,"  ",crlf

  DC32  atk,T1TC,tor, u2BCD
  DC32  b2x$,drop,i2x8$d
  DC32  atk,T1TC,rfrom,subb,char3k,"   ",i2x$,drop,char2k,"  ",crlf

  DC32  pat,i2x$,drop
  DC32  ilk,PAD,txt

  DC32  flushRX1
  DC32  sx
  DC32  okUP,  _u2BCDtestloop
  DC32  canUP, _cold
  DC32  0

  DC32  again



PADxppp DC32  PADx
N2Xpp DC32  N2X

b2x$  ; ( -- )  uint.16-to-ASCIIz hex via PADx, (implicitly) non-destructive
  ldr x, PADxppp  ; ptr to PADx
  ldr x, [x]    ; get PADx
  ldr k, N2Xpp  ; ptr to LUT

  mov t, t, ror #4  ; "ROL 28"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov t, t, ror #28 ; "ROL 4"
  and w, t, #0Fh  ; mask LSnybble
  ldrb  w, [w, k] ; get ASCII from LUT
  strb  w, [x], #1  ; str to PAD, post-inc

  mov w, #0   ; print null
  strb  w, [x]    ; str to PAD

  ldr w, PADxppp  ; ptr to PADx
  str x, [w]    ; PADx now points to next free 'printable' byte
  NEXT



uui2d$  ; ( -- )  int-to-ASCII decimal via PADx,  (implicitly) non-destructive
  NEST
  DC32  u2d10$
  DC32  atk,PAD10x,mov$
  DC32  nexit



pstr  ; ( x, addr -- )    add TOS to [addr]
  ldr w, [t]
  add n, n, w
  str n, [t]
  DDROP
  NEXT



asrn  ;  ( x, n -- x' )   shift right by n bits, sign-extended
  mov n, n, asr t
  DROP
  NEXT



mtosat  ; ( -- x )  retrieve MARK'd TOS
  DUP
  ldr x, [SP]
  ldr t, [x]
  NEXT



mtosstr ; ( x -- )  re-store MARK'd TOS
  ldr x, [SP]
  str t, [x]
  DROP
  NEXT



mtosstrn  ; ( -- )  re-store MARK'd TOS
  ldr x, [SP]
  str t, [x]
  NEXT



MARK  MACRO   ; NEST with context save
  str i, [r, #-4]!  ; save IP to Rstack
  str r, [SP, #-4]! ; save RP to Sstack
  DDUP      ; save cached TOS, NOS
  str p, [SP, #-4]! ; save PP to Sstack
  mov i, PC   ; .+8 --> IP, no adj't needed for ARM7 pipeline
  NEXT      ; begin metacode xeq'n
  ENDM



mark  MARK



MEXIT MACRO
  ldr p, [SP], #4 ; restore PP from Sstack
  DDROP     ; restore TOS, NOS to cache registers
  ldr r, [SP], #4 ; restore RP from Sstack
  NEXIT
  ENDM


mexit MEXIT



UNMARK  MACRO
  ldr p, [SP], #4 ; restore PP from Sstack
  DDROP     ; restore TOS, NOS to cache registers
  ldr r, [SP], #4 ; restore RP from Sstack
  add r, r, #4  ; un-NEST:  forget thread
  NEXT
  ENDM



unmark  UNMARK



atxeq ; ( PtrToEntryPtr -- )
  mov x, t
  DROP
  ldr PC, [x]



Pmon
  NEST
  DC32  savposk,254
  DC32  texthome,padi,i2x$,char2k,"  ",swap,i2x$,char2k,"  ",swap
  DC32  pat,addk,4,i2x$,drop,char2k,"  "
//  DC32  mtosat,i2x$,drop    ; PatPtr
  DC32  ilk,PAD,txt
  DC32  rstposk,254
  DC32  nexit



dneq  ; ( x1,x2,  x3,x4 -- f )  true iff d1 <> d2
  ldr w, [p], #4
  ldr x, [p], #4
  eor t, t, w
  eor n, n, x
  orr t, t, n
  ldr n, [p], #4
  NEXT



dsqrt ; (+d -- +sqrt) positive int, *NOT* unsigned!!!
  mov k, #32
  mov w, #80000000h
  mov x, #80000000h
_difter
  umull rb, a, w, w
  cmp t, a    ; MSp.32
  cmpeq n, rb   ; LSp.32
  eorlo w, w, x
  mov x, x, lsr #1
  eor w, w, x
  subs  k, k, #1
  bne _difter

  mov t, w
  NIP
  NEXT



dst NEST
  DC32  true

  DC32  begin
  DC32  crc32g,dup,zero,swap
  DC32  dsqrt
  DC32  dup,mull,nip
  DC32  drop,again



touppercase
  NEST
  DC32  uboundkkn,"a","z", zbr, _isnotlowercase

  DC32  subk,20h
_isnotlowercase
  DC32  nexit





swapmem ; ( ptr1, ptr2 -- )
  ldr w, [t]
  ldr x, [n]
  str x, [t]
  str w, [n]
  DDROP
  NEXT



sx  ; IP ==> tag/jump list
; will spin forever, until it gets an actionable RX

///_sxlsr
///// bl  _SCpoll     ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

_sxlsr
  TO4TH
  DC32  qsc,recode

  ldr x, sxU1LSR
/////_sxlsr
  ldrb  w, [x]
  tst w, #1
  beq _sxlsr    ; spin until RX

  ldr x, sxU1RBR
  ldrb  k, [x]    ; get RX byte
  mov x, i    ; copy IP
_sxl
  ldr w, [x], #8  ; get tag from list, [i] now ==> next tag
  cmp k, w
  ldreq i, [x, #-4] ; jam IP (br to target from list), if match
  ldreq PC, [i], #4 ; cond'l jump/NEXT, if match

  teq w, #0 ; ? end of list?  (n.b. zero may have been matched)
  beq sx  ; spin till relevant RX, if list exhausted (zero)

  bne _sxl    ; else loop, and look further in list



sxp ; (tag -- ) IP ==> tag/jump list
; will move on past end of list, if no actionable RX

///// bl  _SCpoll     ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  mov k, t    ; copy RX byte
  DROP
_sxpl
  ldr w, [i], #8  ; get tag from list, [i] now ==> next tag
  cmp k, w
  ldreq i, [i, #-4] ; jam IP (br to target from list), if match
  ldreq PC, [i], #4 ; cond'l jump/NEXT, if match

  teq w, #0 ; ? end of list?  (n.b. zero may have been matched)
  bne _sxpl   ; else loop, and look further in list

  ldreq PC, [i], #4 ; cond'l NEXT, if end of list





reinit
  ldr t, MTp
  ldr n, MTp
  ldr SP, Sinitp
  str t, [SP]
  ldr r, Rinitp
  str t, [r]
  ldr p, Pinitp
  str t, [p]
  ldr l, Linitp
  str t, [l]
  NEXT


Sinitp  DC32  Sinit
Rinitp  DC32  Rinit
Pinitp  DC32  Pinit
Linitp  DC32  Linit
MTp DC32  0EEEEEEEEh


reinitP
  ldr t, MTp
  ldr n, MTp
  ldr p, Pinitp
  str t, [p]
  NEXT


Rmark
  ldr x, =ScriptRmark
  str r, [x]
  NEXT


reinitPRmark
  ldr t, MTp
  ldr n, MTp
  ldr p, Pinitp
  str t, [p]
  ldr r, =ScriptRmark
  ldr r, [r]
  NEXT


   LTORG

