#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

; For why CameFrom3ButtonCombo is needed, see the comment for the
; CameFrom3ButtonCombo if-condition below.
CameFrom3ButtonCombo := false

#HotIf GetKeyState('XButton1', 'P')
    *LButton Up:: {
        global CameFrom3ButtonCombo

        ; The condition isn't `if A_PriorKey = "LButton"` because if a standard modifier
        ; were down, it would keep triggering a down press and A_PriorKey would be the
        ; standard modifier most of the time. We don't check if `A_PriorHotkey =
        ; "*LButton"` because this is always true because the LButton hotkey always
        ; fires on release along with LButton Up. And not only does the LButton hotkey
        ; fire along with the LButton Up hotkey, the LButton hotkey fires before the
        ; LButton Up hotkey. This possibly has something to do with the LButton &
        ; RButton Up hotkey firing before both those hotkeys. I think this whole thing
        ; is a bug. See https://www.autohotkey.com/boards/viewtopic.php?f=14&t=137956
        ; CameFrom3ButtonCombo and the CameFrom3ButtonCombo if-condition is a temporary
        ; solution.
        if CameFrom3ButtonCombo {
            CameFrom3ButtonCombo := false
            return
        }

        CameFrom3ButtonCombo := false

        ; Don't send Enter if the intention of activating this hotkey was actually to
        ; click a window in the Task Switcher because the X1+W::AltTab hotkey was used.
        ; Another way of solving this is making `~!LButton:: return`, but `~!LButton Up:
        ; return` would be needed, which would disable Alt+X1+L, making Alt+Enter not
        ; possible.
        if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
            Click()
            return
        }

        ; We're not using SendAtMouse because I've found it more useful to not ActivateWinAtMouse:
        Send('{Blind}{Enter}')
    }

    LButton & RButton Up:: {
        global CameFrom3ButtonCombo

        ; We set CameFrom3ButtonCombo at the start of the hotkey because Debounce could exit
        ; the hotkey; if CameFrom3ButtonCombo were at the end of the hotkey, it might
        ; not get set.
        CameFrom3ButtonCombo := true

        Debounce("RButton", 110)

        ; We're not using SendAtMouse because I've found it more useful to not ActivateWinAtMouse:
        Send('{Blind}{Delete}')
    }
#HotIf
