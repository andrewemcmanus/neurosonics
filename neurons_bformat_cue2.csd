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
	1, 11.775, .2, 0.17, 50.0, 0.5, 0.7, 2, /* floor */ \
	1, 11.231, .2, 0.27, 800.0, 0.6, 0.7, 2, /* front */ \
	1, 31.329, .2, 0.37, 200.0, 0.6, 0.7, 2, /* back  */ \
	1, 41.567, .2, 0.47, 500.0, 0.6, 0.7, 2, /* right */ \
	1, 11.111, .2, 0.47, 900.0, 0.6, 0.7, 2  /* left  */ 


instr 1

iskiptime = p4
aW, aX, aY, aZ soundin "lowxhighpassamp.aif", iskiptime
 aW = 0.6 * aW
 aX = 0.6 * aX
 aY = 0.6 * aY
 aZ = 0.6 * aZ
 
outq aW, aX, aY, aZ

endin

instr 2

iskiptime = p4
aW, aX, aY, aZ soundin "ffsharpxneuronpulsefreq2.aif", iskiptime
 aW = 1.2 * aW
 aX = 1.2 * aX
 aY = 1.2 * aY
 aZ = 1.2 * aZ
outq aW, aX, aY, aZ

endin

instr 3

iskiptime = p4
a1 soundin "neuronsinecloud2.wav", iskiptime

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
kroomsize line 0.01, p3, 0.99 
iHFDamp    =  0
iSRate     =  48000
ifreq     =   10000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, kroomsize, iHFDamp, 0

aW         = (0.1 * aW + 0.5 * (aWL + aWR) + 0.3 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, kroomsize, iHFDamp, 0

aX         = (0.1 * aX + 0.5 * (aXL + aXR) + 0.3 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, kroomsize, iHFDamp, 0

aY         = (0.1 * aY + 0.5 * (aYL + aYR) + 0.3 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterlp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, kroomsize, iHFDamp, 0
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

instr 4

iskiptime = p4
aW, aX, aY, aZ soundin "mahlerglissgflat.aif", iskiptime
 aW =  0.2 * aW
 aX =  0.2 * aX
 aY =  0.2 * aY
 aZ =  0.2 * aZ
 
outq aW, aX, aY, aZ
endin

instr 5

iskiptime = p4
aW, aX, aY, aZ soundin "mahlerstaccgflat.aif", iskiptime
 aW =  0.7 * aW
 aX =  0.7 * aX
 aY =  0.7 * aY
 aZ =  0.7 * aZ
 
outq aW, aX, aY, aZ
endin

instr 6

iskiptime = p4
aW, aX, aY, aZ soundin "mahlerleg32ndgflat.aif", iskiptime
 aW =  0.7 * aW
 aX =  0.7 * aX
 aY =  0.7 * aY
 aZ =  0.7 * aZ
 
outq aW, aX, aY, aZ
endin

instr 7

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
iroomsize = 0.1 
iHFDamp    =  0.3
iSRate     =  48000
ifreq     =   500
adelW delay aW, idlt

aWlp butterhp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (0.2 * aW + 0.9 * (aWL + aWR) + 0.4 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterhp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (0.2 * aX + 0.9 * (aXL + aXR) + 0.4 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterhp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (0.2 * aY + 0.9 * (aYL + aYR) + 0.4 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterhp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (0.2 * aZ + 0.9 * (aZL + aZR) + 0.4 * adelZ)
 
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
a1       soundin "identitycmajor1_5xlowpass.aif", iskiptime

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
iHFDamp    =  0.3
iSRate     =  48000
ifreq     =   1000
adelW delay aW, idlt

aWlp butterlp aW, ifreq
aWL, aWR freeverb aWlp, aWlp, iroomsize, iHFDamp, 0

aW         = (0.5 * aW + 0.3 * (aWL + aWR) + 0.7 * adelW)

idltX = 2.4 * idlt
adelX delay aX, idltX

aXlp butterlp aX, ifreq
aXL, aXR freeverb aXlp, aXlp, iroomsize, iHFDamp, 0

aX         = (0.5 * aX + 0.3 * (aXL + aXR) + 0.7 * adelX)

idltY = 3.9 * idlt
adelY delay aY, idltY

aYlp butterlp aY, ifreq
aYL, aYR freeverb aYlp, aYlp, iroomsize, iHFDamp, 0

aY         = (0.5 * aY + 0.3 * (aYL + aYR) + 0.7 * adelY)

idltZ = 2.7 * idlt
adelZ delay aZ, idltZ
aZlp butterhp aZ, ifreq
aZL, aZR freeverb aZlp, aZlp, iroomsize, iHFDamp, 0
aZ         = (0.5 * aZ + 0.3 * (aZL + aZR) + 0.7 * adelZ)
 
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

instr 10
iskiptime = p4
aW, aX, aY, aZ soundin "identitychordspeedallpassspin.aif", iskiptime
  aW = 0.7 * aW
 aX = 0.7 * aX
 aY = 0.7 * aY
 aZ = 0.7 * aZ
outq aW, aX, aY, aZ 
endin

instr 11

iskiptime = p4
a1       soundin "neuronspeedallpass.aif", iskiptime

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

</CsInstruments>
<CsScore>
f1 0 1024 10 1
f4 0 1024 19 .5 .5 270 .5

i1 0 40 0
i4 0 55 0
i3 0 35 0 1 360 -20 -40 1 5 0.1
i11 0 24 0 360 1 40 20 10 2 1.7
i2 20 4 0
i2 22 4 0
i2 24 4 0
i5 25 29 0
i2 25.5 4 0
i2 27.7 4 0
i2 28 4 0
i2 30 4 0
i8 30.5 3 0 1 360 -90 -1 8 0.1 0.2
i2 32 4 0
;i8 32.3 3 0 360 1 90 1 8 0.1 0.25
i7 33 3 0 1 360 -90 -1 5 0.05 0.1
i8 34.1 3 0 360 1 1 90 1 10 0.5
i7 35 3 0 360 1 90 1 5 0.05 0.21
i6 35 20 0 
i8 35.9 3 0 1 360 1 90 8 0.1 0.1
i2 36 4 0 
i8 37.7 3 0 1 360 -90 -1 1 10 0.6
i7 37 3 0 1 360 -1 -90 5 0.05 0.3
i7 39 3 0 360 1 1 90 5 0.05 0.4
i8 39.5 3 0 360 1 90 1 8 0.1 0.7 
i2 40 4 0
i10 40 17 0
i7 41 3 0 1 360 -90 -1 5 0.05 0.5
i8 41.3 3 0 360 1 90 1 8 0.1 0.1
i2 42 4 0
i7 43 3 0 360 1 90 1 0.05 8 0.4
i8 44.9 3 0 1 360 -90 -1 1 10 0.7 
i7 46 3 0 1 360 -1 -90 0.05 8 0.3
i8 46.7 3 0 360 1 90 1 8 0.1 0.1
i8 48.5 3 0 1 360 1 90 8 0.1 0.9
i7 49 3 0 360 1 1 90 0.05 8 0.2
i7 52 3 0 360 1 1 90 0.05 8 0.1


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
 <bsbObject type="BSBVSlider" version="2">
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
