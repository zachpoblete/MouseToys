#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

#HotIf GetKeyState('XButton1', 'P')
    MButton & RButton Up:: {
        Debounce("RButton", 110)
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
