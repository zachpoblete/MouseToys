#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

/**
 * Press XButton2 + RButton
 * to close the current tab ❎.
 * Press XButton2 + RButton + LButton
 * to reopen the last closed tab ↪.
 */

#HotIf GetKeyState('XButton2', 'P')
RButton Up::           MouseCloseTab(thisHotkey)
RButton & LButton Up:: MouseReopenLastClosedTab()

MouseCloseTab(thisHotkey) {
    MouseExitIfCantBeThisHk(thisHotkey)
    MouseWinActivate()
    Send('^w')
}

MouseReopenLastClosedTab() {
    MouseWinActivate()
    Send('^+t')
}
#HotIf
