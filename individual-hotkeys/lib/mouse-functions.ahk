#Include temporary-following-tooltip.ahk

MouseControlFocus(control := '', winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd, &mouseControlHwnd, 2)
    WinActivate(mouseHwnd)
    if not WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText) {
        return
    }

    ControlFocus(mouseControlHwnd)
    if control = '' {
        return mouseControlHwnd
    }

    try {
        controlHwnd := ControlGetHwnd(control)
    } catch {
        return
    }

    if controlHwnd != mouseControlHwnd {
        return
    }

    return mouseControlHwnd
}

; TODO: Rework to something like ThisHkIsCorrect().
; Using exit like this is bad practice.
; Change everywhere you do this.
MouseExitIfCantBeThisHk(thisHotkey) {
    thisKey := StrReplace(thisHotkey, " Up")
    thisKey := LTrim(thisKey, "*")
    thisKey := RTrim(thisKey, " ")

    if thisKey != A_PriorKey {
        exit
    }
}

; Add boolean param, shouldCheckThisHk
MouseSend(keys) {
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
