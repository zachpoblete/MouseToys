#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

; Press XButton2 + MButton
; to open a link in a new active tab 🔗.
#HotIf GetKeyState('XButton2', 'P')
MButton Up:: CtrlShiftClick(thisHotkey)

; Stop the native function from going through.
MButton::    return

CtrlShiftClick(thisHotkey := "") {
    if thisHotkey and not MouseIsThisHotkeyCorrect(thisHotkey) {
        return
    }

    ; Don't use MouseSend because we don't need to activate the window.
    Send('^+{Click}')
}
#HotIf
