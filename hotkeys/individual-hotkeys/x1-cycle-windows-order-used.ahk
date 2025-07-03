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

; Press XButton1 + MButton
; to close a window while cycling through windows in recently used order ❎.
!MButton Up:: CloseCyclingWinAtMouse()
