#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

/**
 * Press XButton2 + LButton + MButton
 * to refresh the current tab or close a window 🔄.
 */

#HotIf GetKeyState('XButton2', 'P')
LButton & MButton Up:: MouseCtrlR()
MouseCtrlR() {
    MouseWinActivate()
    Send('^r')
}
#HotIf
