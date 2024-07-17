#Include ..\mouse-functions.ahk

/**
 * Press XButton1 + MButton + RButton
 * to close a window ❎.
 */

#HotIf GetKeyState('XButton1', 'P')
MButton & RButton Up:: MouseWinClose()
MouseWinClose() {
    MouseWinActivate()
    if WinActive(K_CLASSES['ZOOM']['MEETING']) {
        Send('!q')
                ; Show 'End Meeting or Leave Meeting?' prompt in the middle of the screen
                ; instead of the corner of the window.
    } else if WinActive(K_CLASSES['ZOOM']['HOME']) {
        if Zoom_MeetingWinExist(true) {
            ControlSend('!q', , K_CLASSES['ZOOM']['MEETING'])
        } else {
            ProcessClose('Zoom.exe')
        }
    } else if WinActive('ahk_exe PowerToys.Settings.exe') {
        WinClose()
    } else {
        Send('!{F4}')
    }
}
#HotIf
