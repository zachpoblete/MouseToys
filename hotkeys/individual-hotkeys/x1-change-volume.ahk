#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

; Press XButton1 + RButton + WheelUp
; to increase the volume 🔊.
; Press XButton1 + RButton + WheelDown
; to decrease the volume 🔈.
#HotIf GetKeyState('XButton1', 'P')
    RButton & WheelUp::   Send("{Volume_Up}")
    RButton & WheelDown:: Send("{Volume_Down}")
#HotIf
