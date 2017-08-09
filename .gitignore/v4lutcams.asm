
  DC8   __FILE__
  ALIGNROM 2


lut  ; ( base, index -- x )  ref nth entry of word.32 LUT based @ NOS
  ldr t, [n, t, lsl #2] ; base + index * 4 bytes.8
  NIP
  NEXT


lutk  ; (n -- x)  ref nth entry of word.32 LUT based @ ilk
;# note similarity to 'case'
  ldr x, [i], #4  ; get ilk LUT base@, bump IP
  ldr t, [x, t, lsl #2] ; base + index * 4 bytes.8
  NEXT


ublutk  ; (n -- u.8)  ref nth entry of un-signed byte.8 LUT based @ ilk
  ldr x, [i], #4
  add x, x, t
  ldrb  t, [x]
  NEXT


blutk ; (n -- x)  ref nth entry of signed byte.8 LUT based @ ilk
  ldr x, [i], #4
  add x, x, t
  ldrsb t, [x]
  NEXT

  
// "Automatic Bounds-protected LUT Descriptor"
ABLUTD  MACRO   ; auto-text bounds-protected LUT-descriptor macro
  DC32  \1      ; base@ for LUT
  DC32  ((LL_\1 - \1) / 4)  ; LeastLegal value for index
  DC32  ((ML_\1 - \1) / 4)  ; MostLegal value for index
  DC32  \1Trap      ; trap@ for bounds-violation
  ENDM


xlutk ; (index -- x)  *LUT_descriptor.ilk;  bounds-protected lutk
  ldr x, [i], #4  ; get ilk descriptor@, bump IP
  ldr k, [x]    ; get ilk LUT base@
  ldr w, [x, #4]  ; get lower bound
  cmp t, w
      ; iff index >= lower bound
  ldrge w, [x, #8]  ; cond'l get upper bound
  cmpge w, t    ; <<<<<  note sense-reversal; this is essential
      ; iff upper bound >= index
  ldrge t, [k, t, lsl #2] ; cond'l get LUT value

_luttrap  ; <<<<< preserves TOS intact for error-analysis,
  ldr PC, [x, #12]  ; jump to trap@; absolute, unconditional


camk  ; (tag -- x)  *search_table.ilk content-addressed memory
;# note similarity to 'switch'
  ldr x, [i], #4  ; get ilk list@, bump IP
_scam
  ldr w, [x], #8  ; get tag from list, [x] now = next tag
  cmp t, w
  ldreq t, [x, #-4] ; get CAM entry from list if match
  ldreq PC, [i], #4 ; cond'l NEXT if match found

  teq w, #0
  ldreq PC, [i], #4 ; cond'l NEXT if tag=0 (search aborted)

  b _scam   ; and loop again


//   fifo_q_precis; WritePtr, ReadPtr, EndAddr=(BaseAddr+SizeInBytes+6), [qstart...]
//   fifo_q_practice; FIFOs should be declared/allocated/symbolized in *.b43 or *.h43
//   fifo_q_caveat1;  no low-level run-time error-checking, nor exception generation
//   qk ; = fifok
//   fifok  ; init circular FIFO descriptor structure:  Addr.ilk1, SizeInBytes.ilk2
//   qqk  ;( -- count) query FIFO.ilk, count = 0 if empty, else en-q'd #of bytes.8
//   qfreek ; ( -- count) get FIFO.ilk's free space in bytes.8
//   nq1k ; (x -- ) append TOS to FIFO.ilk, word.16 granularity
//   dq1k ; ( -- x) extract word.16 from FIFO.ilk to TOS
//   bnq1k  ; (x.8 -- ) append TOS to FIFO.ilk, byte.8 granularity
//   bdq1k  ; ( -- x) extract byte.8 from FIFO.ilk to TOS, sign-extended
//   nqk  ; ( count, addr -- )  append buffer to FIFO.ilk, word.16 granularity
//   dqk  ; (count, ddr -- ) extract from FIFO.ilk to buffer, word.16 granularity
//   bnqk ; ( count, addr -- )  append buffer to FIFO.ilk, byte.8 granularity
//   bdqk ; (count, addr -- ) extract from FIFO.ilk to buffer, byte.8 granularity

//   padi ; init string pointer:  jam PADx with &PAD
//   set$k  ; jam PADx with ilk
//   add$k  ; add ilk to PADx

//   mov$k  ; copy zstring @ilk via PADx
//   mov$kx ; copy zstring @ilk1 via PADx with ilk2.offset
//   mov$$  ; copy zstring from here (ROM inline) via PADx
//   movz$  ; (*src -- )  copy zstring @TOS via PADx
//   chark  ; copy ilk via PADx, implicit (""-supplied) null.8   <<<<< not guarded
//   char2k ; copy ilk (2 chars, in '' single quotes) via PADx, append null.8

//   xsum$  ; ( ptr -- count, xsum) generate length & sum of ASCIIz$ @ Tos
//   xsum$k ; ( -- count, xsum) generate length & sum of *ASCIIz$.ilk

//   l$k  ; analogous to BASIC's LEFT$()
//   m$kk ; analogous to BASIC's MID$()
//   r$k  ; analogous to BASIC's RIGHT$()

