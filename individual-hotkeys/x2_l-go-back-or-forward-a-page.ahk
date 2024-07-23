#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

/**
 * Press XButton2 + LButton
 * to go back a page ⬅️.
 * Press XButton2 + LButton + RButton
 * to go forward a page ➡️.
 */

#HotIf GetKeyState('XButton2', 'P')
LButton Up::           MouseGoBackOrForward(thisHotkey, 'X1')
LButton & RButton Up:: MouseGoBackOrForward("", 'X2')

MouseGoBackOrForward(thisHotkey := "", states*) {
    if thisHotkey and not MouseThisHkIsCorrect(thisHotkey) {
        return
    }
    MouseWinActivate()
    Click(states[-1])
}
#HotIf
