#Include ahk-utils
#Include default-settings.ahk
#Include can-redo-with-ctrl-y.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

; Press XButton1 + RButton + WheelDown
; to send the undo command ↩️.
; Press XButton1 + RButton + WheelUp
; to send the redo command ↪.
#HotIf GetKeyState('XButton1', 'P')
    RButton & WheelDown:: MouseUndo()
    RButton & WheelUp::   MouseRedo()
#HotIf

MouseUndo(thisHotkey := "") {
    MouseSend('^z', thisHotkey)
}

MouseRedo() {
    MouseWinActivate()

    if CanRedoWithCtrlY() {
        Send('^y')
    } else {
        Send('^+z')
    }
}
