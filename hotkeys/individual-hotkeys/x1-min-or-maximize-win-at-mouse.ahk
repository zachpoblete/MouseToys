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
    MButton & WheelDown:: MinimizeWinAtMouse()
    MButton & WheelUp::   MaximizeWinAtMouse()
#HotIf

MinimizeWinAtMouse() {
    MinOrMaximizeWinAtMouse('Min')
}

MaximizeWinAtMouse() {
    MinOrMaximizeWinAtMouse('Max')
}

MinOrMaximizeWinAtMouse(minOrMax) {
    if MouseWinIsMoving {
        WinExist('A')
    } else {
        ActivateWinAtMouse()
    }
    Win%minOrMax%imize()
}
