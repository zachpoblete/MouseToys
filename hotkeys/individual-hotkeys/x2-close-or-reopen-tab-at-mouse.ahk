#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

; Press XButton2 + RButton
; to close the current tab ❎.
; Press XButton2 + RButton + LButton
; to reopen the last closed tab ↪.
#HotIf GetKeyState('XButton2', 'P')
    RButton Up::           CloseTabAtMouse(thisHotkey)
    RButton & LButton Up:: ReopenClosedTabAtMouse()
#HotIf

CloseTabAtMouse(thisHotkey := "") {
    SendAtMouse("^w", thisHotkey)
}

ReopenClosedTabAtMouse(thisHotkey := "") {
    SendAtMouse("^+t", thisHotkey)
}
