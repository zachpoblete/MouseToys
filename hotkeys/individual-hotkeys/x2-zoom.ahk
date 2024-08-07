#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

; Press XButton2 + LButton + WheelUp
; to zoom in 🔍.
; Press XButton2 + LButton + WheelDown
; to zoom out 🔍.
#HotIf GetKeyState('XButton2', 'P')
LButton & WheelUp::   MouseZoomIn()
LButton & WheelDown:: MouseZoomOut()

MouseZoomIn(thisHotkey := "") {
    MouseSend("^=", thisHotkey)
}

MouseZoomOut(thisHotkey := "") {
    MouseSend("^-", thisHotkey)
}
#HotIf
