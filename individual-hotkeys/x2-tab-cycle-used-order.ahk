#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

; Press XButton2 + RButton + WheelDown
; to cycle through tabs in recently used order ⬇️.
; Press XButton2 + RButton + WheelUp
; to cycle through tabs in reverse used order ⬆️.
#HotIf GetKeyState('XButton2', 'P')

; Set the max threads per hotkey to 2 because these hotkeys use KeyWait to wait
; for the release of the modifier, but KeyWait prevents the hotkeys from firing
; again if the max threads per hotkey is the default 1.
#MaxThreadsPerHotkey 2
RButton & WheelDown:: MouseTabCycleRecentlyUsed()
RButton & WheelUp::   MouseTabCycleReverseUsed()
#MaxThreadsPerHotkey 1
#HotIf

MouseTabCycleRecentlyUsed() {
    MouseTabCycleUsedOrder("RButton", "{Tab}")
}

MouseTabCycleReverseUsed() {
    MouseTabCycleUsedOrder("RButton", "+{Tab}")
}

MouseTabCycleUsedOrder(modifier, tab) {
    static _isCycling := false

    ; Turn on Critical so that even when scrolling fast, a new session is properly
    ; started.
    Critical("On")

    ; Activate the window under the mouse only if we're not currently in a cycling
    ; session. If I did want to start a new cycling session when the mouse is over a
    ; new window, it seems the only way to do that would be to logically release the
    ; modifier (to notify the KeyWait later to stop waiting), but that probably
    ; isn't reliable. It would also make this function unnecessarily complex; the
    ; condition below is not meant to be a feature but is just supposed to fix a
    ; bug.
    if not _isCycling {
        MouseWinActivate()
    }

    if WinActive('ahk_exe msedge.exe') {
        if _isCycling {
            return
        }

        _isCycling := true

        ; Search tabs.
        Send('^+a')

        ; Turn off Critical right before waiting for the hotkey to be released because
        ; that is when it is safest to do so.
        Critical("Off")
        KeyWait(modifier)
        _isCycling := false
        return
    }

    if _isCycling {
        ; Send ^{Tab} instead of just {Tab} so that there is no chance of sending a lone
        ; tab.
        Send("^" . tab)
        return
    }

    _isCycling := true
    Send('{Ctrl Down}' . tab)

    ; Turn off Critical right before waiting for the hotkey to be released because
    ; that is when it is safest to do so.
    Critical("Off")
    KeyWait(modifier)
    Send('{Ctrl Up}')
    _isCycling := false
}
