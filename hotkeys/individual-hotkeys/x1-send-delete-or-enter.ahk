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

    LButton & RButton Up:: {
        Debounce("RButton")

        ; We're not using SendAtMouse because I've found it more useful to not ActivateWinAtMouse:
        Send('{Blind}{Delete}')
    }
#HotIf
