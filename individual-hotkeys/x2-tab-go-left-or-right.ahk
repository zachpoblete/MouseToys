#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

; Press XButton2 + WheelDown
; to go to the left tab ⬅️.
; Press XButton2 + WheelUp
; to go to the right tab ➡️.
#HotIf GetKeyState('XButton2', 'P')
WheelUp::   MouseTabGoLeft()
WheelDown:: MouseTabGoRight()

MouseTabGoLeft() {
    MouseTabGoToAdjacent('{Up}',   '{PgUp}', '+{Tab}', '{Left}',  '{PgUp}')
}

MouseTabGoRight() {
    MouseTabGoToAdjacent('{Down}', '{PgDn}', '{Tab}',  '{Right}', '{PgDn}')
}

MouseTabGoToAdjacent(states*) {
    MouseWinActivate()

    WinExist('A')
    activeWin := {}
    activeWin.class := WinGetClass()
    activeWin.processName := WinGetProcessName()

    if activeWin.processName  ~= 'i)\A(Discord.exe|Messenger.exe)\z' {
        Send('!' states[1])
    } else if activeWin.processName ~= 'i)\A(POWERPNT.EXE)\z' {
        Send(states[2])
    } else if activeWin.class ~= 'i)\A(CabinetWClass)\z'
        or activeWin.processName ~= 'i)\A(AcroRd32.exe|Photoshop.exe|WindowsTerminal.exe)' {
        Send('^' states[3])
    } else if (activeWin.class = 'WinUIDesktopWin32WindowClass') and (activeWin.processName = 'Photos.exe') {
        Send(states[4])
    } else {
        Send('^' states[-1])
    }
}
#HotIf
