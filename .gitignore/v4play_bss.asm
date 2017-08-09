//
v4th_b43;	RAM declarations
//


   SECTION .noinit : DATA(2)

//   ORG 0h	; INTVEC re-map, ORG is rel to segment start	<<<<<
ramIntVecs
ramRST		DS32	1	; dummy
ramUND		DS32	1	;
ramSWI		DS32	1	;
ramPAB		DS32	1	;
ramDAB		DS32	1	;
ramflashxsum	DS32	1	; dummy
ramIRQ		DS32	1	;
ramFIQ		DS32	1	;

ramRSTvect	DS32	1	; dummy
ramUNDvect	DS32	1	; UNDhandler
ramSWIvect	DS32	1	; SWIhandler
ramPABvect	DS32	1	; PABhandler
ramDABvect	DS32	1	; DABhandler
ramFlashXsum	DS32	1	; dummy
ramIRQvect	DS32	1	; IRQhandler

ramFIQvect	; alias
XramFIQvect	DS32	1	; FIQhandler
YramFIQvect	DS32	1	; FIQhandler


///   ORG 40h	; skip INTVEC re-map (64 bytes), ORG is rel to segment start

PAD10x		DS32	1	; char pointer for decimal xlat'n
PAD10		DS32	4	; string buffer for decimal xlat'n, with "-" and 0-null
PADx		DS32	1	; char pointer, usually into PAD...
PADq		DS32	1	; PAD as fifo, wr ptr
PADr		DS32	1	; PAD fifo rd ptr
PADend		DS32	1	;
PAD		DS8	256		; SET	h

TIBx		DS32	1	; char pointer, usually into TIB...
TIBq		DS32	1	; TIB as fifo, wr ptr
TIBr		DS32	1	; TIB fifo rd ptr
TIBend		DS32	1	;
TIB		DS8	256		; SET	h

RegSave		DS32	32	; debug context-save block
DIB		DS8	256	; debug input buffer
DOB		DS8	256	; debug output buffer

//  ORG	0C0h	; relative to ASEG		<<<<<
Lstack		DS32	63	; loop stack
Linit		DS32	1		; SET	29Eh
Pstack		DS32	63	; parameter stack
Pinit		DS32	1		; SET	2BEh
Rstack		DS32	63	; return stack
Rinit		DS32	1		; SET	2DEh
Sstack		DS32	63	; system stack:  native machine h/w & interrupt
Sinit		DS32	1		; SET	2FEh
//RAMend	EQU	.		; SET	300h


uxsum		DS32	1	;

Svar		DS32	1	; test state-var

Time		DS32	1	; binary time, systick
Dmode		DS32	1	; mode/state var for Dnext v4th monitor/debugger


//Lptr		DS32	1	; loop-stack pointer

Rnum		DS32	1	; "random" number, *+ method
//M24		DS32	1	; pseudo-random LFSR m-sequence
//HPSA		DS32	1	; pseudo-random LFSR m-sequence
//CRC16		DS16	1	; pseudo-random LFSR m-sequence
CRC32		DS32	1	; pseudo-random LFSR m-sequence


SPIlo		DS16	1
SPIhi		DS16	1

PatColor	DS32	1
TextColor	DS32	1
FGcolor		DS32	1
BGcolor		DS32	1

cX		DS32	1	; char cursor
cY		DS32	1
cL		DS32	1	; char count (length of string)

Yrow		DS32	1
Xcol		DS32	1

HD44x		DS32	1	; char ptr for HD44 output



// touchscreen stuff
Xraw		DS32	1	; current t/s sample
Xnow		DS32	1	; current t/s sample
Xprev		DS32	1	; previous t/s sample
Xqbut		DS32	1	; putative button (maybe)
Xvbut		DS32	1	; valid button

Xmax		DS32	1	; t/s cal
Xmid		DS32	1	;
Xmin		DS32	1	;

Yraw		DS32	1	;
Ynow		DS32	1	;
Yprev		DS32	1	;
Yqbut		DS32	1	;
Yvbut		DS32	1	;

Ymax		DS32	1	; t/s cal
Ymid		DS32	1	;
Ymin		DS32	1	;



touchX		DS32	1	;
touchY		DS32	1	;
oldX		DS32	1	;
oldXPP		DS32	1	;
oldY		DS32	1	;
oldYPP		DS32	1	;

