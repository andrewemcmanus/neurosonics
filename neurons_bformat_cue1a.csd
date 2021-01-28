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
	1, 21.775, .2, 0.17, 50.0, 0.5, 0.7, 2, /* floor */ \
	1, 21.231, .2, 0.27, 800.0, 0.6, 0.7, 2, /* front */ \
	1, 21.329, .2, 0.37, 200.0, 0.6, 0.7, 2, /* back  */ \
	1, 21.567, .2, 0.47, 500.0, 0.6, 0.7, 2, /* right */ \
	1, 21.111, .2, 0.47, 900.0, 0.6, 0.7, 2  /* left  */ 


instr 1

iskiptime = p4
a1       soundin "neuronsinecloud1.wav", iskiptime

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
kroomsize expseg 0.99, p3, 0.01 
iHFDamp    =  0.01
iSRate     =  48000
ifreq     =   5000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, kroomsize, iHFDamp, 0

aW         = (aW + 0.3 * (aWL + aWR) + 0.5 * adelW)

idltX = 1.3 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, kroomsize, iHFDamp, 0

aX         = (aX + 0.3 * (aXL + aXR) + 0.3 * adelX)

idltY = 1.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, kroomsize, iHFDamp, 0

aY         = (aY + 0.3 * (aYL + aYR) + 0.1 * adelY)

idltZ = 1.9 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, kroomsize, iHFDamp, 0
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

instr 2

