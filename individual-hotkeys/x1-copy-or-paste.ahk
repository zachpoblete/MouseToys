#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

#Include common-lib
#Include default-settings.ahk

; Press XButton1 + RButton
; to copy to the clipboard 📋.
; Press XButton1 + RButton + LButton
; to paste from the clipboard 📋.
#HotIf GetKeyState('XButton1', 'P')
RButton Up::           MouseCopy(thisHotkey)
RButton & LButton Up:: MousePaste()

MouseCopy(thisHotkey := "") {
    MouseSend('^c', thisHotkey)
}

MousePaste(thisHotkey := "") {
    MouseSend('^v', thisHotkey)
}
#HotIf
