#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

; Press XButton1 + MButton + RButton
; to close a window ❎.
#HotIf GetKeyState('XButton1', 'P')
    MButton & RButton Up:: {
        Debounce("RButton")
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
