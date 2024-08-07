#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

#Include ahk-utils
#Include default-settings.ahk

; Press XButton2 + WheelDown
; to go to the left tab ⬅️.
; Press XButton2 + WheelUp
; to go to the right tab ➡️.
#HotIf GetKeyState('XButton2', 'P')
WheelUp::   MouseTabGoLeft()
WheelDown:: MouseTabGoRight()

MouseTabGoLeft() {
    MouseTabGoToAdjacent("left")
}

MouseTabGoRight() {
    MouseTabGoToAdjacent("right")
}

MouseTabGoToAdjacent(leftOrRight) {
    static STATES := Map(
        1,  {left: "!{Up}",   right: "!{Down}"},
        2,  {left: "{PgUp}",  right: "{PgDn}"},
        3,  {left: "^+{Tab}", right: "^{Tab}"},
        4,  {left: "{Left}",  right: "{Right}"},
        -1, {left: "^{PgUp}", right: "^{PgDn}"}
    )

    MouseWinActivate()
    winProcessName := WinGetProcessName()
    switch winProcessName {
        case "Discord.exe", "Messenger.exe":
            Send(STATES[1].%leftOrRight%)
            return
        case "POWERPNT.EXE":
            Send(STATES[2].%leftOrRight%)
            return
        case "AcroRd32.exe", "Photoshop.exe", "WindowsTerminal.exe":
            Send(STATES[3].%leftOrRight%)
            return
    }

    winClass := WinGetClass()
    switch winClass {
        case "CabinetWClass":
            Send(STATES[3].%leftOrRight%)
            return
    }

    ; (In the native Photos app, you have to click one of the arrows that will go to
    ; an adjacent photo before this hotkey works.)
    if (winProcessName = 'Photos.exe') and (winClass = 'WinUIDesktopWin32WindowClass') {
        Send(STATES[4].%leftOrRight%)
        return
    }

    Send(STATES[-1].%leftOrRight%)
}
#HotIf
