//
v4th_asm; ARM7 v4th nucleus
//
  DC8   __FILE__
  ALIGNROM 2

BRAND$
CryptKeeper
  DC8 'v4th'
  DC8 '  for ARMv7-R5F  0.3 ',cr,lf
  DC8 __DATE__,' ',__TIME__,cr,lf
  DC8 ' copycenter (c)   apr 2016 ',cr,lf
  DC8 ' vic plichota,  antares technical services ',cr,lf,cr,lf,0
 ALIGNROM 2


NEXT  MACRO
  ldr PC,[i],#4 ; xeq next codon
;  b SSnext ; single-step debug option
;  b BRKnext  ; breakpoint-list debug option
  ENDM

;  mov32 x,GIODOUTB
;  mov w,#1
;  str w,[x]   ; 
;  mov w,#0
;  str w,[x]   ; 

 PUBLIC brk,SSnext
brk ; explicit hi-level breakpoint
SSnext ; single-step NEXT
  ldr PC,[i],#4 ; xeq next codon

  
BRKnext ; search list of hi-level breakpoints wrt IP
  mov32 w, v4brkpts ; start of brkpt list
_scanv4brkpts
  ldr x,[w],#4
  tst x,#3
  ldrne PC,[i], #4 ; end of brkpt list iff putative pointer addr is unaligned for 32 bits

  teq x,i
  bne _scanv4brkpts ; no match, try again
  
;  bkpt  #0; match
_NEXTbrk
  ldr PC,[i],#4 ; xeq next codon


