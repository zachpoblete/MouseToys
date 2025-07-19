#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

#HotIf GetKeyState('XButton2', 'P')
    LButton & MButton Up:: DuplicatePageAtMouse()
#HotIf

DuplicatePageAtMouse() {
    Send("^+k")
}
