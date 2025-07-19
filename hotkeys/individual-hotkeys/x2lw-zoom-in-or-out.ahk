#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2-shortcuts.ahk

#HotIf GetKeyState('XButton2', 'P')
    LButton & WheelUp::   ZoomInAtMouse()
    LButton & WheelDown:: ZoomOutAtMouse()
#HotIf

ZoomInAtMouse() {
    SendAtMouse("^=")
}

ZoomOutAtMouse() {
    SendAtMouse("^-")
}
