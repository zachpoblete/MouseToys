#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

; Press XButton1 + LButton
; to send the Delete key ❎.
; Press XButton1 + LButton + RButton
; to send the Enter key ⬇️.
#HotIf GetKeyState('XButton1', 'P')
    *LButton Up:: {
        if not IsThisMouseHotkeyCorrect(thisHotkey) {
            return
        }

        if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
            Click()
            return
        }

        SendAtMouse('{Delete}')
    }

    LButton & RButton Up:: SendAtMouse('{Enter}')
#HotIf
