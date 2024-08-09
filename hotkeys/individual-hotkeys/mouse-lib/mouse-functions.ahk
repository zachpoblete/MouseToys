; Optionally set thisHotkey to check if it is correct.
SendAtMouse(keys, thisHotkey := "") {
    if thisHotkey and not IsThisMouseHotkeyCorrect(thisHotkey) {
        return
    }
    ActivateWinAtMouse()
    Send('{Blind}' keys)
}

IsThisMouseHotkeyCorrect(thisHotkey) {
    thisKey := StrReplace(thisHotkey, " Up")
    thisKey := LTrim(thisKey, "*")
    thisKey := RTrim(thisKey, " ")
    return thisKey = A_PriorKey
}

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
