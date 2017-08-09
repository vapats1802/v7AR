
  DC8   __FILE__
  ALIGNROM 2


;setRTC
; NEST
; DC32 strkk,12h,CCR
; DC32 ubatk,makeSec
; DC32 strk,SEC
; DC32 ubatk,makeMin
; DC32 strk,MIN
; DC32 ubatk,makeHour
; DC32 strk,HOUR
; DC32 ubatk,makeDay
; DC32 strk,DOM
; DC32 strkk,0,DOW
; DC32 strkk,0,DOY
; DC32 ubatk,makeMonth
; DC32 strk,MONTH
; DC32 ubatk,makeYear
; DC32 addk,2000,strk,YEAR
; DC32 strkk,11h,CCR
;// DC32 atk,PCONP,bick,200h,strk,PCONP
; DC32 nexit
;
;
;clrRTC
; NEST
; DC32 strkk,12h,CCR
; DC32 strkk,0,SEC
; DC32 strkk,0,MIN
; DC32 strkk,0,HOUR
; DC32 strkk,0,DOM
; DC32 strkk,0,DOW
; DC32 strkk,0,DOY
; DC32 strkk,0,MONTH
; DC32 strkk,0,YEAR
; DC32 strkk,11h,CCR
; DC32 nexit


;TOD$ ; form h:m:s time-of-day ASCIIz$
; NEST
;// DC32 padi
; DC32 atk,HOUR,dd2,chark,":"
; DC32 atk,MIN,dd2,chark,":"
; DC32 atk,SEC,dd2
;// DC32 chark,'.',TOD01$
; DC32 nexit


TOD01$  ; form .nn hundredths of a second time-of-day ASCIIz$
TOD001$ ; form .nnn thousandths of a second time-of-day ASCIIz$


Day$  DC8 "Mon","Tue","Wed","Thu","Fri","Sat","Sun"

Mon$  DC8 "Dec"
  DC8 "Jan","Feb","Mar","Apr","May","Jun"
  DC8 "Jul","Aug","Sep","Oct","Nov","Dec"

   ALIGNROM 2

;FancyDate$ ; ( -- )  e.g. "Sun, May 7 2006"
; NEST
; DC32 atk,DOW,x4,addk,Day$,mov$,char2k,', '
; DC32 atk,MONTH,x4,addk,Mon$,mov$,chark,' '
; DC32 atk,DOM,i2fd$,drop,chark,' '
; DC32 atk,YEAR,dd4,chark,' '
; DC32 nexit
