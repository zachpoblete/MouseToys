#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

; Press XButton2 + LButton
; to go back a page ⬅️.
; Press XButton2 + LButton + RButton
; to go forward a page ➡️.
#HotIf GetKeyState('XButton2', 'P')
    LButton Up::           GoBack1PageAtMouse(thisHotkey)
    LButton & RButton Up:: GoForward1PageAtMouse(thisHotkey)
#HotIf

GoBack1PageAtMouse(thisHotkey) {
    GoBackOrForwardAtMouse(true, thisHotkey)
}

GoForward1PageAtMouse(thisHotkey) {
    GoBackOrForwardAtMouse(false)
}

GoBackOrForwardAtMouse(shouldGoBack, thisHotkey := "") {
    if thisHotkey and not IsThisMouseHotkeyCorrect(thisHotkey) {
        return
    }

    ActivateWinAtMouse()
    Click(shouldGoBack ? "X1" : "X2")
}