Xc		DS32	1	; cursor
Yc		DS32	1	;

Xhome		DS32	1	; cursor
Yhome		DS32	1	;
Ylf		DS32	1	;
Xmarg		DS32	1	;
Ymarg		DS32	1	;

X0		DS32	1	;
Y0		DS32	1	;

Rchan		DS32	1	;
Gchan		DS32	1	;
Bchan		DS32	1	;


// motor / DCO stuff

ccVel		DS32	1 ; <[init]  cosine-corrected MaxVel

XptpGO
YptpGO
ptpGO		DS32	1 ; <[init]  start/go flag for ptp move

Xphacc		DS32	1 ; position 16steps.3usteps.13frac
Xphinc		DS32	1 ; velocity
Xsign		DS32	1 ; velocity
uXphinc		DS32	1 ; velocity

Xstart		DS32	1 ; start-of-move pos'n
Xdest		DS32	1 ; <[init]  end-of-move target
Xdelta		DS32	1 ; move distance

XinitPhinc	DS32	1 ; <[init]  start-of-move velocity
XaccelDecim	DS32	1 ; <[init]  down-counter for divisor
XaccelDecimSet	DS32	1 ; <[init]  divisor
XaccelInc	DS32	1 ; <[init]  multiplier
XmaxVel		DS32	1 ; <[init]  max phinc
Xramp		DS32	1 ; end-of-accel mark
XdecelMark	DS32	1 ; begin decel mark:  (start + delta/2) for small moves

Xnext		DS32	1 ;
Xreq		DS16	1 ;
Yreq		DS16	1 ;

x0start		DS32	1	;
x0dest		DS32	1	;
x0delta		DS32	1	;
x0initPhinc	DS32	1	;
x0accInc	DS32	1	;
x1delta		DS32	1	;
x1initPhinc	DS32	1	;
x1accInc	DS32	1	;

uXFIQ		DS32	1	;
uYFIQ		DS32	1	;
Ubk		DS32	1	;
Ugo		DS32	1	;
BS		DS32	1	;
BSG		DS32	1	;
BK		DS32	1	;
bkfw		DS32	1	;
fff		DS32	1	;


jumpjog		DS32	1	; flag
jjejog		DS32	1	; flag

lock		DS32	1	;


y0start		DS32	1	;
y0dest		DS32	1	;
y0delta		DS32	1	;
y0initPhinc	DS32	1	;
y0accInc	DS32	1	;
y1delta		DS32	1	;
y1initPhinc	DS32	1	;
y1accInc	DS32	1	;

Yphacc		DS32	1 ; position 16steps.3usteps.13frac
Yphinc		DS32	1 ; velocity
Ysign		DS32	1 ; velocity
uYphinc		DS32	1 ; velocity
YinitPhinc	DS32	1 ; <[init]  start-of-move velocity

Ystart		DS32	1 ; start-of-move pos'n
Ydest		DS32	1 ; <[init]  end-of-move target
Ydelta		DS32	1 ; move distance

YaccelDecim	DS32	1 ; <[init]  down-counter for divisor
YaccelDecimSet	DS32	1 ; <[init]  divisor
YaccelInc	DS32	1 ; <[init]  multiplier
YmaxVel		DS32	1 ; <[init]  max phinc
Yramp		DS32	1 ; end-of-accel mark
YdecelMark	DS32	1 ; begin decel mark:  (start + delta/2) for small moves

Ynext		DS32	1 ;
Yreq_old	DS32	1 ;



Xmemoend	DS32	1 ;
Ymemoend	DS32	1 ;
Xmemo		DS32	1 ;
Ymemo		DS32	1 ;


sewX		DS32	1 ; placeholder for interrupted display
sewY		DS32	1 ;

ShowSewDecim	DS32	1 ;


UserSpeed	DS32	1 ;
auto		DS32	1 ;


segtag		DS32	1 ;

CurrentPat	DS32	1 ;


PatXmax		DS32	1 ;
PatXmaxY	DS32	1 ;

PatYmax		DS32	1 ;
PatYmaxX	DS32	1 ;

PatXmin		DS32	1 ;
PatXminY	DS32	1 ;

PatYmin		DS32	1 ;
PatYminX	DS32	1 ;

