#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

; Press XButton2 + LButton + MButton
; to refresh the current page 🔄.
#HotIf GetKeyState('XButton2', 'P')
LButton & MButton Up:: MousePageRefresh()

MousePageRefresh() {
    MouseSend('^r')
}
#HotIf