iskiptime = p4
a1       soundin "neuronpulse1f.aiff", iskiptime

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
iHFDamp    =  0.3
iSRate     =  48000
ifreq     =   1700
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (aW + 0.3 * (aWL + aWR) + 0.5 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (aX + 0.3 * (aXL + aXR) + 0.3 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (aY + 0.3 * (aYL + aYR) + 0.1 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
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
a1       soundin "neuronsinecloud2.wav", iskiptime

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
iroomsize =  0.05
iHFDamp    =  0.3
iSRate     =  48000
ifreq     =   1000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (aW + 0.3 * (aWL + aWR) + 0.5 * adelW)

idltX = 0.05 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (aX + 0.3 * (aXL + aXR) + 0.3 * adelX)

idltY = 0.2 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (aY + 0.3 * (aYL + aYR) + 0.1 * adelY)

idltZ = 0.01 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
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

instr 4

iskiptime = p4
aW, aX, aY, aZ soundin "neuronrotations3.aif", iskiptime
 
 aW = 0.4 * aW
 aX = 0.4 * aX
 aY = 0.4 * aY
 aZ = 0.4 * aZ
 
outq aW, aX, aY, aZ
endin 

instr 5

iskiptime = p4
a1       soundin "neuronpulsespeedres.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     line p5, p3, p6     ; azimuth
kelev     line p7, p3, p8 ; elevation
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
kroomsize expseg 0.01, p3, 0.99 
iHFDamp    =  0.01
iSRate     =  48000
ifreq     =   1000
adelW delay aW, idlt

aWlp butterhp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, kroomsize, iHFDamp, 0

aW         = (aW + 0.3 * (aWL + aWR) + 0.5 * adelW)

idltX = 1.3 * idlt
adelX delay aX, idltX

aXlp butterhp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, kroomsize, iHFDamp, 0

aX         = (aX + 0.3 * (aXL + aXR) + 0.5 * adelX)

idltY = 1.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, kroomsize, iHFDamp, 0

aY         = (aY + 0.3 * (aYL + aYR) + 0.5 * adelY)

idltZ = 1.9 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, kroomsize, iHFDamp, 0
aZ         = (aZ + 0.3 * (aZL + aZR) + 0.5 * adelZ)
 
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
aW, aX, aY, aZ soundin "ffsharpxneuronpulsefreq.aif", iskiptime
 
 aW = 0.5 * aW
 aX = 0.5 * aX
 aY = 0.5 * aY
 aZ = 0.5 * aZ
 
outq aW, aX, aY, aZ
endin 

instr 7

iskiptime = p4
aW, aX, aY, aZ soundin "ffsharpxneuronpulsefreq2.aif", iskiptime

 aW = 0.5 * aW
 aX = 0.5 * aX
 aY = 0.5 * aY
 aZ = 0.5 * aZ
 
outq aW, aX, aY, aZ
endin 

instr 8
iskiptime = p4
aW, aX, aY, aZ soundin "pulsexcmajor.aif", iskiptime

 aW = 0.4 * aW
 aX = 0.4 * aX
 aY = 0.4 * aY
 aZ = 0.4 * aZ
 
outq aW, aX, aY, aZ
endin 

instr 9
iskiptime = p4
aW, aX, aY, aZ soundin "violinchordambigrain.aif", iskiptime

 aW = 0.05 * aW
 aX = 0.05 * aX
 aY = 0.05 * aY
 aZ = 0.05 * aZ
 
outq aW, aX, aY, aZ
endin 

instr 10

iskiptime = p4
a1       soundin "neuronspeedhighshelf.aif", iskiptime

; envelope (as multipliers of the above gain)
; 0 < even p fields < 1, odd p fields in seconds

kazim     line p5, p3, p6     ; azimuth
kelev     line p7, p3, p8 ; elevation
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
kroomsize expseg 0.01, p3, 0.99 
iHFDamp    =  0.01
iSRate     =  48000
ifreq     =   1000
adelW delay aW, idlt

aWlp butterhp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, kroomsize, iHFDamp, 0

aW         = (0.8 * aW + 0.3 * (aWL + aWR) + 0.2 * adelW)

idltX = 1.3 * idlt
adelX delay aX, idltX

aXlp butterhp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, kroomsize, iHFDamp, 0

aX         = (0.8 * aX + 0.3 * (aXL + aXR) + 0.2 * adelX)

idltY = 1.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, kroomsize, iHFDamp, 0

aY         = (0.8 * aY + 0.3 * (aYL + aYR) + 0.2 * adelY)

idltZ = 1.9 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, kroomsize, iHFDamp, 0
aZ         = (0.8 * aZ + 0.3 * (aZL + aZR) + 0.2 * adelZ)
 
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

instr 11
iskiptime = p4
aW, aX, aY, aZ soundin "violinchordxneuronrotations1.aif", iskiptime

 aW = 0.5 * aW
 aX = 0.5 * aX
 aY = 0.5 * aY
 aZ = 0.5 * aZ
 
outq aW, aX, aY, aZ
endin

instr 12
iskiptime = p4
aW, aX, aY, aZ soundin "violinchordxneuronrotations1freq.aif", iskiptime

 aW = 0.5 * aW
 aX = 0.6 * aX
 aY = 0.6 * aY
 aZ = 0.6 * aZ
 
outq aW, aX, aY, aZ
endin

instr 13

iskiptime = p4
a1       soundin "neuronsinecloud1lowshelf2x.aif", iskiptime

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
kroomsize expseg 0.99, p3, 0.01 
iHFDamp    =  0.01
iSRate     =  48000
ifreq     =   5000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, kroomsize, iHFDamp, 0

aW         = (aW + 0.3 * (aWL + aWR) + 0.5 * adelW)

idltX = 1.3 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, kroomsize, iHFDamp, 0

aX         = (aX + 0.3 * (aXL + aXR) + 0.3 * adelX)

idltY = 1.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, kroomsize, iHFDamp, 0

aY         = (aY + 0.3 * (aYL + aYR) + 0.1 * adelY)

idltZ = 1.9 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, kroomsize, iHFDamp, 0
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

instr 14

iskiptime = p4
a1       soundin "neuronsinecloud1res2x.aif", iskiptime

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
kroomsize expseg 0.99, p3, 0.01 
iHFDamp    =  0.01
iSRate     =  48000
ifreq     =   5000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, kroomsize, iHFDamp, 0

aW         = (aW + 0.3 * (aWL + aWR) + 0.5 * adelW)

idltX = 1.3 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, kroomsize, iHFDamp, 0

aX         = (aX + 0.3 * (aXL + aXR) + 0.3 * adelX)

idltY = 1.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, kroomsize, iHFDamp, 0

aY         = (aY + 0.3 * (aYL + aYR) + 0.1 * adelY)

idltZ = 1.9 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, kroomsize, iHFDamp, 0
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

</CsInstruments>
<CsScore>
f1 0 1024 10 1
;f2 0 131072 1 "drum_hit.wav" 0 0 0
;f3 0 262144 1 "neuron_pulse_1f.wav" 0 0 0
f4 0 1024 19 .5 .5 270 .5

i3 0 72 0 360 10 -90 -10 10 20 1
i14 0 52 0 360 10 -90 -10 0.1 10 0.1
i4 13 102 0
i10 13 107 0 1 360 80 1 3 15 0.01
i14 32 52 0 360 1 -80 -1 3 15 0.5
i12 52 50 0
i11 72 48 0
i2 80 4 0 1 360 1 360 20 20 0.01
i5 84 33 0 1 360 20 20 5 15 0.2 
i2 110 4 0 360 1 360 1 20 20 0.01
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
