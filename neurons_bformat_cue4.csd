<CsoundSynthesizer>
<CsInstruments>

sr = 96000
kr = 96000
ksmps = 1
nchnls = 4
;nchnls = 2


idep = 2 /* early reflection depth */

itmp ftgen 1, 0, 64, -2,                                        \
	/* depth1, depth2, max delay, IR length, idist, seed */ \
	idep, 48, -1, 0.01, 0.25, 123,                          \
	/*  DIST  rand reflev  EQ   EQlev  Q  EQmode */       \
	1, 21.907, .2, 0.87, 12000.0, 0.6, 0.7, 2, /* ceil  */ \
	1, 29.775, .2, 0.17, 50.0, 0.5, 0.7, 2, /* floor */ \
	1, 31.231, .2, 0.27, 800.0, 0.6, 0.7, 2, /* front */ \
	1, 35.329, .2, 0.37, 200.0, 0.6, 0.7, 2, /* back  */ \
	1, 20.567, .2, 0.47, 500.0, 0.6, 0.7, 2, /* right */ \
	1, 20.111, .2, 0.47, 900.0, 0.6, 0.7, 2  /* left  */ 


instr 1

iskiptime = p4
a1       soundin "lowpass.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     expseg p5, 0.5*p3, p6, 0.5*p3, p5     ; azimuth
kelev     expseg p7, 0.5*p3, p8, 0.5*p3, p7 ; elevation
kdist	  expseg p9, 0.5*p3, p10, 0.5*p3, p9	; distance

; convert coordinates
kX	=  kdist * cos(kelev * 0.01745329) * sin(kazim * 0.01745329)
kY	=  kdist * cos(kelev * 0.01745329) * cos(kazim * 0.01745329)
kZ	=  kdist * sin(kelev * 0.01745329)


a1      =  a1 + 0.000001 * 0.000001     ; avoid underflows

imode   =  3    ; change this to 3 for 8 spk in a cube,
		; or 1 for simple stereo
imdel   =  0.1 ; max delay time (randomized component to delay below?)

aW, aX, aY, aZ spat3d a1, kX, kY, kZ, 1.0, 1, imode, imdel, 5

idlt    = p11 
kroomsize expseg 0.01, 0.5*p3, 0.99, 0.5*p3, 0.01 
iHFDamp    =  0.01
iSRate     =  96000
ifreq     =   100
adelW delay aW, idlt

aWlp butterhp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, kroomsize, iHFDamp, 0

aW         = (0.1 * aW + 0.4 * (aWL + aWR) + 0.6 * adelW)

idltX = 1.3 * idlt
adelX delay aX, idltX

aXlp butterhp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, kroomsize, iHFDamp, 0

aX         = (0.1 * aX + 0.4 * (aXL + aXR) + 0.6 * adelX)

idltY = 1.9 * idlt
adelY delay aY, idltY

aYlp butterhp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, kroomsize, iHFDamp, 0

aY         = (0.1 * aY + 0.4 * (aYL + aYR) + 0.6 * adelY)

idltZ = 1.9 * idlt
adelZ delay aZ, idltZ
aZlp butterhp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, kroomsize, iHFDamp, 0
aZ         = (0.1 * aZ + 0.4 * (aZL + aZR) + 0.6 * adelZ)
 
outq aW, aX, aY, aZ

;aWre, aWim      hilbert aW
; aXre, aXim      hilbert aX
; aYre, aYim      hilbert aY
; aWXr    =  0.0928*aXre + 0.4699*aWre
;aWXiYr  =  0.2550*aXim - 0.1710*aWim + 0.3277*aYre
; aleft   =  aWXr + aWXiYr
; aright  =  aWXr - aWXiYr
;outs aleft, aright
endin

instr 2

iskiptime = p4
a1       soundin "highpass.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     line p5, p3, p6     ; azimuth
kelev     line p7, p3, p8; elevation
kdist	  line p9, p3, p10	; distance

; convert coordinates
kX	=  kdist * cos(kelev * 0.01745329) * sin(kazim * 0.01745329)
kY	=  kdist * cos(kelev * 0.01745329) * cos(kazim * 0.01745329)
kZ	=  kdist * sin(kelev * 0.01745329)


a1      =  a1 + 0.000001 * 0.000001     ; avoid underflows

imode   =  3    ; change this to 3 for 8 spk in a cube,
		; or 1 for simple stereo
imdel   =  0.1 ; max delay time (randomized component to delay below?)

aW, aX, aY, aZ spat3d a1, kX, kY, kZ, 1.0, 1, imode, imdel, 5

