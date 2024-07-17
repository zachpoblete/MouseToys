#Include ..\mouse-functions.ahk

/**
 * Press XButton2 + RButton
 * to close the current tab ❎.
 * Press XButton2 + RButton + LButton
 * to reopen the last closed tab ↪.
 */

#HotIf GetKeyState('XButton2', 'P')
RButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorKey)
    MouseWinActivate()
    Send('^w')
}

RButton & LButton Up:: {
    MouseWinActivate()
    if WinActive('ahk_exe Adobe Premiere Pro.exe') {
        Send('+3{F2}')
                ; Focus on timeline,
                ; and move playhead to cursor.
    } else {
        Send('^+t')
    }
}
#HotIf