PatN		DS32	1 ; number of pattern points


jequit		DS32	1 ;

jXmax		DS32	1 ;
jXmaxY		DS32	1 ;

jYmax		DS32	1 ;
jYmaxX		DS32	1 ;

jXmin		DS32	1 ;
jXminY		DS32	1 ;

jYmin		DS32	1 ;
jYminX		DS32	1 ;

jXwidth		DS32	1 ;
jYheight	DS32	1 ;

jXmid		DS32	1 ;
jYmid		DS32	1 ;

jYisBigger	DS32	1 ;
jAspectRatio	DS32	1 ;
jzoom		DS32	1 ;

BBxl		DS32	1 ; Bounding Box
BBxh		DS32	1 ;
BByl		DS32	1 ;
BByh		DS32	1 ;

Lxl		DS32	1 ; Lollies
Lxh		DS32	1 ;
Lyl		DS32	1 ;
Lyh		DS32	1 ;

undoX0th	DS32	1 ;
undoY0th	DS32	1 ;

jX0		DS32	1 ;
jY0		DS32	1 ;

PatX0th		DS32	1 ; initial courtesy jump (maybe)
PatY0th		DS32	1 ; initial courtesy jump (maybe)

PatX1st		DS32	1 ;
PatY1st		DS32	1 ;

PatXlast	DS32	1 ;
PatYlast	DS32	1 ;

PatXorg		DS32	1 ;
PatYorg		DS32	1 ;

PatXwidth	DS32	1 ;
PatYheight	DS32	1 ;

PatXmid		DS32	1 ;
PatYmid		DS32	1 ;

PatYisBigger	DS32	1 ;
PatAspectRatio	DS32	1 ;
zoom		DS32	1 ;

JumpButtons	DS32	(2 * 16)

Zp		DS32	1	;

SperC		DS32	1	; sectors/cluster from BPB
FATstart	DS32	1	; FAT base in abs bytes
FATpage		DS32	1	; current FAT page (sector) in abs bytes
DATcc		DS32	1	; current DAT cluster
DATstart	DS32	1	; DAT base in abs bytes
DATpage		DS32	1	; current DAT page (sector) in abs bytes
Handle		DS32	1	; current file handle
maxHandle	DS32	1	; max valid handle

Hnamex
FileNamePtr
FN$x		DS32	1	; ptr to filename$
LFNdone		DS32	1	; flag (ugly!)

FileRemaining	DS32	1	; bytes
FileSize	DS32	1	; bytes
PatternFileSizeBytes	DS32	1	; bytes
BurnPtr		DS32	1	; byte ptr MOD 512/sector

NFileTags	DS32	1	;
FileTag		DS32	1	;
DirPage		DS32	1	;


UpdateTag	DS32	1	;
CryptKey	DS32	1	;
UpSegRemaining	DS32	1	;
UpSkipLength	DS32	1	;
UpSectorStart	DS32	1	;

   ALIGNRAM 8

FAT
FATbuf		DS8	512
Handles		DS8	(32 * 64)
FileTags	DS8	(32 * 64)

   ALIGNRAM 8

DAT
DATbuf		DS8	512
sectorbuf	DS8	512
padbuf		DS8	512
vectbuf		DS8	(4*32)



   ALIGNRAM 2

Xal64		DS32	1	; phacc lo frac
Xah
Xah64		DS32	1	; phacc hi integer (usteps)

Xi64		DS32	1	; signed phinc, frac only
Xip64		DS32	1	; un-signed init phinc, frac only

Yal64		DS32	1	; phacc lo frac
Yah
Yah64		DS32	1	; phacc hi integer (usteps)

Yi64		DS32	1
Yip64		DS32	1

saveXvel	DS32	1	;
saveYvel	DS32	1	;

Xfwd		DS32	1	; un-signed init phinc, frac only
Yfwd		DS32	1	; phacc lo frac
wentback	DS32	1	; flag

bkSpeed		DS32	1	;

JogSaveXphinc	DS32	1	;
JogSaveYphinc	DS32	1	;


ccVel64		DS32	1	; frac
moquo64		DS32	1	; rec'l slope
RPFquo64	DS32	1	; rec'l slope
RPFSpeed	DS32	1	;

Xil64		DS32	1
Xih64		DS32	1
Yil64		DS32	1
Yih64		DS32	1

