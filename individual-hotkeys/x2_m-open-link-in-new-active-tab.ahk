#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

/**
 * Press XButton2 + MButton
 * to open a link in a new active tab 🔗.
 */

#HotIf GetKeyState('XButton2', 'P')
MButton:: return
MButton Up:: MouseLinkOpenInNewActiveTab(thisHotkey)
MouseLinkOpenInNewActiveTab(thisHotkey) {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorKey)
    Send('^+{Click}')
}
#HotIf
