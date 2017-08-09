
  DC8   __FILE__
  ALIGNROM 2


CLR MACRO
  mov t, #0
  ENDM

clr ; ( -- 0 )
  CLR
  NEXT


ZERO  MACRO
  DUP
  CLR
  ENDM

zero  ; ( -- 0 )
  ZERO
  NEXT


TRUE  MACRO
  DUP
  mvn t, #-1
  ENDM

true  ; ( -- -1 )
  TRUE
  NEXT


ONE MACRO
  DUP
  mov t, #1
  ENDM

one ; ( -- 1 )
  ONE
  NEXT


INC MACRO
  add t, t, #1
  ENDM

inc ; ( x -- x+1 )
  INC
  NEXT


INC2  MACRO
  add t, t, #2
  ENDM

inc2  ; ( x -- x+4 )
  INC2
  NEXT


INC4  MACRO
  add t, t, #4
  ENDM

cellplus
inc4  ; ( x -- x+4 )
  INC4
  NEXT


INC8  MACRO
  add t, t, #8
  ENDM

inc8  ; ( x -- x+8 )
  INC8
  NEXT


DEC MACRO
  add t, t, #-1
  ENDM

dec ; ( x -- x-1 )
  DEC
  NEXT


DEC2  MACRO
  add t, t, #-2
  ENDM

dec2  ; ( x -- x-4 )
  DEC2
  NEXT


DEC4  MACRO
  add t, t, #-4
  ENDM

cellminus
dec4  ; ( x -- x-4 )
  DEC4
  NEXT


DEC8  MACRO
  add t, t, #-8
  ENDM

dec8  ; ( x -- x-8 )
  DEC8
  NEXT


NOTT  MACRO
  mvn t, t
  ENDM

invert
nott  ; ( x -- ~x )
  NOTT
  NEXT


NEGG  MACRO
  rsb t, t, #0
  ENDM

negg  ; (x -- -x)
  NEGG
  NEXT


qneg  ; ( x, f -- +/-x )
  teq t, #0
  rsbne t, n, #0
  moveq t, n
  NIP
  NEXT


ABS MACRO
  teq t, #0
  rsbmi t, t, #0
  ENDM

abs     ; ( x -- |x| )    absolute value
  ABS
  NEXT


;   dabs ; ( d -- |d| )  absolute value of double
;   dneg ; (d -- -d)
;   dinc ; (d -- d+1)
;   ddec ; (d -- d-1)
;   dinc2  ; (d -- d+2)
;   ddec2  ; (d -- d-2)
;   umink  ; alias: usatk
;   usatk  ; ( x -- usat ) clip/saturate TOS to unsigned ilk, unipolar
;   satk ; ( n -- ssat ) clip/saturate TOS to +/-(+ve)ilk, bipolar

;   zerod  ; ( x -- 0 )
;   trued  ; ( x -- 0FFFFh )
;   one  ; (  -- 1 )
;   oned ; ( x -- -1 )
;   two  ; (  -- 2 )
;   twod ; ( x -- 2 )
;   ntwo ; (  -- -2 )
;   ntwod  ; ( x -- -2 )
;   three  ; (  -- 3 )
;   threed ; ( x -- 3 )
;   four ; (  -- 4 )
;   fourd  ; ( x -- 4 )
;   five ; (  -- 5 )
;   fived  ; ( x -- 5 )
;   seven  ; (  -- 7 )
;   sevend ; ( x -- 7 )
;   eight  ; (  -- 8 )
;   eightd ; ( x -- 8 )
;   nine ; (  -- 9 )
;   nined  ; ( x -- 9 )
;   ten  ; (  -- 10 )
;   tend ; ( x -- 10 )
;   minint  ; ( -- 8001h )
;   minintd  ; ( x -- 8001h )
;   maxint  ; ( -- 7FFFh )
;   maxintd ; ( x -- 7FFFh )