SewPtr		DS32	1

envjumpcount	DS32	1
envjumpgate	DS32	1

jumpmemo	DS32	1
ppmemo		DS32	1
pppmemo		DS32	1
ppx		DS32	1
ppy		DS32	1

LinealInches	DS32	1
oldTDy		DS32	1	; slider un-draw

ramSetups
Throat		DS32	1
TinyStitch	DS32	1
motorX		DS32	1
motorY		DS32	1
SMdelay		DS32	1


SaveUserSpeed		DS32	1
trcstop		DS32	1
ddelta		DS32	1
corner		DS32	1
   ALIGNRAM (4)
Axbb		DS32	1
Aybb		DS32	1
Bxbb		DS32	1
Bybb		DS32	1
Cxbb		DS32	1
Cybb		DS32	1
Dxbb		DS32	1
Dybb		DS32	1
   ALIGNRAM (4)
tracepat	DS32	13


odo		DS32	1
odot		DS32	1
XoldOdo		DS32	1
YoldOdo		DS32	1


jogxfrom	DS32	1

waspause	DS32	1
pauseX		DS32	1
pauseY		DS32	1

oldshowsewX	DS32	1
oldshowsewY	DS32	1

Xsnip		DS32	1
Ysnip		DS32	1


RPFminorDelta	DS32	1	;


smon		DS32	1	; ABM




SCgate		DS32	1
air		DS32	1
tack		DS32	1
pXlen		DS32	1
pYlen		DS32	1
SliderTackLength	DS32	2	; double, arbitrary units
LengthTillTack		DS32	1	; in usteps
TicksTillTack		DS32	1	; in ticks
tacklength		DS32	1	; in ticks
; ISR:
tackstart	DS32	1	; @ tick (TicksTillTack-(2*tacklength))
tacktick	DS32	1	; ISR tick, = -(tacklength) at start
XTackVel	DS32	1	; phinc
YTackVel	DS32	1	; phinc
XSewVel		DS32	1	; phinc
YSewVel		DS32	1	; phinc
sewendtick	DS32	1	; prediction


InScript		DS32	1
ScriptLength		DS32	1
ScriptEnd		DS32	1
ScriptNum		DS32	1
ScriptPatNamePtr	DS32	1
ScriptNamePtr		DS32	1
Script$Ptr		DS32	1
ScriptPosnPtr		DS32	1
ScriptRemaining		DS32	1
ScriptRmark		DS32	1


NDirTags	DS32	1	;
DirTagPtr	DS32	1	;

NScriptTags	DS32	1	;
ScriptTagPtr	DS32	1	;

NPatTags	DS32	1	;
PatTagPtr	DS32	1	;

NFSTags		DS32	1	;
FSTag		DS32	1	;


SortBase	DS32	1	; start of tag-array to be sorted
SortSize	DS32	1	; number of dwords to sort
SortByte	DS32	1	; byte offset into target $tring
NSortSwaps	DS32	1	; count of swapped bubbles
NSortEligs	DS32	1	; number of remaining candidates for sorting
swap1		DS32	1	;
swap2		DS32	1	;

SortEligsGuard	DS32	1



oldtXs1		DS32	1
oldtXs2		DS32	1
oldtYs1		DS32	1
oldtYs2		DS32	1


NewSlideX	DS32	1
NewSlideY	DS32	1
ARlock		DS32	1
newXwidth	DS32	1
newYheight	DS32	1
resizeXfactor	DS32	1
resizeYfactor	DS32	1

orthofunc	DS32	1
Xtag		DS32	1
Ytag		DS32	1

smartXref	DS32	1
smartYref	DS32	1
smartMinErr	DS32	1
smartMinErrPtr	DS32	1
smartXminerr	DS32	1
smartYminerr	DS32	1
smartXminerrPt	DS32	1
smartYminerrPt	DS32	1



   ALIGNRAM 8

SortEligs	DS32	64

DirTags		DS32	64
ScriptTags	DS32	64
PatTags		DS32	64
ActionTags	DS32	64
FSTags		DS32	64

path$		DS8	64
filespec$	DS8	64



   ALIGNRAM 8

SCR
SCRbuf		DS8	8192



