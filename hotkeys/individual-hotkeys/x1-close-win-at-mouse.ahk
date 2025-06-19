#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

; Press XButton1 + MButton + RButton
; to close a window ❎.
#HotIf GetKeyState('XButton1', 'P')
    MButton & RButton:: {
        if A_PriorKey = "RButton" and (A_PriorHotkey and A_TimeSincePriorHotkey < 50) {
            return
        }
        KeyWait("RButton")
        CloseWinAtMouse()
    }
#HotIf

CloseWinAtMouse() {
    ActivateWinAtMouse()
    if WinActive('ahk_exe PowerToys.Settings.exe') {
        WinClose()
    } else {
        Send('!{F4}')
    }
}
