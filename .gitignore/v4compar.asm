
  DC8   __FILE__
  ALIGNROM 2


Q MACRO
  cmp t, #-1
  ldrne t, =0
  ENDM

qn  ; ( -- flag)  qualify flag:  true iff TOS = -1, non-destructive
  DUP
q ; (x -- flag)   qualify flag:  true iff TOS = -1
  Q
  NEXT


; zeq, nott  <<<<< ?????

NZEQ  MACRO
  cmp t, #0
  movne t, #-1
  ENDM

 PUBLIC nzeqn,nzeq
nzeqn ; ( -- flag)  make well-formed true (-1) if TOS <> 0, non-destructive
  DUP
nzeq  ; (x -- flag) make well-formed flag:  true (-1) if TOS <> 0
  NZEQ
  NEXT


ZEQ MACRO
  teq t, #0
  mvneq t,t ;eoreq  t, t, #-1
  ldrne t, =0
  ENDM

zeqn  ; ( n -- n, flag) true if TOS == 0, non-destructive
  DUP
zeq ; ( n -- flag)    true if TOS == 0
  ZEQ
  NEXT


NZTO1 MACRO ; ( x -- 1|0 )
  NZEQ
  NEGG
  ENDM

 PUBLIC nzto1
nzto1 ; ( x -- 1|0 )  zero=0, notzero=1
  NZTO1
  NEXT
;  NEST
;  DC32  nzeq,negg,nexit


ZLT MACRO
  mov t, t, asr #32
  ENDM

zltn  ; ( n -- n, flag) true if TOS < 0, non-destructive
  DUP
zlt ; ( n -- flag)    true if TOS < 0
  ZLT
  NEXT


ZLE MACRO
  cmp t, #0
  movle t, #-1
  movgt t, #0
  ENDM

zlen  ; ( n -- n, flag) true if TOS <= 0, non-destructive
  DUP
zle ; ( n -- flag)    true if TOS <= 0
  ZLE
  NEXT


ZGE MACRO
  teq t, #0
  movpl t, #-1
  movmi t, #0
  ENDM

zgen  ; ( n -- n, flag) true if TOS >= 0, non-destructive
  DUP
zge ; ( n -- flag)    true if TOS >= 0
  ZGE
  NEXT


ZGT MACRO
  cmp t, #0
  movgt t, #-1
  movle t, #0
  ENDM

zgtn  ; ( n -- n, flag) true if TOS > 0, non-destructive
  DUP
zgt ; ( n -- flag)    true if TOS > 0
  ZGT
  NEXT


;   dzltn  SET zltn
;   dzlt ; ( d -- flag)    true if dTOS < 0
;   dzeq ; ( d -- flag)    true if dTOS = 0
;   dzeqn  ; ( d -- d, flag) true if dTOS = 0, non-destructive
;   dzgtn  SET zgtn
;   dzgt ; ( d -- flag)    true if dTOS > 0


max ; (n1, n2 -- n1 | n2)
  cmp t, n
  movlt t, n  ; t<n
  NIP
  NEXT


maxk  ; (n -- n | ilk)
  ldr w, [i], #4
  cmp t, w
  movlt t, w
  NEXT


umax  ; (u1, u2 -- u1 | u2)
  cmp t, n
  movlo t, n
  NIP
  NEXT


umaxk ; (u -- u | ilk)
  ldr w, [i], #4
  cmp t, w
  movlo t, w
  NEXT


min ; (n1, n2 -- n1 | n2)
  cmp t, n
  movgt t, n  ; t>n
  NIP
  NEXT


mink  ; (n -- n | ilk)
  ldr w, [i], #4
  cmp t, w
  movgt t, w
  NEXT


umin  ; (u1, u2 -- u1 | u2)
  cmp t, n
  movhi t, n
  NIP
  NEXT


cluk
umink ; (n -- n | ilk)  alias: usatk
usatk ; ( x -- usat ) clip/saturate TOS to unsigned ilk, unipolar
  ldr w, [i], #4
  cmp t, w
  movhi t, w
  NEXT


gtn ; (n1, n2 -- n1, n2, flag)  true if NOS > TOS, non-destructive
  cmp t, n
  DUP
  movlt t, #-1  ; t < n
  movge t, #0 ; t >= n
  NEXT


