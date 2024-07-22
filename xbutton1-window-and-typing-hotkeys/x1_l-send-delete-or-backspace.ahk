#Include ..\mouse-functions.ahk

/**
 * Press XButton1 + LButton
 * to send the Delete key ❎.
 * Press XButton1 + LButton + RButton
 * to send the Backspace key ❎.
 */

#HotIf GetKeyState('XButton1', 'P')
*LButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorHotkey)
    
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click()
        return
    }

    MouseSend('{Delete}')
}

LButton & RButton Up:: MouseSend('{Backspace}')
#HotIf
