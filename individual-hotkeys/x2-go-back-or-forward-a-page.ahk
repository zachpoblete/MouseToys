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
LButton Up::           MouseGoBackOrForwardAPage(thisHotkey, 'X1')
LButton & RButton Up:: MouseGoBackOrForwardAPage("", 'X2')

MouseGoBackOrForwardAPage(thisHotkey := "", states*) {
    if thisHotkey and not MouseThisHkIsCorrect(thisHotkey) {
        return
    }
    MouseActivateWin()
    Click(states[-1])
}
#HotIf
