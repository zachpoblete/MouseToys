#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

; Press XButton1 + LButton
; to send the Delete key ❎.
; Press XButton1 + LButton + RButton
; to send the Enter key ⬇️.
#HotIf GetKeyState('XButton1', 'P')
    *LButton Up:: {
        ; The condition isn't `if A_PriorKey = "LButton"` because if a standard modifier
        ; were down, it would keep triggering a down press and A_PriorKey would be the
        ; standard modifier most of the time. By checking if A_PriorHotkey contains
        ; "LButton", we check if it's either LButton or *LButton:
        if not InStr(A_PriorHotkey, "LButton") {
            return
        }

        ; Don't send Enter if the intention of activating this hotkey was actually
        ; to click a window in the Task Switcher because the X1+W::AltTab hotkey was
        ; used.
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
