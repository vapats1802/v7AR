//    
v4flow_a79; program flow-control constructs
//

  DC8   __FILE__
  ALIGNROM 2


nopp  NEXT


STOP  MACRO
;  bkpt  #0
  b .
  ENDM

stop  STOP


waitk
  ldr   k, [i], #4
_waitspin
  subs  k, k, #1
  bne   _waitspin
  NEXT


BEGIN MACRO
  mov x, pc   ; pipeline compensation
  str x, [r, #-4]!
  ENDM

begin str i, [r, #-4]!  ; mark IP on Rstack
  NEXT


unNEST
unbegin ; un-mark:  rfrom,drop
rfromdrop
  add r, r, #4
  NEXT


until ; (x -- )   ; loop if TOS false = 0
  teq t, #0
  DROP
  ldreq i, [r]
  addne r, r, #4
  NEXT


untiln  ; (x -- x)    ; loop if TOS false = 0, non-destructive
  teq t, #0
  ldreq i, [r]
  addne r, r, #4
  NEXT


zuntil  ; (x -- )   ; loop if TOS true <> 0; "not until"
  teq t, #0
  ldrne i, [r]
  addeq r, r, #4
  DROP
  NEXT


zuntiln ; (x -- x)    ; loop if TOS true <> 0, non-destructive
  teq t, #0
  ldrne i, [r]
  addeq r, r, #4
  NEXT


while ; (x --)  xeq following, else branch to ilk
  teq t, #0
  DROP
  addeq r, r, #4  ; un-mark Rstack if false = 0
  ldreq i, [i]    ; zbr
  ldreq PC, [i], #4 ; cond'l NEXT if false = 0

  addne i, i, #4  ; else bump IP past "zbr" ilk
  NEXT


whilen  ; ( -- )  xeq following, else branch to ilk, non-destructive
  teq t, #0
  addeq r, r, #4  ; un-mark Rstack if false = 0
  ldreq i, [i]    ; zbr
  ldreq PC, [i], #4 ; cond'l NEXT if false = 0

  addne i, i, #4  ; else bump IP past "zbr" ilk
  NEXT


zwhile  ; (x --)  xeq following, else branch to ilk
  teq t, #0
  DROP
  addne r, r, #4  ; un-mark Rstack if true <> 0
  ldrne i, [i]    ; tbr
  ldrne PC, [i], #4 ; cond'l NEXT if true <> 0

  addeq i, i, #4  ; else bump IP past "tbr" ilk
  NEXT


zwhilen ; ( -- )  xeq following, else branch to ilk, non-destructive
  teq t, #0
  addne r, r, #4  ; un-mark Rstack if true <> 0
  ldrne i, [i]    ; tbr
  ldrne PC, [i], #4 ; cond'l NEXT if true <> 0

  addeq i, i, #4  ; else bump IP past "tbr" ilk
  NEXT


AGAIN MACRO
  ldr PC, [r]
  ENDM

repeat
again
  ldr i, [r]    ; jam IP with TOR
  NEXT


br  ldr i,[i]   ; branch to ilk
  NEXT


zbr ; (x -- )   branch to ilk if TOS = 0
  teq t, #0
  DROP
  ldreq i, [i]
  ldreq PC, [i], #4 ; cond'l NEXT

  addne i, i, #4  ; else bump IP
  NEXT


zbrn  ; ( -- )    branch to ilk if TOS = 0, non-destructive
  teq t, #0
  ldreq i, [i]
  ldreq PC, [i], #4 ; cond'l NEXT

  addne i, i, #4  ; else bump IP
  NEXT


tbr ; (x -- )   branch to ilk if TOS <> 0
  teq t, #0
  DROP
  ldrne i, [i]
  ldrne PC, [i], #4 ; cond'l NEXT

  addeq i, i, #4  ; else bump IP
  NEXT


tbrn  ; ( -- )    branch to ilk if TOS <> 0, non-destructive
  teq t, #0
  ldrne i, [i]
  ldrne PC, [i], #4 ; cond'l NEXT

  addeq i, i, #4  ; else bump IP
  NEXT


nbr ; (n -- )   branch to ilk if TOS < 0
  teq t, #0
  DROP
  ldrmi i, [i]
  ldrmi PC, [i], #4 ; cond'l NEXT

  addpl i, i, #4  ; else bump IP
  NEXT


nbrn  ; (n -- )   branch to ilk if TOS < 0, non-destructive
  teq t, #0
  ldrmi i, [i]
  ldrmi PC, [i], #4 ; cond'l NEXT

  addpl i, i, #4  ; else bump IP
  NEXT


pbr ; (n -- )   branch to ilk if TOS >= 0
  teq t, #0
  DROP
  ldrpl i, [i]
  ldrpl PC, [i], #4 ; cond'l NEXT

  addmi i, i, #4  ; else bump IP
  NEXT


pbrn  ; (n -- )   branch to ilk if TOS >= 0, non-destructive
  teq t, #0
  ldrpl i, [i]
  ldrpl PC, [i], #4 ; cond'l NEXT

  addmi i, i, #4  ; else bump IP
  NEXT


br3k  ; ( n --> ) 3-way branch;  <0.ilk, =0.ilk, >0.ilk
  teq t, #0
  DROP
  ldrmi i, [i]    ; the following sequence is critical!
  ldrpl i, [i, #8]
  ldreq i, [i, #4]
  NEXT


br3kn ; ( n --> n ) 3-way branch, non-destructive;  <0.ilk, =0.ilk, >0.ilk
  teq t, #0
  ldrmi i, [i]    ; the following sequence is critical!
  ldrpl i, [i, #8]
  ldreq i, [i, #4]
  NEXT


brlutk  ; ( n -- )  *branch_table.ilk;  LUT-based multi-branch
;# note similarity to 'casek'
  ldr x, [i], #4    ; get ilk LUT base@, bump IP
  ldr i, [x, t, lsl #2] ; base + index * 4 bytes.8
  DROP
  NEXT



//   untilqn  ; ( -- )  repeat previous codon if TOS = 0, non-destructive
//   againq sub #4, i ; repeat previous codon, forever
//   whileqn  ; ( -- )  repeat previous codon if TOS <> 0, non-destructive
//   untilq ; (x -- ) repeat previous codon if TOS = 0
//   whileq ;  (x -- )  repeat previous codon if TOS <> 0

//   xeqn mov t,PC  ; (vector -- vector)   1-shot execution, non-destructive
//   xeq  ; (vector -- )  1-shot execution
//   jmpk add @i+, i  ; IP-relative jump, ilk is BYTE offset
//   zjmp ; (x -- ) IP-relative jump if TOS =0, ilk is BYTE offset
//   zjmpn  ; ( -- ) IP-relative jump if TOS =0, nondestructive, ilk is BYTE offset
//   tjmp ; (x -- )   IP-relative jump if TOS <>0, ilk is BYTE offset
//   tjmpn  ; ( -- ) IP-relative jump if TOS <>0, nondestructive, ilk is BYTE offset
