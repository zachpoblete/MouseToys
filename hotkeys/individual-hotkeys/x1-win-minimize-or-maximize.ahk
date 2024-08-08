#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-globals.ahk
#Include mouse-functions.ahk
#Include fix-x1.ahk

; Press XButton1 + MButton + WheelDown
; to minimize a window ↙️.
; Press XButton1 + MButton + WheelUp
; to maximize a window ↗.
#HotIf GetKeyState('XButton1', 'P')
MButton & WheelDown:: MouseWinMinimize()
MButton & WheelUp::   MouseWinMaximize()
#HotIf

MouseWinMinimize() {
    MouseWinMinimizeOrMaximize('Min')
}

MouseWinMaximize() {
    MouseWinMinimizeOrMaximize('Max')
}

MouseWinMinimizeOrMaximize(minOrMax) {
    if MouseWinIsMoving {
        WinExist('A')
    } else {
        MouseWinActivate()
    }
    Win%minOrMax%imize()
}
