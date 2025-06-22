ActivateWinAtMouse(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd)
    WinActivate(mouseHwnd)
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
