#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2-shortcuts.ahk

#HotIf GetKeyState('XButton2', 'P')
    RButton Up:: {
        if A_PriorKey != "RButton" {
            return
        }

        Debounce("RButton", 110)

        CloseTabAtMouse()
    }

    RButton & LButton Up:: ReopenClosedTabAtMouse()
#HotIf

CloseTabAtMouse() {
    SendAtMouse('^w')
}

ReopenClosedTabAtMouse() {
    SendAtMouse("^+t")
}
