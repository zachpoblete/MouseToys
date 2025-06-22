ActivateWinAtMouse(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd)
    WinActivate(mouseHwnd)
    ; See if a short sleep increases the chance that WinActive() finds a window.
    ; AHK's default A_WinDelay is 100 while it's default A_ControlDelay is 20.
    ; 100 feels slow while 20 feels fine.
    ; Let's try 20.
    Sleep(20)

    activeMouseWin := WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText)
        ; mouseHwnd is there for the case
        ; when all the parameters are blank and there is no last found window.
    if not activeMouseWin {
        throw TargetError("Did not activate the window under the mouse.")
    }
}

CloseCyclingWinAtMouse() {
    wasAWinClosed := false
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('Middle')
        wasAWinClosed := true
    }
    return wasAWinClosed
}

SendAtMouse(keys) {
    ActivateWinAtMouse()
    Send('{Blind}' keys)
}