gen ; (n1, n2 -- n1, n2, flag)  true if NOS >= TOS, non-destructive
  cmp t, n
  DUP
  movle t, #-1  ; t < n
  movgt t, #0 ; t >= n
  NEXT


ltn ; (n1, n2 -- n1, n2, flag)  true if NOS < TOS, non-destructive
  cmp t, n
  DUP
  movgt t, #-1  ; t > n
  movle t, #0 ; t =< n
  NEXT


len ; (n1, n2 -- n1, n2, flag)  true if NOS <= TOS, non-destructive
  cmp t, n
  DUP
  movge t, #-1  ; t > n
  movlt t, #0 ; t =< n
  NEXT


boundkkn  ; ( n -- n, f )   true if  ilk1 <= TOS <= ilk2, non-d
  DUP
boundkk   ; ( n -- f )    true if  ilk1 <= TOS <= ilk2
  ldr w, [i], #4  ; lower bound
  ldr x, [i], #4  ; upper bound
  cmp t, w
  movge w, #-1  ; w <= t
  movlt w, #0 ; w > t
  cmp t, x
  movle x, #-1  ; x >= t
  movgt x, #0 ; x < t
  and t, w, x
  NEXT


uboundkkn ; ( u -- u, f )   true if  uilk1 <= uTOS <= uilk2, non-d
  DUP
uboundkk  ; ( u -- f )    true if  uilk1 <= uTOS <= uilk2
  ldr w, [i], #4  ; lower bound
  ldr x, [i], #4  ; upper bound
  cmp t, w
  movhs w, #-1  ; w <= t
  movlo w, #0 ; w > t
  cmp t, x
  movls x, #-1  ; x >= t
  movhi x, #0 ; x < t
  and t, w, x
  NEXT


;   uhin ; (u1, u2 -- u1, u2, flag)  true if uNOS > uTOS, non-destructive
;   uhsn ; (u1, u2 -- u1, u2, flag)  true if uNOS >= uTOS, non-destructive
;   ulsn ; (u1, u2 -- u1, u2, flag)  true if uNOS <= uTOS, non-destructive
;   ulon ; (u1, u2 -- u1, u2, flag)  true if uNOS < uTOS, non-destructive
;   uhi  ; ? see no point to implementing destructive comparisons? unf?????
;   uhs  ; ? see no point to implementing destructive comparisons? unf?????
;   gtt  ; ? see no point to implementing destructive comparisons? unf?????
;   gee  ; ? see no point to implementing destructive comparisons? unf?????
;   eqq  ; ? see no point to implementing destructive comparisons? unf?????
;   lee  ; ? see no point to implementing destructive comparisons? unf?????
;   ltt  ; ? see no point to implementing destructive comparisons? unf?????
;   uls  ; ? see no point to implementing destructive comparisons? unf?????
;   ulo  ; ? see no point to implementing destructive comparisons? unf?????
;   deqn ; (d1, d2 -- d1, d2, flag)  true if d2 == d1
;   dltn ; (d1, d2 -- d1, d2, flag)  true if d1 < d2
;   dmin ; (d1, d2 -- d1|d2)
;   dmax ; (d1, d2 -- d1|d2)


eq  ; (x1, x2 -- flag)  true if NOS == TOS, destructive
  cmp t, n
  DROP
  movne t, #0
  moveq t, #-1
  NEXT


eqn ; (n1, n2 -- n1, n2, flag)  true if NOS == TOS, non-destructive
  cmp t, n
  DUP
  movne t, #0
  moveq t, #-1
  NEXT


eqkn  ; (n -- n, flag)  true if TOS == ilk, non-destructive
  DUP
eqk ; (n -- flag)   true if TOS == ilk, destructive
  ldr w, [i], #4
  cmp w, t
  movne t, #0
  moveq t, #-1
  NEXT


neq ; (x1, x2 -- flag)  true if NOS == TOS, destructive
  cmp t, n
  DROP
  moveq t, #0
  movne t, #-1
  NEXT


neqkn ; (n -- n, flag)  true if TOS <> ilk, non-destructive
  DUP
neqk  ; (n -- flag)   true if TOS <> ilk, destructive
  ldr w, [i], #4
  cmp w, t
  moveq t, #0
  movne t, #-1
  NEXT
