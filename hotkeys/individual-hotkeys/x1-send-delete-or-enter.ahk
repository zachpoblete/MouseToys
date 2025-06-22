#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

; Press XButton1 + LButton
; to send the Delete key ❎.
; Press XButton1 + LButton + RButton
; to send the Enter key ⬇️.
#HotIf GetKeyState('XButton1', 'P')
    *LButton Up:: {
        if A_PriorKey != "LButton" {
            return
        }

        if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
            Click()
            return
        }

        ; We're not using SendAtMouse because I've found it more useful to not ActivateWinAtMouse:
        Send('{Blind}{Enter}')
    }

    LButton & RButton:: {
        ; There might be something broken in my mouse because when I sometimes release RButton,
        ; it gets pressed down again and activates the hotkey a second time.
        ; So we need to catch when that happens:
        if A_PriorKey = "RButton" and (A_PriorHotkey and A_TimeSincePriorHotkey < 50) {
            return
        }
        KeyWait("RButton")

        ; We're not using SendAtMouse because I've found it more useful to not ActivateWinAtMouse:
        Send('{Blind}{Delete}')
    }
#HotIf
