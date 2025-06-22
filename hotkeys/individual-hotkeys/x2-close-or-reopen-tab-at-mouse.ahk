#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

; Press XButton2 + RButton
; to close the current tab ❎.
; Press XButton2 + RButton + LButton
; to reopen the last closed tab ↪.
#HotIf GetKeyState('XButton2', 'P')
    RButton:: {
        ; Ignore the case where the mouse presses RButton back down after I release it;
        ; debounce:
        if A_PriorKey = "RButton" and (A_PriorHotkey and A_TimeSincePriorHotkey < 50) {
            return
        }

        if A_PriorKey != "RButton" {
            return
        }

        KeyWait("RButton")
        CloseTabAtMouse()
    }

    RButton & LButton Up:: ReopenClosedTabAtMouse()
#HotIf

CloseTabAtMouse() {
    SendAtMouse('^w')
}

ReopenClosedTabAtMouse() {
    SendAtMouse("^+t")
}
