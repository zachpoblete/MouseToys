#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

; Press XButton1 + RButton
; to copy to the clipboard 📋.
; Press XButton1 + RButton + LButton
; to paste from the clipboard 📋.
#HotIf GetKeyState('XButton1', 'P')
    RButton Up:: {
        if A_PriorKey != "RButton" {
            return
        }

        Send("{Volume_Mute}")
    }

    RButton & LButton Up:: Send("{Media_Play_Pause}")
#HotIf
