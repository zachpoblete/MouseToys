#Include ..\mouse-functions.ahk

/**
 * Press XButton2 + WheelDown
 * to switch to the left tab ⬅️.
 * Press XButton2 + WheelUp
 * to switch to the right tab ➡️.
 */

#HotIf GetKeyState('XButton2', 'P')
WheelDown:: MouseAdjacentTabSwitch('{Down}', '{PgDn}', '{Tab}', '{Right}', '{PgDn}')
WheelUp::   MouseAdjacentTabSwitch('{Up}',   '{PgUp}', '+{Tab}', '{Left}', '{PgUp}')

MouseAdjacentTabSwitch(states*) {
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
        or activeWin.processName ~= 'i)\A(AcroRd32.exe|Notion.exe|Photoshop.exe|WindowsTerminal.exe)' {
        Send('^' states[3])
    } else if activeWin.class = 'WinUIDesktopWin32WindowClass' and activeWin.processName = 'Photos.exe' {
        Send(states[4])
    } else {
        Send('^' states[-1])
    }
}
#HotIf
