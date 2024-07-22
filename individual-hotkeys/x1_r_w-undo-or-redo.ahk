#Include lib
#Include mouse-functions.ahk
#Include can-redo-with-ctrl-y.ahk
#Include fix-x1.ahk

/**
 * Press XButton1 + RButton + WheelDown
 * to send the undo command ↩️ (^z).
 * Press XButton1 + RButton + WheelUp
 * to send the redo command ↪.
 */

#HotIf GetKeyState('XButton1', 'P')
RButton & WheelDown:: MouseSend('^z')

RButton & WheelUp:: {
    MouseWinActivate()

    if CanRedoWithCtrlY() {
        Send('^y')
    } else {
        Send ('^+z')
    }
}
#HotIf
