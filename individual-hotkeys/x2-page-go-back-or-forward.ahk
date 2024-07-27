#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

; Press XButton2 + LButton
; to go back a page ⬅️.
; Press XButton2 + LButton + RButton
; to go forward a page ➡️.
#HotIf GetKeyState('XButton2', 'P')
LButton Up::           MousePageGoBackOrForward(thisHotkey, 'X1')
LButton & RButton Up:: MousePageGoBackOrForward("", 'X2')

MousePageGoBackOrForward(thisHotkey := "", states*) {
    if thisHotkey and not MouseIsThisHotkeyCorrect(thisHotkey) {
        return
    }
    MouseWinActivate()
    Click(states[-1])
}
#HotIf
