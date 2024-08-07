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
LButton Up::           MousePageGoBack(thisHotkey)
LButton & RButton Up:: MousePageGoForward(thisHotkey)

MousePageGoBack(thisHotkey) {
    MousePageGoBackOrForward("back", thisHotkey)
}

MousePageGoForward(thisHotkey) {
    MousePageGoBackOrForward("forward")
}
#HotIf

MousePageGoBackOrForward(backOrForward, thisHotkey := "") {
    static STATES := Map(
        -1, {back: "X1", forward: "X2"}
    )

    if thisHotkey and not MouseIsThisHotkeyCorrect(thisHotkey) {
        return
    }

    MouseWinActivate()
    Click(STATES[-1].%backOrForward%)
}
