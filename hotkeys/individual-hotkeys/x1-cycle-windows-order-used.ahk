#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

#HotIf GetKeyState('XButton1', 'P')
    WheelDown:: {
        Send('{Alt Down}{Tab}')
        KeyWait("XButton1")
        Send('{Alt Up}')
    }
    WheelUp:: {
        Send('{Alt Down}+{Tab}')
        KeyWait("XButton1")
        Send('{Alt Up}')
    }
    !WheelDown:: Send("{Tab}")
    !WheelUp::   Send("+{Tab}")
#HotIf

; Allow closing a window while cycling. This solution retains the native function of !MButton:
~!MButton::    return
~!MButton Up:: return
