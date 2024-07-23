#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

/**
 * Press XButton2 + RButton + WheelDown
 * to cycle through tabs in recently used order ⬇️.
 * Press XButton2 + RButton + WheelUp
 * to cycle through tabs in reverse used order ⬆️.
 */

/**
 * Each condition has its own #HotIf
 * because if they were all under the same hotkey variant,
 * then the KeyWait under "#HotIf GetKeyState('XButton2', 'P')"
 * would prevent any further inputs from going through.
 */

#HotIf GetKeyState('XButton2', 'P') and MouseWinActivate('ahk_exe msedge.exe')
/**
 * Search tabs.
 */
RButton & WheelDown:: MouseSearchTabs()
RButton & WheelUp::   Send('{Escape}')

#HotIf GetKeyState('XButton2', 'P') and WinActive('ahk_exe AcroRd32.exe')
RButton & WheelDown:: Send('^{PgDn}')
        ; Jump one page down.
RButton & WheelUp::   Send('^{PgUp}')
        ; Jump one page up.

#HotIf GetKeyState('XButton2', 'P') and GetKeyState('Ctrl')
RButton & WheelDown:: Send('{Tab}')
RButton & WheelUp::   Send('+{Tab}')

#HotIf GetKeyState('XButton2', 'P')
RButton & WheelDown:: MouseViewFirstTabInUsedOrder('{Tab}')
RButton & WheelUp::   MouseViewFirstTabInUsedOrder('+{Tab}')
#HotIf

MouseSearchTabs() {
    if GetKeyState('Ctrl') {
        Send('{Ctrl Up}')
    }

    Send('^+a')
}

MouseViewFirstTabInUsedOrder(tab) {
    Send('{Ctrl Down}' tab)
    KeyWait('RButton')
    Send('{Ctrl Up}')
}
