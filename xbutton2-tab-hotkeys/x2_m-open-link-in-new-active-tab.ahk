#Include ..\mouse-functions.ahk

/**
 * Press XButton2 + MButton
 * to open a link in a new active tab 🔗.
 */

#HotIf GetKeyState('XButton2', 'P')
MButton Up:: MouseLinkOpenInNewActiveTab(thisHotkey)
MouseLinkOpenInNewActiveTab(thisHotkey) {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorKey)
    Send('^+{Click}')
}
#HotIf
