#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2-shortcuts.ahk

#HotIf GetKeyState('XButton2', 'P')
    LButton & RButton Up:: {
        Debounce("RButton", 110)
        PasteAndGoAtMouse()
    }
#HotIf

PasteAndGoAtMouse() {
    SendAtMouse('^+l')
}

