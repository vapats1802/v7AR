//
v4play_b79;	RAM declarations
//


   ASEGN DATA, 200h

Time	DS32	1	; binary time, systick
Dmode	DS16	1	; mode/state var for Dnext v4th monitor/debugger
Lptr	DS16	1	; loop-stack pointer

Rnum	DS16	1	; "random" number, *+ method
M24	DS32	1	; pseudo-random LFSR m-sequence
HPSA	DS16	1	; pseudo-random LFSR m-sequence
CRC16	DS16	1	; pseudo-random LFSR m-sequence
CRC32	DS32	1	; pseudo-random LFSR m-sequence

//Tvar	DS16	1	; test state-var
//Lrfn	DS16	1	; loop endpoint marker

TOD01	DS8	1	; BCD time of day, sec/100
TODs	DS8	1	; BCD time of day, sec
TODm	DS8	1	; BCD time of day, min
TODh	DS8	1	; BCD time of day, hour

TODd	DS16	1	; calendar, binary day of year
TODdow	DS8	1	; calendar, binary day of week
TODdom	DS8	1	; calendar, binary day of month
TODmon	DS8	1	; calendar, binary month
TOD	DS8	1	; calendar, binary un-assigned	<<<<<
TODy	DS16	1	; calendar, binary year

TOA01	DS8	1	; BCD alarm time, sec/100
TOAs	DS8	1	; BCD alarm time, sec
TOAm	DS8	1	; BCD alarm time, min
TOAh	DS8	1	; BCD alarm time, hour
TOAd	DS16	1	; BCD alarm time, day

PADx	DS16	1	; char pointer, usually into PAD...
PADq	DS16	1	; PAD as fifo, wr ptr
PADr	DS16	1	; PAD fifo rd ptr
PADend	DS16	1	;
PAD	DS8	32		; SET	h
TIBx	DS16	1	; char pointer, usually into TIB...
TIBq	DS16	1	; TIB as fifo, wr ptr
TIBr	DS16	1	; TIB fifo rd ptr
TIBend	DS16	1	;
TIB	DS8	8	;32		; SET	h

RegSave	DS16	16
DIB	DS8	4	;
DOB	EQU	.	;

//  ORG	0C0h	; relative to ASEG		<<<<<
Lstack	DS16	7	; loop stack
Linit	DS16	1		; SET	29Eh
Pstack	DS16	7	; parameter stack
Pinit	DS16	1		; SET	2BEh
Rstack	DS16	7	; return stack
Rinit	DS16	1		; SET	2DEh
Hstack	DS16	7	; native machine h/w & interrupt stack
SPinit	DS16	1		; SET	2FEh
RAMend	EQU	$		; SET	300h