bangstartX	DS32	1	;
bangstartY	DS32	1	;
bangendX	DS32	1	;
bangendY	DS32	1	;
bangstop	DS32	1	;
gotmark		DS32	1	;
bangXinch	DS32	1	;
bangYinch	DS32	1	;

touchlift
joglift		DS32	1	;
RPFstick	DS32	1	;

teachcount	DS32	1	;
teachrepeat	DS32	1	;
teachXinch	DS32	1	;
teachYinch	DS32	1	;

   ALIGNRAM 4
teachstartX	DS32	1	;
teachstartY	DS32	1	;
teachbuf	DS32	256

FracPixPerByte	DS32	1	;



; triangular 3-pt. morphing

Atx		DS32	1	;
Aty		DS32	1	;
Btx		DS32	1	;
Bty		DS32	1	;
Ctx		DS32	1	;
Cty		DS32	1	;

Aix		DS32	1	;
Aiy		DS32	1	;
Bix		DS32	1	;
Biy		DS32	1	;
Cix		DS32	1	;
Ciy		DS32	1	;


Ox		DS32	1	;
Oy		DS32	1	;
Opx		DS32	1	;
Opy		DS32	1	;

sect		DS32	1	;

tcA		DS32	1	;
tcB		DS32	1	;
tcC		DS32	1	;

rtcA		DS32	1	;
rtcB		DS32	1	;
rtcC		DS32	1	;




dxOA	DS32	1
dyOA	DS32	1
mOA	DS32	1
nOA	DS32	1
cOA	DS32	1
dOA	DS32	1
dxOB	DS32	1
dyOB	DS32	1
mOB	DS32	1
nOB	DS32	1
cOB	DS32	1
dOB	DS32	1
dxOC	DS32	1
dyOC	DS32	1
mOC	DS32	1
nOC	DS32	1
cOC	DS32	1
dOC	DS32	1
dxAB	DS32	1
dyAB	DS32	1
mAB	DS32	1
nAB	DS32	1
cAB	DS32	1
dAB	DS32	1
dxBC	DS32	1
dyBC	DS32	1
mBC	DS32	1
nBC	DS32	1
cBC	DS32	1
dBC	DS32	1
dxCA	DS32	1
dyCA	DS32	1
mCA	DS32	1
nCA	DS32	1
cCA	DS32	1
dCA	DS32	1
dxOpAp	DS32	1
dyOpAp	DS32	1
mOpAp	DS32	1
nOpAp	DS32	1
cOpAp	DS32	1
dOpAp	DS32	1
dxOpBp	DS32	1
dyOpBp	DS32	1
mOpBp	DS32	1
nOpBp	DS32	1
cOpBp	DS32	1
dOpBp	DS32	1
dxOpCp	DS32	1
dyOpCp	DS32	1
mOpCp	DS32	1
nOpCp	DS32	1
cOpCp	DS32	1
dOpCp	DS32	1
dxBpCp	DS32	1
dyBpCp	DS32	1
cBpCp	DS32	1
dBpCp	DS32	1
dxCpAp	DS32	1
dyCpAp	DS32	1
mCpAp	DS32	1
nCpAp	DS32	1
cCpAp	DS32	1
dCpAp	DS32	1
tcP	DS32	1
Pdy	DS32	1
Pdx	DS32	1
dxOP	DS32	1
dyOP	DS32	1
mOP	DS32	1
rtcAcw	DS32	1
rtcAccw	DS32	1
rtcBcw	DS32	1
rtcBccw	DS32	1
rtcCcw	DS32	1
rtcCccw	DS32	1

detQ	DS32	1
;                       detQp	DS32	1
;                       lineOpQp	DS32	1
cOP	DS32	1
detQx	DS32	1
Qx	DS32	1
detQy	DS32	1
Qy	DS32	1
Vx	DS32	1
Vy	DS32	1
Wx	DS32	1
Wy	DS32	1
Vpx	DS32	1
Vpy	DS32	1
Wpx	DS32	1
Wpy	DS32	1
Tdx	DS32	1
Tdy	DS32	1

ratOPQ	DS32	1
ratVQW	DS32	1
Qpx	DS32	1
Qpy	DS32	1
dxOpQp	DS32	1
dyOpQp	DS32	1
mOpQp	DS32	1
cOpQp	DS32	1



