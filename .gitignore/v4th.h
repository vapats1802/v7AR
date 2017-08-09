//  v4th register-usage conventions

#define t r0  // cache TOS & NOS in reg, best strategy for ARM
#define n r1  // cache TOS & NOS in reg, best strategy for ARM
#define x r2  // scratch
#define y r3  // scratch
#define w r4  // scratch

#define i r5  //  Interpreter Pointer
#define r r6  //  RP does not use R13 h/w SP...
#define p r7  //  Parameter pointer

#define u r8  // scratch
#define v r9  // scratch
#define a r10  // scratch
#define ra  r10  // 

#define j r11  // scratch
#define rb  r11 //

#define k r12 // scratch, usually kounter for fast local loops

// SP  r13
// LR  r14
// PC  r15


//  misc. handy equates

maxint  EQU 07FFFFFFFh
minint  EQU 080000000h

bel EQU 7
bs  EQU 8
ht  EQU 9
lf  EQU 0Ah
vt  EQU 0Bh
ff  EQU 0Ch
cr  EQU 0Dh
esc EQU 1Bh
nl  EQU 0A0Dh

