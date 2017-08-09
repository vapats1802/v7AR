B2S	//	NEST
	// DC32 lsrk,9,nexit

d200h
sr9
	mov	t, t, lsr #9
	NEXT



sl5	mov	t, t, lsl #5
	NEXT



sl10	mov	t, t, lsl #10
	NEXT


S2B	//	NEST
	// DC32 lslk,9,nexit

x200h
sl9	mov	t, t, lsl #9
	NEXT


sl6	mov	t, t, lsl #6
	NEXT


sr2	mov	t, t, lsr #2
	NEXT


asr2	mov	t, t, asr #2
	NEXT


sl3	mov	t, t, lsl #3
	NEXT


sl15	mov	t, t, lsl #15
	NEXT


lsr6	mov	t, t, lsr #6
	NEXT


lsr3	mov	t, t, lsr #3
	NEXT



asr13	mov	t, t, asr #13
	NEXT


asr12	mov	t, t, asr #12
	NEXT


asr3	mov	t, t, asr #3
	NEXT




x4
sl2
	mov	t, t, lsl #2
	NEXT



//   sln	;  ( x, n -- x' )	shift NOS left by TOS bits, zero-filled
//   sr1	;  ( x -- x' )		shift right by 1 bit, zero-extended



