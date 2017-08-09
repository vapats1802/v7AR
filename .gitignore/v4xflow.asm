
  DC8   __FILE__
  ALIGNROM 2


;  casek indexes via TOS into a LUT of xeq'l single codons. The base addr
;  of the LUT is an ilk, and any index is allowed, so be careful.
;  casek has the same effect as lutk,[case_table],xeq

casek ; (index -- )  *case_table.ilk
;# note similarity to 'lutk'
  ldr x, [i], #4  ; get ilk LUT base@, bump IP
  mov w, t
  DROP
  ldr PC, [x, w, lsl #2]  ; base + index * 4 bytes.8


;   xcasek ; (n -- )  *prev_state_var.ilk, *case_table.ilk


; "BCASED" conveniently contructs a descriptor-structure for "bcasek",
; using explicit, user-supplied labels.


BCASED  MACRO LUTbase, LLB, MLB, trap ; bounds-protected case-descriptor macro
  DC32  LUTbase     ; base@ for case-LUT
  DC32  ((LLB - LUTbase) / 4) ; LeastLegal value for index
  DC32  ((MLB - LUTbase) / 4) ; MostLegal value for index
  DC32  trap      ; trap@ for bounds-violation
  ENDM


; "ABCASED" conveniently contructs a descriptor-structure for "bcasek",
; with automatic text-substitution for a formally conventionalized
; case-structure declaration typographical convention.
;
; For example:
;
;  ABCASED CaseName
;
; will generate:
;
;  DC32  CaseName      ; base@ for case-LUT
;  DC32  ((LL_CaseName - CaseName) / 4)  ; LeastLegal value for index
;  DC32  ((ML_CaseName - CaseName) / 4)  ; MostLegal value for index
;  DC32  CaseNameTrap      ; trap@ for bounds-violation
;
; for use with the (manually labelled with the 'LL_' and 'ML_' prefixes, and
; 'Trap' suffix) example structure:
;
;LL_CaseName
;  DC32  CaseAction[-LeastLegalIndex]
;   .
;   .
;  DC32  CaseAction[-2]
;  DC32  CaseAction[-1]
;CaseName
;  DC32  CaseAction[0]
;  DC32  CaseAction[+1]
;  DC32  CaseAction[+2]
;   .
;   .
;ML_CaseName
;  DC32  CaseAction[+MostLegalIndex]
;
;CaseNameTrap
;  NEST
;  DC32  bounds-violation error analysis, blah, blah, blah...


; "Automatic Bounds-protected CASE Descriptor"
ABCASED MACRO   ; auto-text bounds-protected case-descriptor macro
  DC32  \1      ; base@ for case-LUT
  DC32  ((LL_\1 - \1) / 4)  ; LeastLegal value for index
  DC32  ((ML_\1 - \1) / 4)  ; MostLegal value for index
  DC32  \1Trap      ; trap@ for bounds-violation
  ENDM


bcasek  ; (index -- )  *case_descriptor.ilk;  bounds-protected casek
  ldr x, [i], #4  ; get ilk descriptor@, bump IP
  ldr k, [x]    ; get ilk LUT base@
  ldr w, [x, #4]  ; get lower bound
  cmp t, w
; iff index >= lower bound
  ldrge w, [x, #8]  ; cond'l get upper bound
  cmpge w, t    ; <<<<<  note sense-reversal; this is essential
; iff upper bound >= index
  movge w, t    ; cond'l save index
  movge t, n    ; cond'l DROP
  ldrge n, [p], #4

  ldrge PC, [k, w, lsl #2]  ; cond'l xeq codon

_casetrap ; <<<<< preserves TOS intact for error-analysis,
  ldr PC, [x, #12]  ; jump to trap@; absolute, unconditional


;   xcasekx  ; (n -- )  *prev_state_var.ilk, *case_table.ilk, default_codon.ilk
;   xswitchk ; ( tag -- )  *prev_tag.ilk, *switch_list.ilk
;   xswitchkx_p; *prev_tag.ilk, *switch_list.ilk, default_codon.ilk, trap_codon.ilk
;   xswitchkx  ; ( tag -- )
;   
;   


;  xcasek  conditionally indexes via TOS into a LUT of xeq'l single codons.
;  The state-var on TOS is compared to a memory of the previously
;  encountered state (pointed to by the first ilk), and no action is
;  performed iff the state has not changed. Otherwise (i.e. iff a state
;  change has occurred), the LUT is consulted. The base addr of the LUT is
;  the 2nd ilk, and any index is allowed, so be careful.

xcasek  ; (n -- )  *prev_state_var.ilk, *case_table.ilk

;  casek indexes via TOS into a LUT of xeq'l single codons. The base addr
;  of the LUT is an ilk, and any index is allowed, so be careful.
;  casek has the same effect as lutk,[case_table],xeq


;  xcasekx conditionally indexes via TOS into a LUT of xeq'l single codons.
;  The state-var on TOS is compared to a memory of the previously
;  encountered state (pointed to by the first ilk), and a default action (a ; single codon, pointed to by the 3rd ilk) is performed iff the state has
;  not changed. Otherwise (i.e. iff a state change has occurred), the LUT
;  is consulted. The base addr of the LUT is the 2nd ilk, and any index is
;  allowed, so be careful.

xcasekx ; (n -- )  *prev_state_var.ilk, *case_table.ilk, default_codon.ilk


;  switchk scans an un-ordered search-list consisting of pairs of word.32
;  entries: an arbitrary tag, followed by a single executable codon. The
;  (non-zero) value on TOS is compared to each tag in the list, until
;  either a match is found, or a zero-valued tag is encountered, signifying
;  end-of-list -- in which case, nothing happens except wasted time, unless
;  the tag is zero, which is also executed as a valid match. Iff a
;  match is found, then the single codon that follows the matching tag is
;  executed. Note that the list is scanned in sequential order, so "early"
;  entries will be found and executed more quickly than "later" entries.
;  The base address of the list is an ilk.

switchk ;   ( tag -- )  *switch_list.ilk
;# note similarity to 'camk'
  mov k, t
  DROP
  ldr x, [i], #4  ; get ilk list@, bump IP
_swl
  ldr w, [x], #8  ; get tag from list, [x] now = next tag
  cmp k, w
  ldreq PC, [x, #-4]  ; xeq codon from list if match

  teq w, #0
  ldreq PC, [i], #4 ; cond'l NEXT if tag=0 (search ended, for sure)

  bne _swl    ; else loop, and look again


switchkn  ;   ( tag -- tag )  *switch_list.ilk
  ldr x, [i], #4  ; get ilk list@, bump IP
_swnl
  ldr w, [x], #8  ; get tag from list, [x] now = next tag
  cmp t, w
  ldreq PC, [x, #-4]  ; xeq codon from list if match

  teq w, #0
  ldreq PC, [i], #4 ; cond'l NEXT if tag=0 (search ended, for sure)

  bne _swnl   ; else loop, and look again


;  xswitchk conditionally scans an un-ordered search-list consisting of
;  pairs of word.16 entries: an arbitrary tag, followed by a single
;  executable codon. The state-var on TOS is compared to a memory of the
;  previously encountered state (pointed to by the first ilk), and no
;  action is performed iff the state has not changed. Otherwise (i.e. iff a
;  state change has occurred), the list is scanned. The (non-zero) value on
;  TOS is compared to each tag in the list, until either a match is found,
;  or a zero-valued tag is encountered, signifying end-of-list -- in which
;  case, nothing happens except wasted time. Iff a match is found, then the
;  single codon that follows the matching tag is executed. Note that the
;  list is scanned in sequential order, so "early" entries will be found
;  and executed more quickly than "later" entries. The base addr of the
;  list is the 2nd ilk.

xswitchk  ; ( tag -- )  *prev_tag.ilk, *switch_list.ilk


;  switchk scans an un-ordered search-list consisting of pairs of word.16
;  entries: an arbitrary tag, followed by a single executable codon. The
;  (non-zero) value on TOS is compared to each tag in the list, until
;  either a match is found, or a zero-valued tag is encountered, signifying
;  end-of-list -- in which case, nothing happens except wasted time. Iff a
;  match is found, then the single codon that follows the matching tag is
;  executed. Note that the list is scanned in sequential order, so "early"
;  entries will be found and executed more quickly than "later" entries.
;  The base address of the list is an ilk.


;
;  xswitchkx:  The novelty-seeking state-transitor:
;
;  xswitchkx (and other members of the "switch" family) becomes especially
;  useful when the "case" family (or other LUT-based schemes) become
;  sparsely populated, cumbersome, and wasteful of memory;  e.g. mapping a
;  set of keyboard-driven responses.  Note that the default (no change)
;  codon can contain another "switch" derivative, consulting another list
;  and the state-var memory, to execute a repeated subset of actions (or
;  any other arbitrary actions) that don't (or do) care that the state has
;  not changed since the previous invocation.
;
;  xswitchkx conditionally scans an un-ordered search-list consisting of
;  pairs of word.32 entries: an arbitrary tag, followed by a single
;  executable codon.  The state-var on TOS is compared to a memory of the
;  previously encountered state (pointed to by the 1st ilk), and a
;  default action (a single codon, pointed to by the 2nd ilk) is performed
;  iff the state has not changed.  Otherwise (i.e. iff a state change has
;  occurred), the list (the start address of which is pointed to by the
;  3rd ilk) is scanned.  The (non-zero) value on TOS is compared
;  to each tag in the list, until either a match is found, or a zero-valued
;  tag is encountered, signifying end-of-list -- in which case, a trap
;  action (a single codon, pointed to by the 4th ilk) is performed.  Iff a
;  match is found, then the single codon that follows the matching tag is
;  executed. Note that the list is scanned in sequential order, so "early"
;  entries will be found and executed more quickly than "later" entries.
;
;  Especially note also: a TOS value of zero is permitted, and can have a
;  special significance; although a zero-tag in the list indicates that the
;  list is exhausted and aborts the scan, a novel (i.e. not already logged
;  in the state-variable memory as being the previous state) value of zero
;  on TOS will find a match at the end of the list, and execute it's
;  following codon as per any other (normal) tag-match -- once only, until
;  a non-zero value is again encountered, and recorded in the
;  state-variable memory, restoring zero's novelty.  (see example below)
;
;  The example below contains some 4-byte ASCII tags (neccessarily in
;  'single' quotes).  Note also that:
;  long strings can be checksummed, CRC'd, or otherwise hashed to yield a
;  compact 32-bit tag/token -- which is a helluva lot quicker (and smaller
;  footprint) than performing a fully-scanned string-match comparison...
;
;
;   EXAMPLE:
;
;  .
;  .
;StateVar  DS32  1 ; RAM-based state-variable memory
;  .
;  .
;  .
;  DC32  xswitchkx, StateVar, NoChangeDefault, SWITCHES, NoMatchTrap
;  .
;  .
;  .
;SWITCHES
;  DC32  0FEDCBA98h, DescendingHex
;  DC32  'Not1', TurnOff
;  DC32  3333333333, Do3Giga
;  DC32  -1, IncrementToZero
;  DC32  'v4th', foobar
;  DC32  0, NovelZeroTrap  ; <<< end of list
;  DC32  xxxx, DontCareAnymore
;  .
;  .
;
;NoChangeDefault
;  xeq'l def'n
;  .
;DescendingHex
;  xeq'l def'n
;  .
;TurnOff
;  xeq'l def'n
;  .
;Do3Giga
;  xeq'l def'n
;  .
;IncrementToZero
;  xeq'l def'n
;  .
;foobar
;  xeq'l def'n
;  .
;NovelZeroTrap
;  xeq'l def'n
;  .
;NoMatchTrap
;  xeq'l def'n
;  .
;


xswitchkx ; ( tag -- )
  ; *prev_tag.ilk, default_codon.ilk, *switch_list.ilk, trap_codon.ilk

  mov k, t    ; need to DROP, no matter what, so...
  DROP      ; ...might as well get it over with
  ldr x, [i], #16 ; get *prev_tag, post-inc to "next" xeq'l codon
  ldr w, [x]    ; get prev_tag
  str k, [x]    ; store current_tag as prev_tag for future ref
  cmp k, w    ; ? new tag val?
  ldreq PC, [i, #-12] ; cond'l xeq'n of default@ilk.2 iff == prev_tag

  ldrne x, [i, #-8] ; novel tag:  get *switch_list.ilk3
        ; (i.e. 1st tag candidate)
_xswitchx
  ldr w, [x], #8  ; get tag candidate, post-inc past xeq'l codon
  cmp k, w    ; ? tag-match from list?
  ldreq PC, [x, #-4]  ; cond'ly xeq codon from list iff tag == match
        ; (may be a novel zero)

  teq w, #0   ; no match:  ? zero == end of list?
  ldreq PC, [i, #-4]  ; cond'ly xeq trap codon iff end of list (== 0)

  bne _xswitchx ; else loop back, to continue scanning list

; <<<<<  PC cannot get to here, no way, no how...



;  "REAL-LIFE" (test) EXAMPLE of xswitchkx:
;
;HOT ; v4th is go for launch...
;
;  DC32 doit
;
;
;doit:
;  NEST
; DC32 ilk,-2, begin
; DC32 dup,asr1
;
; DC32 xswitchkx, Svar,Same,TEST,NoGo
;
; DC32 inc, again
;
;
;
;Same  NEST
; DC32 dup,nott,drop,nexit
;
;
;TEST
;  DC32  -1, mone
;  DC32  2, too
;  DC32  1, wun
;  DC32  0, EndOfList
;  DC32  7, 0  ; never gets to here...
;
;
;mone  DUP
;  mov t, #-1
;  DROP
;  NEXT
;
;wun DUP
;  mov t, #1
;  DROP
;  NEXT
;
;too NEST
; DC32 ilk,2,drop,nexit
;
;EndOfList
;  DUP
;  mov t, #'E'
;  DROP
;  NEXT
;
;
;NoGo  NEST
; DC32 jamk,0EEEEEEEEh,nexit
;

