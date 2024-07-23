#Include lib
#Include mouse-functions.ahk
#Include fix-x2.ahk

/**
 * Press XButton2 + MButton
 * to open a link in a new active tab 🔗.
 */

#HotIf GetKeyState('XButton2', 'P')
MButton Up:: MouseOpenLinkInNewActiveTab(thisHotkey)

; Stop the native function from going through.
MButton::    return

MouseOpenLinkInNewActiveTab(thisHotkey) {
    MouseExitIfCantBeThisHk(thisHotkey)
    Send('^+{Click}')
}
#HotIf
