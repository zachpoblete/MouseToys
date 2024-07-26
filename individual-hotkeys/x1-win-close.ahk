#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

/**
 * Press XButton1 + MButton + RButton
 * to close a window ❎.
 */

#HotIf GetKeyState('XButton1', 'P')
MButton & RButton Up:: MouseWinClose()

MouseWinClose() {
    MouseWinActivate()
    if WinActive('ahk_exe PowerToys.Settings.exe') {
        WinClose()
    } else {
        Send('!{F4}')
    }
}
#HotIf
