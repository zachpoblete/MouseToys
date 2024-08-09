#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk

; Press XButton1 + WheelDown
; to cycle through windows in recently used order ⬇️.
; Press XButton1 + WheelUp
; to cycle through windows in reverse used order ⬆️.
XButton1 & WheelDown:: AltTab
XButton1 & WheelUp::   ShiftAltTab

; Press XButton1 + MButton
; to close a window while cycling through windows in recently used order ❎.
!MButton Up:: CloseCyclingWinAtMouse()
