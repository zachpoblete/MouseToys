#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2-shortcuts.ahk

#HotIf GetKeyState('XButton2', 'P')
    MButton Up:: {
        if A_PriorKey != "MButton" {
            return
        }

        Send('^+{Click}')
    }
#HotIf
