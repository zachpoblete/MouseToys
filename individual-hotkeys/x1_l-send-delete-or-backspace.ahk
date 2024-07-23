#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

/**
 * Press XButton1 + LButton
 * to send the Delete key ❎.
 * Press XButton1 + LButton + RButton
 * to send the Backspace key ❎.
 */

#HotIf GetKeyState('XButton1', 'P')
*LButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey)

    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click()
        return
    }

    MouseSend('{Delete}')
}

LButton & RButton Up:: MouseSend('{Backspace}')
#HotIf
