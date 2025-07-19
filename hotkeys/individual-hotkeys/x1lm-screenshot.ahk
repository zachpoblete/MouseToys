#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include fix-x1-shortcuts.ahk

#HotIf GetKeyState('XButton1', 'P')
    LButton & MButton Up:: {
        ; For why CameFrom3ButtonCombo is needed, see x1l-send-enter-or-delete.ahk
        global CameFrom3ButtonCombo

        ; We set CameFrom3ButtonCombo at the start of the hotkey because Debounce could exit
        ; the hotkey; if CameFrom3ButtonCombo were at the end of the hotkey, it might
        ; not get set.
        CameFrom3ButtonCombo := true

        Screenshot()
    }
#HotIf

Screenshot() {
    Send("#+s")
}