; 2-pt. morphing
;Apx	        	DS32	1	; <<<<<  always zero
;Apy	        	DS32	1	;
;Bpx	        	DS32	1	;
;Bpy	        	DS32	1	;
FirstPatX	DS32	1	; 
FirstPatY	DS32	1	; 
LastPatX	DS32	1	; 
LastPatY	DS32	1	; 


sinorg        	DS32	1	; 
cosorg        	DS32	1	; 
sinjog        	DS32	1	; 
cosjog        	DS32	1	; 
sinalt        	DS32	1	; 
cosbase        	DS32	1	; 

BBpw        	DS32	1	; new bb width
BBph        	DS32	1	; height

BBpur        	DS32	1	; upper right
BBplr        	DS32	1	;
BBpul        	DS32	1	;
BBpll        	DS32	1	;

AB_hyp	        	DS32	1	;
ApBp_hyp 		DS32	1	;
dilmag;
ratApBp2AB		DS32	1	;

dBAx	        	DS32	1	;
dBAx2	        	DS32	2	;
dBAy	        	DS32	1	;
dBAy2	        	DS32	2	;

dBpApx	        	DS32	1	;
dBpApx2	        	DS32	2	;

dBpApy	        	DS32	1	;
dBpApy2	        	DS32	2	;


; rectangular 4-pt. morphing
rotmorph	DS32	1	;  ? tilt 45 degrees?

DAdydx  	DS32	1	;  tangents
BCdydx  	DS32	1	;  

bbAxp  	DS32	1	;  morphed bounding box
bbAyp  	DS32	1	;  
bbBxp  	DS32	1	;  
bbByp  	DS32	1	;  
bbCxp  	DS32	1	;  
bbCyp  	DS32	1	;  
bbDxp  	DS32	1	;  
bbDyp  	DS32	1	;  

Avx		DS32	1	;
Avy		DS32	1	;
Bvx		DS32	1	;
Bvy		DS32	1	;
Cvx		DS32	1	;
Cvy		DS32	1	;
Dvx		DS32	1	;
Dvy		DS32	1	;

Avpx		DS32	1	;
Avpy		DS32	1	;
Bvpx		DS32	1	;
Bvpy		DS32	1	;
Cvpx		DS32	1	;
Cvpy		DS32	1	;
Dvpx		DS32	1	;
Dvpy		DS32	1	;

; diamond 4-pt. morphing
dmx		DS32	1	;
dmy		DS32	1	;

Tvx		DS32	1	;
Tvy		DS32	1	;
Rvx		DS32	1	;
Rvy		DS32	1	;
Vvx		DS32	1	;
Vvy		DS32	1	;
Lvx		DS32	1	;
Lvy		DS32	1	;

Tvpx		DS32	1	;
Tvpy		DS32	1	;
Rvpx		DS32	1	;
Rvpy		DS32	1	;
Vvpx		DS32	1	;
Vvpy		DS32	1	;
Lvpx		DS32	1	;
Lvpy		DS32	1	;

; rawpat format:
mAx		DS32	1	;
mAy		DS32	1	;

mBx		DS32	1	;
mBy		DS32	1	;

mCx		DS32	1	;
mCy		DS32	1	;

mDx		DS32	1	;
mDy		DS32	1	;


dABx		DS32	1	;
dABy		DS32	1	;

dCBx		DS32	1	;
dCBy		DS32	1	;

dDCx		DS32	1	;
dDCy		DS32	1	;

dDAx		DS32	1	;
dDAy		DS32	1	;

dx		DS32	1	; delta for bottom left corner 'D' ?????
dy		DS32	1	;

Px		DS32	1	;
Py		DS32	1	;

mXtag		DS32	1	; pattern-point tag
mYtag		DS32	1	; pattern-point tag

mjX0		DS32	1	; morphed C-jump pos'n
mjY0		DS32	1	;

TRVLscore
ABCDscore	DS32	1 ; scoreboard for envelope vertices
jogpress1shot	DS32	1 ;
TRVLwaslast
ABCDwaslast	DS32	1 ; last vertex entered

A3x	DS32	1 ; erasure loc'n
A3y	DS32	1 ;
B3x	DS32	1 ;
B3y	DS32	1 ;
C3x	DS32	1 ;
C3y	DS32	1 ;
D3x	DS32	1 ;
D3y	DS32	1 ;

