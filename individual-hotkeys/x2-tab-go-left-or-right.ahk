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
    MouseTabGoToAdjacent('!{Up}',   '{PgUp}', '^+{Tab}', '{Left}',  '^{PgUp}')
}

MouseTabGoRight() {
    MouseTabGoToAdjacent('!{Down}', '{PgDn}', '^{Tab}',  '{Right}', '^{PgDn}')
}

MouseTabGoToAdjacent(states*) {
    WinExist('A')

    winProcessName := WinGetProcessName()
    switch winProcessName {
        case "Discord.exe", "Messenger.exe":
            Send(states[1])
            return
        case "POWERPNT.EXE":
            Send(states[2])
            return
        case "AcroRd32.exe", "Photoshop.exe", "WindowsTerminal.exe":
            Send(states[3])
            return
    }

    winClass := WinGetClass()
    switch winClass {
        case "CabinetWClass":
            Send(states[3])
            return
    }

    ; (In the native Photos app, you have to click one of the arrows that will go to
    ; an adjacent photo before this hotkey works.)
    if (winProcessName = 'Photos.exe') and (winClass = 'WinUIDesktopWin32WindowClass') {
        Send(states[4])
        return
    }

    Send(states[-1])
}
#HotIf
