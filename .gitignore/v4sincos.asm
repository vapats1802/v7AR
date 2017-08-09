


sincos	; (anglefrac -- sin, cos)	lut.8 entries, but ENOB = 9
; anglefrac is LSfraction of int.frac data, 0..1 rev (= 0..360 degrees)

//	replaced with machine code optimization
//	NEST
//	DW	scaprep, casek, SinCos, nexit

	mov	#5, K
	msrlk	K, T	; form LUT index for pair of byte.8's
	mov	T, W
	mov.b	T, T	; strip 3 MSbits, leaving sub-octant fractional index
	rla	T	; form sub-octant LUT ptr for pair of byte.8's
	swpb	W	; quick right-shift by 8,
	mov.b	W, W	; strip sub-octant fractional dross from MSByte,
	rla	W	; form word.16 index
	add	#SinCos, W	; form branch LUT ptr
	mov	@W, PC	; handle octant



SinCos	; (octfrac -- cos, sin)	handle each octant, lut.8 ==> ENOB = 9
	DW	_sc0
	DW	_sc1
	DW	_sc2
	DW	_sc3
	DW	_sc4
	DW	_sc5
	DW	_sc6
	DW	_sc7



//scaprep; (anglefrac -- octfrac, case)	massage anglefrac for folded-octant LUT
//	decd	P
//	mov	#5, K
//	msrlk	K, T	; form LUT ptr for pair of byte.8's
//	mov.b	T, W	; strip 3 MSbits,
//	mov	W, 0(P)	; leaving octant fraction for LUT index
//	swpb	T	; quick right-shift by 8,
//	mov.b	T, T	; strip octant fraction dross,
//	next		; leaving 3 MSbits for case index



_sc0			; i+, sc
	sub	#2, P	; prep stack
//	rla	T	; form word.16 ptr
	mov	SINCOS(T), T
	mov	T, W
	swpb	W
	mov.b	W, W
	mov	W, 0(P)
	mov.b	T, T
	next


_sc1			; i-, cs
	sub	#2, P	; prep stack
//	rla	T	; form word.16 ptr
	mneg	T
	add	#510, T	; reverse index
	mov	SINCOS(T), T
	mov	T, W
	mov.b	W, W
	mov	W, 0(P)
	swpb	T
	mov.b	T, T
	next


_sc2			; i+, c-s
	sub	#2, P	; prep stack
//	rla	T	; form word.16 ptr
	mov	SINCOS(T), T
	mov	T, W
	mov.b	W, W
	mneg	W
	mov	W, 0(P)
	swpb	T
	mov.b	T, T
	next


_sc3			; i-, s-c
	sub	#2, P	; prep stack
//	rla	T	; form word.16 ptr
	mneg	T
	add	#510, T	; reverse index
	mov	SINCOS(T), T
	mov	T, W
	swpb	W
	mov.b	W, W
	mneg	W
	mov	W, 0(P)
	mov.b	T, T
	next


_sc4			; i+, -s-c
	sub	#2, P	; prep stack
//	rla	T	; form word.16 ptr
	mov	SINCOS(T), T
	mov	T, W
	swpb	W
	mov.b	W, W
	mneg	W
	mov	W, 0(P)
	mov.b	T, T
	mneg	T
	next


_sc5			; i-, -c-s
	sub	#2, P	; prep stack
//	rla	T	; form word.16 ptr
	mneg	T
	add	#510, T	; reverse index
	mov	SINCOS(T), T
	mov	T, W
	mov.b	W, W
	mneg	W
	mov	W, 0(P)
	swpb	T
	mov.b	T, T
	mneg	T
	next


_sc6			; i+, -cs
	sub	#2, P	; prep stack
//	rla	T	; form word.16 ptr
	mov	SINCOS(T), T
	mov	T, W
	mov.b	W, W
	mov	W, 0(P)
	swpb	T
	mov.b	T, T
	mneg	T
	next


_sc7			; i-, -sc
	sub	#2, P	; prep stack
//	rla	T	; form word.16 ptr
	mneg	T
	add	#510, T	; reverse index
	mov	SINCOS(T), T
	mov	T, W
	swpb	W
	mov.b	W, W
	mov	W, 0(P)
	mov.b	T, T
	mneg	T
	next



