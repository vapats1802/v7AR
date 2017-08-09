
  DC8   __FILE__
  ALIGNROM 2


prox  ; (n1, n2, n3 -- n1, n2, flag)  true if 3rdOS is within +/- TOS of NOS
  ldr x, [p]    ; 
  subs  k, n, x
  rsbmi k, k, #0
  cmp k, t
  movls t, #-1
  movhi t, #0
  NEXT


proxkn
proxk ; (n1, n2 -- n1, n2, flag)  true if TOS is within +/- ilk of NOS
  ldr w, [i], #4
  subs  k, t, n
  DUP
  rsbmi k, k, #0
  cmp k, w
  movls t, #-1
  movhi t, #0
  NEXT


proxvtn ; (n -- n, flag) proximity;  ilk.value, ilk.tolerance
proxkk  ; (n -- n, flag)  true if TOS is within +/- ilk2 of ilk1
  DUP
  ldr w, [i], #4  ; prox target
  ldr x, [i], #4  ; +/- tolerance
  subs  k, n, w
  rsbmi k, k, #0
  cmp k, x
  movls t, #-1
  movhi t, #0
  NEXT


satk  ; ( n -- ssat ) clip/saturate TOS to +/- (+ve)ilk, bipolar
  ldr w, [i], #4
  movs  k, t
  rsbmi k, k, #0
  cmp k, w
  ldrle PC, [i], #4

  movs  t, t
  rsbmi w, w, #0
  mov t, w
  NEXT
