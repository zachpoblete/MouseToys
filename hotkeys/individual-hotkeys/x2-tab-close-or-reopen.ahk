#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

#Include common-lib
#Include default-settings.ahk

; Press XButton2 + RButton
; to close the current tab ❎.
; Press XButton2 + RButton + LButton
; to reopen the last closed tab ↪.
#HotIf GetKeyState('XButton2', 'P')
RButton Up::           MouseTabClose(thisHotkey)
RButton & LButton Up:: MouseTabReopenLastClosed()

MouseTabClose(thisHotkey := "") {
    MouseSend("^w", thisHotkey)
}

MouseTabReopenLastClosed(thisHotkey := "") {
    MouseSend("^+t", thisHotkey)
}
#HotIf
