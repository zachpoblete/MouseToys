#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

/**
 * Press XButton1 + RButton
 * to send the Enter key ⬇️.
 * Press XButton1 + RButton + LButton
 * to send the Tab key ➡️.
 */

#HotIf GetKeyState('XButton1', 'P')
*RButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorHotkey)
    MouseSend('{Enter}')
}

RButton & LButton Up:: {
    MouseSend('{Tab}')
}
#HotIf
