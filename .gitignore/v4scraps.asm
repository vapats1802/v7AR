//
v4play_v43;	>>>>> app-specific hi-level v4th definitions
	nop


StacksBase	DC32	0x40000000
Rinit		DC32	0x40000020
Pinit		DC32	0x40000040



//v	MACRO
// dc32 \1, \2, \3, \4, \5, \6, \7, \8, \9, \A, \B, \C, \D, \E, \F, \G, \H
//	ENDM



; >>>>> hi-level v4th app mainline code

HOT	; v4th is go for launch...

	DC32 doit

doit:
	NEST
	DC32	ilk,12345678h,bitrev,bitrev, ilk,1,begin,lmon,drop,sl1,whilen
	DC32	ilk,0EEEEEEEEh,jamk,0,jamk,0EEEEEEEEh

//	DC32	lit,-4, begin, dup,bcasek, B_Tcase, inc, again
	DC32	lit,-4, begin, dup,switchk, Tswitch, inc, again

// v	add dup drop begin

Tswitch
	DC32	-3, TcaseTrap
	DC32	-1, TcaseTrap
	DC32	1, TcaseTrap
	DC32	3, TcaseTrap
	DC32	7, TcaseTrap
	DC32	0, nopp



B_Tcase
//	BCASED	Tcase, LL_Tcase, ML_Tcase, TcaseTrap
	ABCASED	Tcase


LL_Tcase
	DC32	nopp
	DC32	nopp
Tcase	DC32	nopp
	DC32	nopp
ML_Tcase
	DC32	nopp

TcaseTrap
	NEST
	DC32	ilk,0EEEEEEEEh,jamk,0,jamk,0EEEEEEEEh, drop,nexit



	DC32	atk,BRAND$, strk,0x40000000 ;strkk,-1,0x40000000

	DC32	ilk,0x00080000,strk,PINSEL1	; DAC, GPIO-0.31
	DC32	ilk,0x00000400,strk,PINSEL1	; PWM5, P0.31
	DC32	strkk,2,PWMTCR
	DC32	strkk,1,PWMPR
	DC32	strkk,20000000,PWMPCR
	DC32	strkk,2,PWMMCR
	DC32	strkk,100h,PWMMR0
	DC32	strkk,80h,PWMMR5
	DC32	strkk,7Fh,PWMLER
//	DC32	strkk,0,PWMEMR
	DC32	strkk,9,PWMTCR

	DC32	ilk,80h,ilk,0h,begin

//	DC32	inc,dup,andk,0x0001FFE0,strk,DACR

	DC32	atk,IO0PIN, andk,08000h, tbr,_NOUP
	DC32	inc,br,_DAC

_NOUP	DC32	atk,IO0PIN, andk,010000h, tbr,_DAC
	DC32	dec

_DAC
	DC32	dup,strk,PWMPR

	DC32	swap,inc,andk,0x0FF,dup,strk,PWMMR5,swap
	DC32	strkk,7Fh,PWMLER

	DC32	ilk,2000h, begin,dec,whilen,drop
	DC32	again


//	DC32	


	DC32	ilk,3,ilk,-4,mull, tocode	; drop,nott,inc
	DROP
	NOTT
	INC
	RE4TH
	DC32	ilk,57,ilk,9,udiv

	DC32	true,ilk,7,begin, wrap, negg,again


wrap:
	sub	t,t,#1
	TO4TH
	DC32	nott,recode	; inc,next	; <<<<< not "recode \n\t NEXT"
	INC
	NEXT

//	NEST
//	DC32	addk,-1,tocode		; nott,inc, nexit

	NOTT
	INC
	NEXIT


	DC32	tocode
	sub	t,t,#1
	NOTT
	INC
	NEXIT



	ILK	12345678h

	BEGIN
	INC
	AGAIN




