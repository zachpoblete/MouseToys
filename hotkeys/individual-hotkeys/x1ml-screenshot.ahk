#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include fix-x1-shortcuts.ahk

#HotIf GetKeyState('XButton1', 'P')
    MButton & LButton Up:: Screenshot()
#HotIf

Screenshot() {
    Send("#+s")
}
