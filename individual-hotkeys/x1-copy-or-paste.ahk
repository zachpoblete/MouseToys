#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

/**
 * Press XButton1 + RButton
 * to copy something to the clipboard 📋.
 * Press XButton1 + RButton + LButton
 * to paste something from the clipboard 📋.
 */

#HotIf GetKeyState('XButton1', 'P')
*RButton Up::          MouseCopy(thisHotkey)
RButton & LButton Up:: MousePaste()

MouseCopy(thisHotkey) {
    MouseSend('^c', thisHotkey)
}

MousePaste() {
    MouseSend('^v')
}
#HotIf
