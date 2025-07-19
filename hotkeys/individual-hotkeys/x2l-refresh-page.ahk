#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2-shortcuts.ahk

#HotIf GetKeyState('XButton2', 'P')
    LButton Up:: {
        if A_PriorKey != "LButton" {
            return
        }
        RefreshPageAtMouse()
    }
#HotIf

RefreshPageAtMouse() {
    SendAtMouse('^r')
}
