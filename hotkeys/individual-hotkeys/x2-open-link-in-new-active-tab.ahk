#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2-shortcuts.ahk

; Press XButton2 + MButton
; to open a link in a new active tab 🔗.
#HotIf GetKeyState('XButton2', 'P')
    MButton Up:: {
        if A_PriorKey != "MButton" {
            return
        }

        Send('^+{Click}')
    }
#HotIf
