
  DC8   __FILE__
  ALIGNROM 2


ADDD  MACRO
  add t, t, n
  NIP
  ENDM

plus
addd
  ADDD
  NEXT


ADDK  MACRO literal
  ldr w, [pc,#4]  ;
  add t,t,w
  b .+8   ; branch ofst=0 in opcode
  DD  literal
  ENDM

addk: ldr w, [i], #4
  add t, t, w
  NEXT


SUBB  MACRO
  sub t, n, t
  NIP
  ENDM

subb: SUBB
  NEXT


SUBR  MACRO
  rsb t, n, t
  NIP
  ENDM

subr: SUBR
  NEXT


subk: ldr w, [i], #4
  sub t, t, w
  NEXT


ANDK  MACRO literal
  ldr w, [pc,#4]  ;
  and t,t,w
  b .+8   ; branch ofst=0 in opcode
  DD  literal
  ENDM

andk: ; (x -- x')
  ldr w, [i], #4
  and t, t, w
  NEXT


andkk:  ; ( -- )  rmw AND of ilk to var
  ldr  w, [i], #4      ; bits to mask
  ldr  x, [i], #4      ; addr
  ldr  y, [x]
  and  w, y, w
  str  w, [x]
  NEXT


ANDD  MACRO
  and t, t, n
  NIP
  ENDM

andd: ; (x -- x')
  ANDD
  NEXT


XORR  MACRO
  eor t, t, n
  NIP
  ENDM

xorr: ; (x1, x2 -- x')
  XORR
  NEXT


xork: ; (x -- x')
  ldr w, [i], #4
  eor t, t, w
  NEXT


xorkk:  ; ( -- )  rmw XOR of ilk to var
  ldr  w, [i], #4      ; bits to toggle
  ldr  x, [i], #4      ; addr
  ldr  y, [x]
  eor  w, y, w
  str  w, [x]
  NEXT


OR  MACRO
  orr t, t, n
  NIP
  ENDM

or: OR
  NEXT


bisk:
ork:  ; (x -- x')
  ldr w, [i], #4
  orr t, t, w
  NEXT


biskk:
orkk:  ; ( -- )  rmw OR of ilk to var
  ldr  w, [i], #4      ; bits to set
  ldr  x, [i], #4      ; addr
  ldr  y, [x]
  orr  w, y, w
  str  w, [x]
  NEXT


bick: ; (x -- x')
  ldr w, [i], #4
  bic t, t, w
  NEXT


bickk:  ; ( -- )  rmw ANDNOT of ilk to var
  ldr  w, [i], #4      ; bits to clear
  ldr  x, [i], #4      ; addr
  ldr  y, [x]
  bic  w, y, w
  str  w, [x]
  NEXT


imp ; ( x1, x2 -- x ) bitwise formal-logic "implies";  must use well-formed flags for use as boolean
  mvn w,n ; false bits from NoS
  and x,n,t 
  NIP
  orr t,w,x
  NEXT
  

;   subrk  ; (n -- ilk-n)    subtract TOS from ilk
;   adds ; (n1, n2 -- n')  add TOS to NOS, saturated
;   addsk  ; (n -- n+ilk)    add ilk to TOS, saturated
;   subs ; (n1, n2 -- n1-n2) subtract TOS from NOS, saturated
;   subsr  ; (n1, n2 -- n2-n1) subtract NOS from TOS, saturated
;   subsk  ; (n -- n-ilk)    subtract ilk from TOS, saturated
;   subsrk ; (n -- ilk-n)    subtract TOS from ilk, saturated
;   daddd  ; (d1, d2 -- d')  add doubles
;   daddk  ; (d -- d')   add MSilk2:LSilk1 to double
;   dsub ; (d1, d2 -- d')
;   dsubk  ; (d -- d')   subtract dilk from dTOS
;   dsubr  ; (d1, d2 -- d')
;   dsubrk ; (d -- d')   subtract dTOS from dilk
