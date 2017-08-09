
  DC8   __FILE__
  ALIGNROM 2


ror24 mov t, t, ror #24
  NEXT

  
sl8 mov t, t, lsl #8
  NEXT


sl16  mov t, t, lsl #16
  NEXT


asr16 mov t, t, asr #16
  NEXT


asr8  mov t, t, asr #8
  NEXT


lsr4  mov t, t, lsr #4
  NEXT


SL1 MACRO
  mov t, t, lsl #1
  ENDM

x2
twostar ; = sl1
sl1 ;  ( x -- x' )    shift left by 1 bit, LSb=0
  SL1
  NEXT


lslk
slk ;  ( x -- x' )    shift left by ilk bits, zero-filled
  ldr w, [i], #4
  mov t, t, lsl w
  NEXT


lsrk  ;  ( x -- x' )    shift right by ilk bits, zero-extended
  ldr w, [i], #4
  mov t, t, lsr w
  NEXT


asrk  ;  ( x -- x' )    shift right by ilk bits, sign-extended
  ldr w, [i], #4
  mov t, t, asr w
  NEXT


rork  ;  ( x -- x' )    shift right by ilk bits, sign-extended
  ldr w, [i], #4
  mov t, t, ror w
  NEXT


;   srn  ;  ( x, n -- n' ) shift NOS right by TOS bits, zero-extended


twoslash; = asr1
asr1  ;  ( x -- x' )    shift right by 1 bit, sign-extended
  mov t, t, asr #1
  NEXT


lsr1  ;  ( x -- x' )    shift right by 1 bit, sign-extended
  mov t, t, lsr #1
  NEXT


;   sran ;  ( x, n -- x' ) shift NOS right by TOS bits, sign-extended
;   rl1  ;  ( x -- x' )    rotate left by 1 bit
;   rlk  ;  ( x -- x' )    rotate left by ilk bits
;   rln  ;  ( x, n -- x')  rotate NOS left by TOS bits
;   rr1  ;  ( x -- x' )    rotate right by 1 bit
;   rrk  ;  ( x -- x' )    rotate right by ilk bits
;   rrn  ;  ( x, n -- x' ) rotate NOS right by TOS bits


lmon  ; ( x -- x, n )   leftmost 1, non-destructive
  DUP
lmo ; ( x -- n )    leftmost 1, destructive
  clz t,t
;  ldr k, =0
;  teq t, #0
;  ldreq PC, [i], #4 ; cond'l NEXT iff t == 0
;
;_lmo  addpl k, k, #1
;  movpls  t, t, lsl #1
;  bpl _lmo
;
;  mov t, k
  NEXT


;   rmon ; ( x -- x, n )   rightmost 1, non-destructive
;   rmo  ; ( x -- n )    rightmost 1, destructive
;   lmzn ; ( x -- x, n )   leftmost 0, non-destructive
;   lmz  ; ( x -- n )    leftmost 0, destructive
;   rmzn ; ( x -- x, n )   rightmost 0, non-destructive
;   rmz  ; ( x -- n )    rightmost 0, destructive


bitrev  ; (x -- x')   bit-reverse TOS
  rbit  t,t
;  ldr k, =32
;  ldr w, =0
;_bitrev movs  t, t, rrx
;  adc w, w, #0
;  subs  k, k, #1
;  movne w, w, lsl #1
;  bne _bitrev
;
;  mov t, w
  NEXT


CRC32POLY
  DC32  01DB704C1h
; 0x1EDC6F41 else 0x04C11DB7

crc32gen  ; (x -- x')   ; CRC32 m-seq generator
  movs  t, t, lsl #1  ; "ROL #1";  MSb --> carry
  adc t, t, #0  ; LSb <-- carry
  ldrcs w, CRC32POLY  ; load polynomial if carry=1
  eorcs t, t, w   ; apply polynomial if carry=1
  NEXT


;   nyblswap ; (0123 --> 3210) swap nybbles end-for-end
;   byteswap ; (mm.ll --> ll.mm) swap bytes

