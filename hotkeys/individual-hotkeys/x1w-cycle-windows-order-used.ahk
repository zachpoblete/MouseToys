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

    ; The hotkeys below have to be Up hotkeys to take over X1+L and X1+M,
    ; respectively.
    !LButton Up:: Click()
    !MButton Up:: Click("M")
#HotIf
