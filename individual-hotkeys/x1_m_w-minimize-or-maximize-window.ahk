#Include lib
#Include mouse-globals.ahk
#Include mouse-functions.ahk
#Include fix-x1.ahk

/**
 * Press XButton1 + MButton + WheelDown
 * to minimize a window ↙️.
 * Press XButton1 + MButton + WheelUp
 * to maximize a window ↗.
 */

#HotIf GetKeyState('XButton1', 'P')
MButton & WheelDown:: MouseWinMinMax('Min')
MButton & WheelUp::   MouseWinMinMax('Max')

MouseWinMinMax(minOrMax) {
    if G_MouseIsMovingWin {
        WinExist('A')
    } else {
        MouseWinActivate()
    }
    Win%minOrMax%imize()
}
#HotIf
