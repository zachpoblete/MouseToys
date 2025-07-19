#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

#HotIf GetKeyState('XButton1', 'P')
    RButton & LButton Up:: Send("{Media_Play_Pause}")
#HotIf
