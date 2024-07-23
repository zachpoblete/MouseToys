#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

/**
 * Press XButton2 + LButton
 * to go back a page ⬅️.
 * Press XButton2 + LButton + RButton
 * to go forward a page ➡️.
 */

#HotIf GetKeyState('XButton2', 'P')
LButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey)
    MouseGoBackOrForward('[', 'X1')
}

LButton & RButton Up:: {
    MouseGoBackOrForward(']', 'X2')
}

MouseGoBackOrForward(states*) {
    MouseWinActivate()
    if WinActive('ahk_exe Notion.exe') {
        Send('^' states[1])
    } else {
        Click(states[-1])
    }
}
#HotIf