morphed		DS32	1 ;

Xsize		DS32	1 ; in pat units
Ysize		DS32	1

borderXsize	DS32	1 ; in pat units
borderYsize	DS32	1
borderXustep	DS32	1 ; in ustep (sewing) units
borderYustep	DS32	1

Axah		DS32	1	; phacc
Ayah		DS32	1	;
Apx
Axp		DS32	1	; pat
Apy
Ayp		DS32	1	;

Bxah		DS32	1	;
Byah		DS32	1	;
Bpx
Bxp		DS32	1	;
Bpy
Byp		DS32	1	;

Cxah		DS32	1	;
Cyah		DS32	1	;
Cpx
Cxp		DS32	1	;
;>>>>>Cpy
Cyp		DS32	1	;

Dxah		DS32	1	;
Dyah		DS32	1	;
Dxp		DS32	1	;
Dyp		DS32	1	;

mBBxl		DS32	1 ; morphed Bounding Box
mBBxh		DS32	1 ;
mBByl		DS32	1 ;
mBByh		DS32	1 ;


Txah		DS32	1	; phacc
Tyah		DS32	1	;
Txp		DS32	1	; pat
Typ		DS32	1	;

Rxah		DS32	1	;
Ryah		DS32	1	;
Rxp		DS32	1	;
Ryp		DS32	1	;

Vxah		DS32	1	;
Vyah		DS32	1	;
Vxp		DS32	1	;
Vyp		DS32	1	;

Lxah		DS32	1	;
Lyah		DS32	1	;
Lxp		DS32	1	;
Lyp		DS32	1	;


; mquadeqns:
dxApBp		DS32	1	; = Bpx - Apx
dyApBp		DS32	1	; = Bpy - Apy
mApBp
yxApBp		DS32	1	; = dyApBp / dxApBp
nApBp
xyApBp		DS32	1	; = dxApBp / dyApBp
cApBp		DS32	1	; = (Apy - (yxApBp * Apx))
dApBp		DS32	1	; = (Apx - (xyApBp * Apy))

dxCpBp		DS32	1	; = Bpx - Cpx
dyCpBp		DS32	1	; = Bpy - Cpy
mBpCp
yxCpBp		DS32	1	; = dyCpBp / dxCpBp
nBpCp
xyCpBp		DS32	1	; = dxCpBp / dyCpBp
cCpBp		DS32	1	; = (Cpy - (yxCpBp * Cpx))
dCpBp		DS32	1	; = (Cpx - (xyCpBp * Cpy))

dxDpCp		DS32	1	; = Cpx - Dpx
dyDpCp		DS32	1	; = Cpy - Dpy
yxDpCp		DS32	1	; = dyDpCp / dxDpCp
xyDpCp		DS32	1	; = dxDpCp / dyDpCp
cDpCp		DS32	1	; = (Dpy - (yxDpCp * Dpx))
dDpCp		DS32	1	; = (Dpx - (xyDpCp * Dpy))

dxDpAp		DS32	1	; = Apx - Dpx
dyDpAp		DS32	1	; = Apy - Dpy
yxDpAp		DS32	1	; = dyDpAp / dxDpAp
xyDpAp		DS32	1	; = dxDpAp / dyDpAp
cDpAp		DS32	1	; = (Dpy - (yxDpAp * Dpx))
dDpAp		DS32	1	; = (Dpx - (xyDpAp * Dpy))

; rats:
ratAB		DS32	1	; = (Px - Ax) / Xsize
ratCB		DS32	1	; = (Py - Cy) / Ysize
ratDC		DS32	1	; = (Px - Dx) / Xsize
ratDA		DS32	1	; = (Py - Dy) / Ysize

; ppoints:
ppApBpx		DS32	1	; = (ratAB * (Bpx - Apx)) + Apx
ppApBpy		DS32	1	; = (ratAB * (Bpy - Apy)) + Apy

ppCpBpx		DS32	1	; = (ratCB * (Bpx - Cpx)) + Cpx
ppCpBpy		DS32	1	; = (ratCB * (Bpy - Cpy)) + Cpy

ppDpCpx		DS32	1	; = (ratDC * (Cpx - Dpx)) + Dpx
ppDpCpy		DS32	1	; = (ratDC * (Cpy - Dpy)) + Dpy

