; Optionally set thisHotkey to check if it is correct.
MouseSend(keys, thisHotkey := "") {
    if thisHotkey and not MouseIsThisHotkeyCorrect(thisHotkey) {
        return
    }
    MouseWinActivate()
    Send('{Blind}' keys)
}

MouseIsThisHotkeyCorrect(thisHotkey) {
    thisKey := StrReplace(thisHotkey, " Up")
    thisKey := LTrim(thisKey, "*")
    thisKey := RTrim(thisKey, " ")
    return thisKey = A_PriorKey
}

MouseWinActivate(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd)
    WinActivate(mouseHwnd)
    activeMouseWin := WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText)
        ; mouseHwnd is there for the case
        ; when all the parameters are blank and there is no last found window.
    if not activeMouseWin {
        throw TargetError("Did not activate the window under the mouse.")
    }
}

MouseWinCloseInAltTabMenu() {
    wasAWinClosed := false
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('Middle')
        wasAWinClosed := true
    }
    return wasAWinClosed
}