NEST  MACRO
  str i, [r, #-4]!  ; save IP to Rstack
  mov i, PC   ; no adj. needed for ARM7 pipeline
  NEXT      ; begin metacode xeq'n
  ENDM
;  mov32 x,GIODOUTB
;  mov w,#2
;  str w,[x]   ; 
;  mov w,#0
;  str w,[x]   ; 


NEXIT MACRO
  ldr i, [r], #4  ; restore IP from Rstack
  NEXT
  ENDM

 PUBLIC next,nexit
next      ; = nexit;  use instead of "recode \n NEXT"   <<<<<
nexit NEXIT

 PUBLIC tocode
tocode  mov PC, i

RE4TH MACRO
  mov i, PC   ; no adjustment needed for pipeline
  NEXT      ; begin v4th xeq'n
  ENDM


TO4TH MACRO     ; save IP to Rstack
  NEST
  ENDM

 PUBLIC recode
recode
  mov x, i    ; deek around IP --> PC chicken/egg quandary
  ldr i, [r], #4  ; restore IP from Rstack
  mov PC, x


DNN MACRO ; (x1, x2 -- x1, x1, x2)  overswap; push NOS only
  str n, [p, #-4]!
  ENDM

 PUBLIC overswap
overswap ; (x1, x2 -- x1, x1, x2)
  DNN
  NEXT


DUP MACRO
  DNN ;str n, [p, #-4]!
  mov n, t
  ENDM

 PUBLIC dup
dup ; (x -- x, x)   dup TOS
  DUP
  NEXT


DDUP  MACRO
;  strd n,t, [p, #-8]!
  str n, [p, #-4]!
  str t, [p, #-4]!
  ENDM

 PUBLIC ddup
ddup  ; (x1, x2 -- x1, x2, x1, x2)  overover
  DDUP
  NEXT


DUPDUP  MACRO
  str n, [p, #-4]!
  str t, [p, #-4]!
  mov n, t
  ENDM

 PUBLIC dupdup
dupdup  ; (x1, x2 -- x1, x2, x2, x2)
  DUPDUP
  NEXT


NIP MACRO
  ldr n, [p], #4
  ENDM

 PUBLIC nip
nip ; (x1, x2 -- x2)  swapdrop
  NIP
  NEXT


DNIP  MACRO
  ldr n, [p, #4]! ; old 4thOS
  add p, p, #4  ; old 5thOS
  ENDM

 PUBLIC dnip
dnip  ; (x1, x2, x3 -- x3)  nipnip
  DNIP
  NEXT


DROP  MACRO
  mov t, n
  ldr n, [p], #4
  ENDM

 PUBLIC drop
drop  ; (x -- )
  DROP
  NEXT


DROPDUP  MACRO
  mov t, n
  ENDM

 PUBLIC dropdup
dropdup  ; ( x1, x2, -- x1, x1 )
  DROPDUP
  NEXT


TUCK  MACRO
  str t, [p, #-4]!
  ENDM

 PUBLIC tuck
tuck  ; (x1, x2 -- x2, x1, x2)  swapover
  TUCK
  NEXT


SWAP  MACRO
  mov w, t
  mov t, n
  mov n, w
  ENDM

 PUBLIC swap
swap  ; (x1, x2 -- x2, x1)
  SWAP
  NEXT


OVER  MACRO
  str n, [p, #-4]!
  mov w, n
  mov n, t
  mov t, w
  ENDM

 PUBLIC over
over  ; (x1, x2 -- x1, x2, x1)
  OVER
  NEXT


OVER3 MACRO
  ldr w, [p]
  str n, [p, #-4]!
  mov n, t
  mov t, w
  ENDM

over3 ; (x1, x2, x3 -- x1, x2, x3, x1)
  OVER3
  NEXT


OVER4 MACRO
  ldr w, [p, #4]
  str n, [p, #-4]!
  mov n, t
  mov t, w
  ENDM

over4 ; (x1, x2, x3, x4 -- x1, x2, x3, x4, x1)
  OVER4
  NEXT


rot ; (x1, x2, x3 -- x2, x3, x1)
  ldr w,[p]
  str n,[p]
  mov n,t
  mov t,w
  NEXT


nrot  ; (x1, x2, x3 -- x3, x1, x2)
  ldr w,[p]
  str t,[p]
  mov t,n
  mov n,w
  NEXT


ILK  MACRO literal
  DUP
  mov32 t, #literal
  ENDM

;ILK MACRO literal
;  DUP
;  ldr t, [pc]   ; 6 clk
;  b .+8   ; branch offset = 0 in opcode
;  DC32  literal
;  ENDM

;ILK  MACRO literal
; DUP
; ldr t, [pc]   ; 6 clk
; add pc,pc,#0  ; pipeline is correct, = .+8
; DC32  literal
; ENDM

 PUBLIC lit,ilk
lit
ilk ; ( -- ilk)   ; push literal
  DUP
jamk  ; (x -- ilk)    ; jam literal, stomp on TOS
  ldr t, [i], #4
  NEXT


 PUBLIC qdup
qdup  ; (x -- 0 | x,x)  dup TOS if <> 0
  teq t, #0
  strne n, [p, #-4]!
  movne n, t
  NEXT


 PUBLIC dlit,dilk
dlit
dilk  ; ( -- ilk1, ilk2)    ; push d-literal
  DDUP
djamk ; (x1, x2 -- ilk1, ilk2)  ; jam d-literal, stomp on TOS and NOS
;  ldrd n,t, [i], #8
  ldr n, [i], #4
  ldr t, [i], #4
  NEXT


DDROP MACRO
  ldrd t,n, [p], #8
;  ldr t, [p], #4
;  ldr n, [p], #4
  ENDM

 PUBLIC ddrop
ddrop ; (x -- )
  DDROP
  NEXT


dswap ; (x1,x2, x3,x4 -- x3,x4, x1,x2)
  ldrd x,y, [p], #8
;  strd n,t, [p, #-8]!
  str n, [p, #-4]!
  str t, [p, #-4]!
  mov n,x
  mov t,y
;  ldr y, [p]
;  str t, [p]
;  mov t, y
;  ldr x, [p, #4]
;  str n, [p, #4]
;  mov n, x
  NEXT


dover ; (d1, d2 -- d1, d2, d1)
  DDUP
;  ldrd  n,t,[p, #8]
  ldr t, [p, #8]
  ldr n, [p, #12]
  NEXT


torn  ; ( -- )  >R, non-destructive
  str t, [r, #-4]!
  NEXT


tor ; (x -- ) >R
  str t, [r, #-4]!
  DROP
  NEXT


jamr  ; (x -- ) jam toR
  str t, [r]
  DROP
  NEXT


rat ; ( -- x) Rptr
  DUP
  mov t, r
  NEXT


pat ; ( -- x) Pptr, after push from DUP
  DUP
  mov t, p
  NEXT


rfrom ; ( -- x) R>
  DUP
  ldr t, [r], #4
  NEXT


rfromn  ; ( -- x) R>, copy stays on Rstack
  DUP
  ldr t, [r]
  NEXT


rdrop ; R>, drop
  add r, r, #4
  NEXT



;   dtor ; (d -- ) d>R
;   drat ; ( -- d) dR@
;   drfrom ; ( -- d) dR>
;   ssp  ; ( -- x)   ; get system SP

;   rp ; ( -- x)   ; get RP
;   pp ; ( -- x)   ; get PP -- before push
;   lp ; ( -- x)   ; get loop-stack pointer
;   ip ; ( -- x)   ; get IP

;   Trailer_Trash; not recommended, did not implement <<<<<
;   roll ; (x1, x2, x3 -- x2, x3, x1)  fixed at 3rdOS, NOS, TOS <<<<<
;   drot ; (d1, d2, d3 -- d3, d2, d1)
;   droll  ; (d1, d2, d3 -- d2, d3, d1)
;   pickk  ; ( -- x)  ilk=0 picks NOS
;   pick ; (n -- x)  0 picks NOS
;   drip ; un-drop
;   undrop decd  P


;#include  "v4power.asm" ; power management
#include  "v4flow.asm"  ; program flow-control
#include  "v4xflow.asm" ; fancy program flow-control
#include  "v4monad.asm" ; unary op's
#include  "v4shifts.asm"  ; shifts, bit-reverse, byte/nybble swaps, etc.
#include  "v4dyad.asm"  ; dyadic op's
#include  "v4compar.asm"  ; comparison/equality tests, max/min
#include  "v4xlogic.asm"  ; imprecise op's
#include  "v4muldiv.asm"  ; integer mul, div, sqrt
#include  "v4memref.asm"  ; primitive memory reference
#include  "v4lutcams.asm" ; struct's, arrays, etc.
#include  "v4doloop.asm"  ; definite loops
;#include  "v4exotic.asm"  ; weird stuff
#include  "v4time.asm"  ; time, calendar
;#include  "v4float.asm" ; floating-point primitives
;#include  "v4fmath.asm" ; fancy floating-point
;#include  "v4ij.asm"  ; complex math
;#include  "v4numcnv.asm"  ; numeric conversion & "print" formatting
#include  "v4xlat.asm"  ; numeric conversion & "print" formatting
#include  "v4string$.asm" ; "print" formatting
;#include  "v4fonts.asm" ; display fonts
;#include  "v4io.asm"  ; mundane i/O
;#include  "v4comnet.asm"  ; SCI messaging
;#include  "v4flash.asm" ; flash memory op's
;#include  "v4rtos.asm"  ; RTOS kernel
;#include  "v4debug.asm" ; native metacode monitor/debugger