SINCOS	; LUT for 1 octant/256 = 1 rev/2048 resol'n

	DC8	0,255
	DC8	1,255
	DC8	2,255
	DC8	2,255
	DC8	3,255
	DC8	4,255
	DC8	5,255
	DC8	5,255
	DC8	6,255
	DC8	7,255
	DC8	8,255
	DC8	9,255
	DC8	9,255
	DC8	10,255
	DC8	11,255
	DC8	12,255
	DC8	13,255
	DC8	13,255
	DC8	14,255
	DC8	15,255
	DC8	16,255
	DC8	16,254
	DC8	17,254
	DC8	18,254
	DC8	19,254
	DC8	20,254
	DC8	20,254
	DC8	21,254
	DC8	22,254
	DC8	23,254
	DC8	23,254
	DC8	24,254
	DC8	25,254
	DC8	26,254
	DC8	27,254
	DC8	27,254
	DC8	28,253
	DC8	29,253
	DC8	30,253
	DC8	30,253
	DC8	31,253
	DC8	32,253
	DC8	33,253
	DC8	34,253
	DC8	34,253
	DC8	35,253
	DC8	36,252
	DC8	37,252
	DC8	37,252
	DC8	38,252
	DC8	39,252
	DC8	40,252
	DC8	41,252
	DC8	41,252
	DC8	42,252
	DC8	43,251
	DC8	44,251
	DC8	44,251
	DC8	45,251
	DC8	46,251
	DC8	47,251
	DC8	47,251
	DC8	48,250
	DC8	49,250
	DC8	50,250
	DC8	51,250
	DC8	51,250
	DC8	52,250
	DC8	53,249
	DC8	54,249
	DC8	54,249
	DC8	55,249
	DC8	56,249
	DC8	57,249
	DC8	57,248
	DC8	58,248
	DC8	59,248
	DC8	60,248
	DC8	60,248
	DC8	61,248
	DC8	62,247
	DC8	63,247
	DC8	64,247
	DC8	64,247
	DC8	65,247
	DC8	66,246
	DC8	67,246
	DC8	67,246
	DC8	68,246
	DC8	69,246
	DC8	70,245
	DC8	70,245
	DC8	71,245
	DC8	72,245
	DC8	73,244
	DC8	73,244
	DC8	74,244
	DC8	75,244
	DC8	76,244
	DC8	76,243
	DC8	77,243
	DC8	78,243
	DC8	79,243
	DC8	79,242
	DC8	80,242
	DC8	81,242
	DC8	82,242
	DC8	82,241
	DC8	83,241
	DC8	84,241
	DC8	85,241
	DC8	85,240
	DC8	86,240
	DC8	87,240
	DC8	87,240
	DC8	88,239
	DC8	89,239
	DC8	90,239
	DC8	90,238
	DC8	91,238
	DC8	92,238
	DC8	93,238
	DC8	93,237
	DC8	94,237
	DC8	95,237
	DC8	96,236
	DC8	96,236
	DC8	97,236
	DC8	98,236
	DC8	98,235
	DC8	99,235
	DC8	100,235
	DC8	101,234
	DC8	101,234
	DC8	102,234
	DC8	103,233
	DC8	103,233
	DC8	104,233
	DC8	105,232
	DC8	106,232
	DC8	106,232
	DC8	107,231
	DC8	108,231
	DC8	108,231
	DC8	109,230
	DC8	110,230
	DC8	111,230
	DC8	111,229
	DC8	112,229
	DC8	113,229
	DC8	113,228
	DC8	114,228
	DC8	115,228
	DC8	115,227
	DC8	116,227
	DC8	117,227
	DC8	118,226
	DC8	118,226
	DC8	119,226
	DC8	120,225
	DC8	120,225
	DC8	121,224
	DC8	122,224
	DC8	122,224
	DC8	123,223
	DC8	124,223
	DC8	124,223
	DC8	125,222
	DC8	126,222
	DC8	126,221
	DC8	127,221
	DC8	128,221
	DC8	129,220
	DC8	129,220
	DC8	130,219
	DC8	131,219
	DC8	131,219
	DC8	132,218
	DC8	133,218
	DC8	133,217
	DC8	134,217
	DC8	135,217
	DC8	135,216
	DC8	136,216
	DC8	137,215
	DC8	137,215
	DC8	138,215
	DC8	139,214
	DC8	139,214
	DC8	140,213
	DC8	140,213
	DC8	141,212
	DC8	142,212
	DC8	142,212
	DC8	143,211
	DC8	144,211
	DC8	144,210
	DC8	145,210
	DC8	146,209
	DC8	146,209
	DC8	147,208
	DC8	148,208
	DC8	148,207
	DC8	149,207
	DC8	150,207
	DC8	150,206
	DC8	151,206
	DC8	151,205
	DC8	152,205
	DC8	153,204
	DC8	153,204
	DC8	154,203
	DC8	155,203
	DC8	155,202
	DC8	156,202
	DC8	156,201
	DC8	157,201
	DC8	158,200
	DC8	158,200
	DC8	159,199
	DC8	159,199
	DC8	160,198
	DC8	161,198
	DC8	161,198
	DC8	162,197
	DC8	163,197
	DC8	163,196
	DC8	164,196
	DC8	164,195
	DC8	165,194
	DC8	166,194
	DC8	166,193
	DC8	167,193
	DC8	167,192
	DC8	168,192
	DC8	168,191
	DC8	169,191
	DC8	170,190
	DC8	170,190
	DC8	171,189
	DC8	171,189
	DC8	172,188
	DC8	173,188
	DC8	173,187
	DC8	174,187
	DC8	174,186
	DC8	175,186
	DC8	175,185
	DC8	176,185
	DC8	177,184
	DC8	177,183
	DC8	178,183
	DC8	178,182
	DC8	179,182
	DC8	179,181
	DC8	180,180
