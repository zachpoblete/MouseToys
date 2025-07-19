#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2-shortcuts.ahk

#HotIf GetKeyState('XButton2', 'P')
    WheelUp::   GoToLeftTabAtMouse()
    WheelDown:: GoToRightTabAtMouse()
#HotIf

GoToLeftTabAtMouse() {
    GoToAdjacentTabAtMouse(true)
}

GoToRightTabAtMouse() {
    GoToAdjacentTabAtMouse(false)
}

GoToAdjacentTabAtMouse(shouldGoLeft) {
    ActivateWinAtMouse()
    winProcessName := WinGetProcessName()
    switch winProcessName {
    case "Discord.exe", "Messenger.exe":
        Send(shouldGoLeft ? "!{Up}" : "!{Down}")
        return
    case "POWERPNT.EXE":
        Send(shouldGoLeft ? "{PgUp}" : "{PgDn}")
        return
    case "AcroRd32.exe", "Photoshop.exe", "WindowsTerminal.exe":
        Send(shouldGoLeft ? "^+{Tab}" : "^{Tab}")
        return
    }

    winClass := WinGetClass()
    switch winClass {
    case "CabinetWClass":
        Send(shouldGoLeft ? "^+{Tab}" : "^{Tab}")
        return
    }

    ; (In the native Photos app, you have to click one of the arrows that will go to
    ; an adjacent photo before this hotkey works.)
    if (winProcessName = 'Photos.exe') and (winClass = 'WinUIDesktopWin32WindowClass') {
        Send(shouldGoLeft ? "{Left}" : "{Right}")
        return
    }

    Send(shouldGoLeft ? "^{PgUp}" : "^{PgDn}")
}
