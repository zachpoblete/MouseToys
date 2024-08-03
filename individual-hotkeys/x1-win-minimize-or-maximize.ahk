#Include lib
#Include mouse-globals.ahk
#Include mouse-functions.ahk
#Include fix-x1.ahk

#Include common-lib
#Include default-settings.ahk

; Press XButton1 + MButton + WheelDown
; to minimize a window ↙️.
; Press XButton1 + MButton + WheelUp
; to maximize a window ↗.
#HotIf GetKeyState('XButton1', 'P')
MButton & WheelDown:: MouseWinMinimize()
MButton & WheelUp::   MouseWinMaximize()

MouseWinMinimize() {
    MouseWinMinimizeOrMaximize('Min')
}

MouseWinMaximize() {
    MouseWinMinimizeOrMaximize('Max')
}
#HotIf

MouseWinMinimizeOrMaximize(minOrMax) {
    if MouseWinIsMoving {
        WinExist('A')
    } else {
        MouseWinActivate()
    }
    Win%minOrMax%imize()
}
