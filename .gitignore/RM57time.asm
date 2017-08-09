
  DC8   __FILE__
  ALIGNROM 2


movRTI64k        ; ( -- ) capture timestamp64 to memvar
  ldr y,[i],#4
  mov32 x,RTIFRC0
  ldrd  ra,rb,[x] ; 
  str  rb,[y], #4 ; 
  str  ra,[y] ; 
  NEXT


getRTI64        ; ( -- ls32, ms32 ) timestamp64
  DDUP
  mov32 x,RTIFRC0
  ldr  t, [x],#4
  ldr  n, [x]
  NEXT


getRTIlo        ; ( -- ls32 ) timestampLS32
  DUP
  mov32 x,RTIFRC0
  ldr   t,[x],#4  ; dummy read to latch RTIUC0
  ldr   t,[x] ; lsW in t (from  RTIUC0)
  NEXT

getRTIhi        ; ( -- ms32 ) timestampMS32
  DUP
  mov32 x,RTIFRC0
  ldr   t,[x]  ; 
  NEXT

;getRTIlo        ; ( -- ls32 ) timestampLS32
  NEST
  DC32  atk,RTIFRC0,drop  ; dummy read to latch RTIUC0
  DC32  atk,RTIUC0
  DC32  nexit


