#Include lib
#Include mouse-functions.ahk
#Include can-redo-with-ctrl-y.ahk
#Include fix-x1.ahk

#Include common-lib
#Include default-settings.ahk

; Press XButton1 + RButton + WheelDown
; to send the undo command ↩️.
; Press XButton1 + RButton + WheelUp
; to send the redo command ↪.
#HotIf GetKeyState('XButton1', 'P')
RButton & WheelDown:: MouseUndo()
RButton & WheelUp::   MouseRedo()

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
#HotIf