ppDpApx		DS32	1	; = (ratDA * (Apx - Dpx)) + Dpx
ppDpApy		DS32	1	; = (ratDA * (Apy - Dpy)) + Dpy

; plines:
dxppDCAB	DS32	1	; = ppApBpx - ppDpCpx
dyppDCAB	DS32	1	; = ppApBpy - ppDpCpy
yxppDCAB	DS32	1	; = dyppDCAB / dxppDCAB
xyppDCAB	DS32	1	; = dxppDCAB / dyppDCAB
cppDCAB		DS32	1	; = (ppDpCpy - (yxppDCAB * ppDpCpx))
dppDCAB		DS32	1	; = (ppDpCpx - (xyppDCAB * ppDpCpy))

dxppDACB	DS32	1	; = ppCpBpx - ppDpApx
dyppDACB	DS32	1	; = ppCpBpy - ppDpApy
yxppDACB	DS32	1	; = dyppDACB / dxppDACB
xyppDACB	DS32	1	; = dxppDACB / dyppDACB
cppDACB		DS32	1	; = (ppDpApy - (yxppDACB * ppDpApx))
dppDACB		DS32	1	; = (ppDpApx - (xyppDACB * ppDpApy))

; detPp:
det		DS32	1	; = ((-yxppDCAB) - (-yxppDACB))
detx		DS32	1	; = cppDCAB - cppDACB
Ppx		DS32	1	; = (detx / det)
dety		DS32	1	; = (((-yxppDCAB) * cppDACB) - ((-yxppDACB) * cppDCAB))
Ppy		DS32	1	; = (dety / det)


; intfrac format:
///aDC		DS32	1	; initial dilation for bottom X
aDA		DS32	1	; initial dilation for left Y

bDC		DS32	1	; bottom baseline Y shear
bAB		DS32	1	; topside slope
bDA		DS32	1	; left baseline X shear
bCB		DS32	1	; rightside slope

gx		DS32	1	;
gy		DS32	1	;


ABCDbuts	DS32	((5*4)+2)	;

TRVLbuts	DS32	((5*4)+2)	;


ux		DS32	1	;
oldux		DS32	1	;
us		DS32	1	;
oldus		DS32	1	;
ua		DS32	1	;
oldua		DS32	1	;
u3		DS32	1	;
oldu3		DS32	1	;
up		DS32	1	;
oldup		DS32	1	;
ug		DS32	1	;
ug4		DS32	1	;
oldug		DS32	1	;
ut		DS32	1	;
oldut		DS32	1	;

oldY1		DS32	1	;
oldY2		DS32	1	;
oldY3		DS32	1	;

RGBud		DS32	1	;
RGBr		DS32	1	;
RGBg		DS32	1	;
RGBb		DS32	1	;

VMk				; xfer count for VM page
MMCk		DS32	1	; xfer count
VMLoadPtr	DS32	1	; xfer page
LRUn		DS32	1	; init = -1
LRUpage		DS32	1
VMpageTagCAM
VMpageTagCAM0	DS32	1
VMpageTagCAM1	DS32	1



OriginalPat     DS32    1
wasping     DS32    1
ispong     DS32    1

appendpass     DS32    1
appendVWptr     DS32    1
AppendPtr     DS32    1
AppendBurnPtr     DS32    1

chainX	DS32	1
chainY	DS32	1
tchainX	DS32	1
tchainY	DS32	1
chainxx	DS32	1
chainyy	DS32	1

VWbufPagePtr	DS32	1
VRptr	DS32	1

teachmode       DS32    1



   ALIGNRAM 9
VMpages		DS8	(2*512)
VWpage0		DS8	(512)
VWpage1		DS8	(512)



; kanji stuff
kdx		DS32	1
kdy		DS32	1
kstall		DS32	1

RXtracePtr	DS32	1
   ALIGNRAM 8
RXtrace

binscale	DS32	1 ; RNG test
binofst		DS32	1
bins		DS32	1

//HX		DS8	120		; r/m/w color-expansion for 1 H-line
//
//TLL		DS8	40		; text bitmap, leading leading
//TBAD		DS8	(10*40)		; text bitmap, font area (+ trailing leading)
//
//BAD		DS8	1		; bit-addressing area

