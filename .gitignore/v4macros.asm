	DC8	"unicode?"
   ALIGNROM 2
	DC32	mull
	DC16	mull >> 16
   ALIGNROM 2



UZ$	MACRO	A
	REPTC	a, \1
	DC16	'a'
	ENDR
	DC16	0
   ALIGNROM 2
	ENDM



	UZ$ "unicode?"


