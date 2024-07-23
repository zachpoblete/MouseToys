#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

/**
 * Press XButton2 + LButton + MButton
 * to reload the current page or window 🔄.
 */

#HotIf GetKeyState('XButton2', 'P')
LButton & MButton Up:: MouseReload()

MouseReload() {
    MouseSend('^r')
}
#HotIf
