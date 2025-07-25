#Include user-settings-path.ahk

#Include ../ahk-utils
#Include script-info.ahk

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

; For why some hotkeys use Debounce(), see
; https://github.com/zachpoblete/MouseToys/wiki/Why-some-hotkeys-use-Debounce()
; Note that we're assuming that the last key "pressed" was the release of the
; button. We could make the function more general, but we don't need to; don't
; generalize a function for cases you haven't experienced yet.
Debounce(button, minimumTimeToReleaseButtonMs) {
    debouncesIsOn := IniRead(UserSettingsPath, '', 'DebounceIsOn')
    if not debouncesIsOn {
        return
    }

    try {
        timeToPressButtonMs := GetTimeToReleaseButtonMs(button)
    } catch TargetError as e {
        if e.message != "matchedButton" {
            throw e
        }
        return
    }
    if timeToPressButtonMs <= minimumTimeToReleaseButtonMs {
        exit
    }
}

; Note that we're assuming that the last key "pressed" was the release of the
; button. We could make the function more general, but we don't need to; don't
; generalize a function for cases you haven't experienced yet.
GetTimeToReleaseButtonMs(button) {
    keyHistoryText := ScriptInfo("KeyHistory")

    ; Let n be the line number of the last line.
    ; Line n is text like "Press [F5] to refresh." that isn't part of the KeyHistory table.
    ; Line n-1 is the time to release the button.
    ; Line n-2 is the time to press the button. This is why we get last3LinesPos.
    last3LinesPos := InStr(keyHistoryText, "`n", , , -2)
    ; To get the actual contents of the last 3 lines, the starting position is
    ; last3LinesPos + 1 to not include the new line (`n).
    last3Lines := SubStr(keyHistoryText, last3LinesPos + 1)

    RegExMatch(last3Lines, "^.+[du]\s+(\S+)\s+(\S+)", &match)
    timeToReleaseButtonMs := match[1] * 1000
    matchedButton := match[2]
    if matchedButton != button {
        throw TargetError("matchedButton", , "``button`` was " button " but ``matchedButton`` was " matchedButton)
    }
    return timeToReleaseButtonMs
}

SendAtMouse(keys) {
    ActivateWinAtMouse()
    Send('{Blind}' keys)
}
