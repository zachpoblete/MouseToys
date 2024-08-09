#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

; Press XButton1 + RButton
; to copy to the clipboard 📋.
; Press XButton1 + RButton + LButton
; to paste from the clipboard 📋.
#HotIf GetKeyState('XButton1', 'P')
    RButton Up::           CopyAtMouse(thisHotkey)
    RButton & LButton Up:: PasteAtMouse()
#HotIf

CopyAtMouse(thisHotkey := "") {
    SendAtMouse('^c', thisHotkey)
}

PasteAtMouse(thisHotkey := "") {
    SendAtMouse('^v', thisHotkey)
}
