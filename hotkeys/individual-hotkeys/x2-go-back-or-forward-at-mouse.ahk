#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2-shortcuts.ahk

; Press XButton2 + LButton
; to go back a page ⬅️.
; Press XButton2 + LButton + RButton
; to go forward a page ➡️.
#HotIf GetKeyState('XButton2', 'P')
    LButton Up:: {
        if A_PriorKey != "LButton" {
            return
        }
        GoBack1PageAtMouse()
    }
    LButton & RButton Up:: {
        Debounce("RButton")
        GoForward1PageAtMouse()
    }

#HotIf

GoBack1PageAtMouse() {
    GoBackOrForwardAtMouse(true)
}

GoForward1PageAtMouse() {
    GoBackOrForwardAtMouse(false)
}

GoBackOrForwardAtMouse(shouldGoBack) {
    ActivateWinAtMouse()
    Click(shouldGoBack ? "X1" : "X2")
}
