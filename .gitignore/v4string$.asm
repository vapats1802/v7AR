
  DC8   __FILE__
  ALIGNROM 2

; after a $move, PADx points to the last char moved (usually a null)
; moving a null results in a null-move, i.e. PADx is not changed


mov$$ ; copy zstring from here (ROM inline) via PADx
  ldr x, PADxp  ; get ptr to PADx
  mov y, x    ; save ptr to PADx in Y
  ldr x, [x]    ; get PADx
_mv$$nz
  ldrb  k, [i], #1  ; get source byte, post-inc
  strb  k, [x], #1  ; store dest byte, post-inc
  teq k, #0   ; ? null char?
  bne _mv$$nz   ; loop if byte <> 0

  add x, x, #-1 ; un-do X++ inc
  str x, [y]    ; update PADx
  tst i, #03h   ; ? is IP on 32-bit align't?
  addne i, i, #4
  bicne i, i, #3
  NEXT


mov$k ; copy zstring @ilk via PADx
  ldr w, [i], #4
  b _mv$

mov$  ; (*src -- )  copy zstring @TOS via PADx
  mov w, t
  DROP

_mv$
  ldr x, PADxp  ; get ptr to PADx
  mov y, x    ; save ptr to PADx in Y
  ldr x, [x]    ; get PADx
_mv$nz
  ldrb  k, [w], #1  ; get source byte, post-inc
  strb  k, [x], #1  ; store dest byte, post-inc
  teq k, #0   ; ? null char?
  bne _mv$nz    ; loop if byte <> 0

  add x, x, #-1 ; un-do X++ inc
  str x, [y]    ; update PADx
  NEXT


chark ; copy ilk via PADx, implicit (""-supplied) null.8   <<<<< not guarded
  ldr x, PADxp  ; get ptr to PADx
  mov y, x    ; save ptr to PADx in Y
  ldr x, [x]    ; get PADx
  ldrb  w, [i], #4  ; get source byte via IP, post-inc
  strb  w, [x], #1  ; store dest byte, post-inc
  eor w, w, w
  strb  w, [x]    ; store null
  str x, [y]    ; update PADx
  NEXT


char2k  ; copy ilk (2 chars, in '' single quotes) via PADx, append null.8
  ldr x, PADxp  ; get ptr to PADx
  mov y, x    ; save ptr to PADx in Y
  ldr x, [x]    ; get PADx
  ldr w, [i], #4  ; get 4 (2) source bytes via IP, post-inc
  strb  w, [x], #1  ; store 1st of 2 dest bytes, post-inc
  mov w, w, lsr #8  ; 2nd byte
  strb  w, [x], #1  ; store 2nd of 2 dest bytes, post-inc
  eor w, w, w
  strb  w, [x]    ; store null
  str x, [y]    ; update PADx
  NEXT


char3k  ; copy ilk (2 chars, in '' single quotes) via PADx, append null.8
  ldr x, PADxp  ; get ptr to PADx
  mov y, x    ; save ptr to PADx in Y
  ldr x, [x]    ; get PADx
  ldr w, [i], #4  ; get 4 (2) source bytes via IP, post-inc
  strb  w, [x], #1  ; store 1st of 2 dest bytes, post-inc
  mov w, w, lsr #8  ; 2nd byte
  strb  w, [x], #1  ; store 2nd of 2 dest bytes, post-inc
  mov w, w, lsr #8  ; 2nd byte
  strb  w, [x], #1  ; store 2nd of 2 dest bytes, post-inc
  eor w, w, w
  strb  w, [x]    ; store null
  str x, [y]    ; update PADx
  NEXT


crlf  ; cat CR+LF via PADx, append null.8
  ldr x, PADxp  ; get ptr to PADx
  mov y, x    ; save ptr to PADx in Y
  ldr x, [x]    ; get PADx
  mov w, #cr
  strb  w, [x], #1  ; store 1st of 2 dest bytes, post-inc
  mov w, #lf
  strb  w, [x], #1  ; store 2nd of 2 dest bytes, post-inc
  eor w, w, w
  strb  w, [x]    ; store null
  str x, [y]    ; update PADx
  NEXT


bltbpsdk
bltbpkkk  ; block-transfer bytes ++,  ilk1=src, ilk2=dst, ilk3=bytecount
  ldr x, [i], #4    ; get src
  ldr y, [i], #4    ; get dst
  ldr k, [i], #4    ; get kount
_bltp8
  ldrb  w, [x], #1  ; get source byte, post-inc
  strb  w, [y], #1  ; store dest byte, post-inc
  adds  k, k, #-1 ; dec K
  bne _bltp8    ; loop if <> 0

  NEXT


bltbnsdk
bltbnkkk  ; block-transfer bytes --,  ilk1=src, ilk2=dst, ilk3=bytecount
  ldr x, [i], #4    ; get src
  ldr y, [i], #4    ; get dst
  ldr k, [i], #4    ; get kount
_bltn8
  ldrb  w, [x], #-1 ; get source byte, post-dec
  strb  w, [y], #-1 ; store dest byte, post-dec
  adds  k, k, #-1 ; dec K
  bne _bltn8    ; loop if <> 0

  NEXT


blthpsdk
blthpkkk ; block-transfer halfwords ++,  ilk1=src, ilk2=dst, ilk3=halfcount
  ldr x, [i], #4    ; get src
  ldr y, [i], #4    ; get dst
  ldr k, [i], #4    ; get kount
_bltp16
  ldrh  w, [x], #2  ; get source halfword, post-inc
  strh  w, [y], #2  ; store dest halfword, post-inc
  adds  k, k, #-1 ; dec K
  bne _bltp16   ; loop if <> 0

  NEXT


blthnsdk
blthnkkk ; block-transfer halfwords --,  ilk1=src, ilk2=dst, ilk3=halfcount
  ldr x, [i], #4    ; get src
  ldr y, [i], #4    ; get dst
  ldr k, [i], #4    ; get kount
_bltn16
  ldrh  w, [x], #-2 ; get source halfword, post-dec
  strh  w, [y], #-2 ; store dest halfword, post-dec
  adds  k, k, #-1 ; dec K
  bne _bltn16   ; loop if <> 0

  NEXT


bltwpsdk
bltwpkkk  ; block-transfer words ++,  ilk1=src, ilk2=dst, ilk3=wordcount
  ldr x, [i], #4    ; get src
  ldr y, [i], #4    ; get dst
  ldr k, [i], #4    ; get kount
_bltp32
  ldr w, [x], #4  ; get source word, post-inc
  str w, [y], #4  ; store dest word, post-inc
  adds  k, k, #-1 ; dec K
  bne _bltp32   ; loop if <> 0

  NEXT


bltwnsdk
bltwnkkk  ; block-transfer words --,  ilk1=src, ilk2=dst, ilk3=wordcount
  ldr x, [i], #4    ; get src
  ldr y, [i], #4    ; get dst
  ldr k, [i], #4    ; get kount
_bltn32
  ldr w, [x], #-4 ; get source word, post-dec
  str w, [y], #-4 ; store dest word, post-dec
  adds  k, k, #-1 ; dec K
  bne _bltn32   ; loop if <> 0

  NEXT



