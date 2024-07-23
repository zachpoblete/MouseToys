#Include temporary-following-tooltip.ahk

MouseThisHkIsCorrect(thisHotkey) {
    thisKey := StrReplace(thisHotkey, " Up")
    thisKey := LTrim(thisKey, "*")
    thisKey := RTrim(thisKey, " ")

    return thisKey = A_PriorKey
}

; Optionally set thisHotkey to check if it is correct.
MouseSend(keys, thisHotkey := "") {
    if thisHotkey and not MouseThisHkIsCorrect(thisHotkey) {
        return
    }
    MouseWinActivate()
    Send('{Blind}' keys)
}

MouseWinActivate(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd)
    WinActivate(mouseHwnd)
    return WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText)
        ; mouseHwnd is there for the case
        ; when all the parameters are blank and there is no last found window.
}
