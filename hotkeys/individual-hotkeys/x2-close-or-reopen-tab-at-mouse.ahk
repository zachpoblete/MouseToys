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
        if A_PriorKey = "RButton" and A_TimeSincePriorHotkey < 50 {
            return
        }

        ; This hotkey will always be triggered when RButton is released after performing the X2+R+L shortcut.
        ; Ignore this case:
        if A_PriorKey = "LButton" {
            return
        }

        if GetKeyState("LButton", "P") {
            return
        }

        KeyWait("RButton")
        CloseTabAtMouse(thisHotkey)
    }

    RButton & LButton Up:: ReopenClosedTabAtMouse()
#HotIf

CloseTabAtMouse(thisHotkey := "") {
    ActivateWinAtMouse()
    Send('{Blind}^w')
}

ReopenClosedTabAtMouse(thisHotkey := "") {
    SendAtMouse("^+t", thisHotkey)
}
