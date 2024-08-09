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
    GoBackOrForwardAtMouse("back", thisHotkey)
}

GoForward1PageAtMouse(thisHotkey) {
    GoBackOrForwardAtMouse("forward")
}

GoBackOrForwardAtMouse(backOrForward, thisHotkey := "") {
    static STATES := Map(
        -1, {back: "X1", forward: "X2"}
    )

    if thisHotkey and not IsThisMouseHotkeyCorrect(thisHotkey) {
        return
    }

    ActivateWinAtMouse()
    Click(STATES[-1].%backOrForward%)
}