idlt    = p11 
iroomsize = 0.01 
iHFDamp    =  0.3
iSRate     =  96000
ifreq     =   1000
adelW delay aW, idlt

aWlp butterhp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (aW + 0.3 * (aWL + aWR) + 0.5 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterhp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (aX + 0.3 * (aXL + aXR) + 0.3 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterhp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (aY + 0.3 * (aYL + aYR) + 0.1 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterhp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (aZ + 0.3 * (aZL + aZR) + 0.1 * adelZ)
 
outq aW, aX, aY, aZ

;aWre, aWim      hilbert aW
; aXre, aXim      hilbert aX
; aYre, aYim      hilbert aY
; aWXr    =  0.0928*aXre + 0.4699*aWre
;aWXiYr  =  0.2550*aXim - 0.1710*aWim + 0.3277*aYre
; aleft   =  aWXr + aWXiYr
; aright  =  aWXr - aWXiYr
;outs aleft, aright
endin

instr 3

iskiptime = p4
a1       soundin "highpassfast.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     line p5, p3, p6     ; azimuth
kelev     line p7, p3, p8; elevation
kdist	  line p9, p3, p10	; distance

; convert coordinates
kX	=  kdist * cos(kelev * 0.01745329) * sin(kazim * 0.01745329)
kY	=  kdist * cos(kelev * 0.01745329) * cos(kazim * 0.01745329)
kZ	=  kdist * sin(kelev * 0.01745329)


a1      =  a1 + 0.000001 * 0.000001     ; avoid underflows

imode   =  3    ; change this to 3 for 8 spk in a cube,
		; or 1 for simple stereo
imdel   =  0.1 ; max delay time (randomized component to delay below?)

aW, aX, aY, aZ spat3d a1, kX, kY, kZ, 1.0, 1, imode, imdel, 5

idlt    = p11 
iroomsize = 0.99 
iHFDamp    =  0
iSRate     =  96000
ifreq     =   1000
adelW delay aW, idlt

aWlp butterhp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (0.1 * aW + 0.5 * (aWL + aWR) + 0.8 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterhp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (0.1 * aX + 0.5 * (aXL + aXR) + 0.8 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterhp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (0.1 * aY + 0.5 * (aYL + aYR) + 0.8 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (0.1 * aZ + 0.5 * (aZL + aZR) + 0.8 * adelZ)
 
outq aW, aX, aY, aZ

;aWre, aWim      hilbert aW
; aXre, aXim      hilbert aX
; aYre, aYim      hilbert aY
; aWXr    =  0.0928*aXre + 0.4699*aWre
;aWXiYr  =  0.2550*aXim - 0.1710*aWim + 0.3277*aYre
; aleft   =  aWXr + aWXiYr
; aright  =  aWXr - aWXiYr
;outs aleft, aright
endin

instr 4

iskiptime = p4
aW, aX, aY, aZ soundin "neuronsinecloud4.aif", iskiptime

idlt    = p5
iroomsize = 0.99 
iHFDamp    =  0
iSRate     =  96000
ifreq     =   2000
adelW delay aW, idlt

aWlp butterhp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (0.2 * aW + 0.8 * (aWL + aWR) + 0.5 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterhp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (0.2 * aX + 0.8 * (aXL + aXR) + 0.5 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterhp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (0.3 * aY + 0.8 * (aYL + aYR) + 0.5 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterhp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (0.3 * aZ + 0.8 * (aZL + aZR) + 0.5 * adelZ)
 
outq aW, aX, aY, aZ

endin

instr 5

iskiptime = p4
a1       soundin "neuronspeedhighpass.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     line p5, p3, p6     ; azimuth
kelev     line p7, p3, p8; elevation
kdist	  line p9, p3, p10	; distance

; convert coordinates
kX	=  kdist * cos(kelev * 0.01745329) * sin(kazim * 0.01745329)
kY	=  kdist * cos(kelev * 0.01745329) * cos(kazim * 0.01745329)
kZ	=  kdist * sin(kelev * 0.01745329)


a1      =  a1 + 0.000001 * 0.000001     ; avoid underflows

imode   =  3    ; change this to 3 for 8 spk in a cube,
		; or 1 for simple stereo
imdel   =  0.1 ; max delay time (randomized component to delay below?)

aW, aX, aY, aZ spat3d a1, kX, kY, kZ, 1.0, 1, imode, imdel, 5

idlt    = p11 
iroomsize = 0.99 
iHFDamp    =  0
iSRate     =  96000
ifreq     =   10000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (0.1 * aW + 0.5 * (aWL + aWR) + 0.3 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (0.1 * aX + 0.5 * (aXL + aXR) + 0.3 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (0.1 * aY + 0.5 * (aYL + aYR) + 0.3 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (0.1 * aZ + 0.5 * (aZL + aZR) + 0.3 * adelZ)
 
outq aW, aX, aY, aZ

;aWre, aWim      hilbert aW
; aXre, aXim      hilbert aX
; aYre, aYim      hilbert aY
; aWXr    =  0.0928*aXre + 0.4699*aWre
;aWXiYr  =  0.2550*aXim - 0.1710*aWim + 0.3277*aYre
; aleft   =  aWXr + aWXiYr
; aright  =  aWXr - aWXiYr
;outs aleft, aright
endin

instr 6

iskiptime = p4
a1       soundin "neuronsinecloud2highpass2x.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     line p5, p3, p6     ; azimuth
kelev     line p7, p3, p8; elevation
kdist	  line p9, p3, p10	; distance

; convert coordinates
kX	=  kdist * cos(kelev * 0.01745329) * sin(kazim * 0.01745329)
kY	=  kdist * cos(kelev * 0.01745329) * cos(kazim * 0.01745329)
kZ	=  kdist * sin(kelev * 0.01745329)


a1      =  a1 + 0.000001 * 0.000001     ; avoid underflows

imode   =  3    ; change this to 3 for 8 spk in a cube,
		; or 1 for simple stereo
imdel   =  0.1 ; max delay time (randomized component to delay below?)

aW, aX, aY, aZ spat3d a1, kX, kY, kZ, 1.0, 1, imode, imdel, 5

idlt    = p11 
iroomsize = 0.1 
iHFDamp    =  0
iSRate     =  96000
ifreq     =   10000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (0.1 * aW + 0.5 * (aWL + aWR) + 0.3 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (0.1 * aX + 0.5 * (aXL + aXR) + 0.3 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (0.1 * aY + 0.5 * (aYL + aYR) + 0.3 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (0.1 * aZ + 0.5 * (aZL + aZR) + 0.3 * adelZ)
 
outq aW, aX, aY, aZ

;aWre, aWim      hilbert aW
; aXre, aXim      hilbert aX
; aYre, aYim      hilbert aY
; aWXr    =  0.0928*aXre + 0.4699*aWre
;aWXiYr  =  0.2550*aXim - 0.1710*aWim + 0.3277*aYre
; aleft   =  aWXr + aWXiYr
; aright  =  aWXr - aWXiYr
;outs aleft, aright
endin

instr 7

iskiptime = p4
a1       soundin "neuronsinecloud3lowpass3x.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     line p5, p3, p6     ; azimuth
kelev     line p7, p3, p8; elevation
kdist	  line p9, p3, p10	; distance

; convert coordinates
kX	=  kdist * cos(kelev * 0.01745329) * sin(kazim * 0.01745329)
kY	=  kdist * cos(kelev * 0.01745329) * cos(kazim * 0.01745329)
kZ	=  kdist * sin(kelev * 0.01745329)


a1      =  a1 + 0.000001 * 0.000001     ; avoid underflows

imode   =  3    ; change this to 3 for 8 spk in a cube,
		; or 1 for simple stereo
imdel   =  0.1 ; max delay time (randomized component to delay below?)

aW, aX, aY, aZ spat3d a1, kX, kY, kZ, 1.0, 1, imode, imdel, 5

idlt    = p11 
iroomsize = 0.1 
iHFDamp    =  0
iSRate     =  96000
ifreq     =   10000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (0.1 * aW + 0.5 * (aWL + aWR) + 0.3 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (0.1 * aX + 0.5 * (aXL + aXR) + 0.3 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (0.1 * aY + 0.5 * (aYL + aYR) + 0.3 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (0.1 * aZ + 0.5 * (aZL + aZR) + 0.3 * adelZ)
 
outq aW, aX, aY, aZ

;aWre, aWim      hilbert aW
; aXre, aXim      hilbert aX
; aYre, aYim      hilbert aY
; aWXr    =  0.0928*aXre + 0.4699*aWre
;aWXiYr  =  0.2550*aXim - 0.1710*aWim + 0.3277*aYre
; aleft   =  aWXr + aWXiYr
; aright  =  aWXr - aWXiYr
;outs aleft, aright
endin

instr 8

iskiptime = p4
aW, aX, aY, aZ soundin "bflatoddpartialsfreqconv2.aif", iskiptime
 aW = 0.04 * aW
 aX = 0.04 * aX
 aY = 0.04 * aY
 aZ = 0.04 * aZ
outq aW, aX, aY, aZ
endin

instr 9

iskiptime = p4
aW, aX, aY, aZ soundin "bflatoddpartialsampconv.aif", iskiptime
 aW = 0.03 * aW
 aX = 0.03 * aX
 aY = 0.03 * aY
 aZ = 0.03 * aZ
outq aW, aX, aY, aZ
endin

instr 10

iskiptime = p4
aW, aX, aY, aZ soundin "bflatgrainspat.aif", iskiptime

kgain line p5, p3, p6 
iroomsize = 0.1 
iHFDamp    =  0.01
iSRate     =  96000
ifreq     =   200

 ;aWlp butterhp aW, ifreq
 aWL, aWR freeverb aW, aW, iroomsize, iHFDamp, 0
 aW         = kgain * (aWL + aWR)
 
 ;aXlp butterhp aX, ifreq
 aXL, aXR freeverb aX, aX, iroomsize, iHFDamp, 0
 aX         = kgain * (aXL + aXR)
 
 ;aYlp butterhp aY, ifreq
 aYL, aYR freeverb aY, aY, iroomsize, iHFDamp, 0
 aY         = kgain * (aYL + aYR)
 
 ;aZlp butterhp aZ, ifreq
 aZL, aZR freeverb aZ, aZ, iroomsize, iHFDamp, 0
 aZ         = kgain * (aZL + aZR)
 
outq aW, aX, aY, aZ
endin

instr 11
iskiptime = p4
aW, aX, aY, aZ soundin "identitychordspeedallpassspin.aif", iskiptime
  aW = 0.2 * aW
 aX = 0.2 * aX
 aY = 0.2 * aY
 aZ = 0.2 * aZ
outq aW, aX, aY, aZ 
endin

instr 12
iskiptime = p4
aW, aX, aY, aZ soundin "identitychordspeedallpassrotate.aif", iskiptime
  aW = 0.15 * aW
 aX = 0.15 * aX
 aY = 0.15 * aY
 aZ = 0.15 * aZ
outq aW, aX, aY, aZ 
endin

instr 13
iskiptime = p4
a1       soundin "finalchord.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     line p5, p3, p6     ; azimuth
kelev     line p7, p3, p8; elevation
kdist	  line p9, p3, p10	; distance

; convert coordinates
kX	=  kdist * cos(kelev * 0.01745329) * sin(kazim * 0.01745329)
kY	=  kdist * cos(kelev * 0.01745329) * cos(kazim * 0.01745329)
kZ	=  kdist * sin(kelev * 0.01745329)


a1      =  a1 + 0.000001 * 0.000001     ; avoid underflows

imode   =  3    ; change this to 3 for 8 spk in a cube,
		; or 1 for simple stereo
imdel   =  0.1 ; max delay time (randomized component to delay below?)

aW, aX, aY, aZ spat3d a1, kX, kY, kZ, 1.0, 1, imode, imdel, 5

idlt    = p11 
iroomsize = 0.99 
iHFDamp    =  0
iSRate     =  96000
ifreq     =   200
adelW delay aW, idlt

aWlp butterhp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (0.1 * aW + 0.5 * (aWL + aWR) + 0.3 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterhp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (0.1 * aX + 0.5 * (aXL + aXR) + 0.3 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterhp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (0.1 * aY + 0.5 * (aYL + aYR) + 0.3 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterhp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (0.1 * aZ + 0.5 * (aZL + aZR) + 0.3 * adelZ)
 
outq aW, aX, aY, aZ 
endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f4 0 1024 19 .5 .5 270 .5

i1 0 113 0 270 90 -90 -1 25 8 0.1
i2 13 98 0 -90 90 1 90 25 1 0.4
i3 92 88 0 1 360 40 40 3 10 3.0
i4 100 76 0 2.0
i5 110 92 0 180 270 -30 -30 5 18 0.5 
i10 115 87 0 0.3 0.001
i8 120 17 0 
i6 130 42 0 1 360 1 90 20 20 0.5
i11 135 17 0
i9 140 17 0
i12 155 17 0
i13 160 34 0 1 360 90 1 2 8 3.0 
i7 165 28 0 360 1 90 1 13 20 1.0


;i7 235 5 0   
;i5 15 10 3 1 180 10 3 2
;more of i4 as i3 builds up!
;very faint pure neuron pulses in the background for the past 30+ seconds?
e

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>22</y>
 <width>400</width>
 <height>200</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{6eff1266-b10c-4c75-bf65-c4fc65112d9e}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.97000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
