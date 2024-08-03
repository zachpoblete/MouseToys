#Include lib

#Include common-lib
#Include default-settings.ahk

; Press XButton1 + WheelDown
; to cycle through windows in recently used order ⬇️.
; Press XButton1 + WheelUp
; to cycle through windows in reverse used order ⬆️.
XButton1 & WheelDown:: AltTab
XButton1 & WheelUp::   ShiftAltTab
