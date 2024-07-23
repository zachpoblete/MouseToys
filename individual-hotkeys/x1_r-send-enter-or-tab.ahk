#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

/**
 * Press XButton1 + RButton
 * to send the Enter key ⬇️.
 * Press XButton1 + RButton + LButton
 * to send the Tab key ➡️.
 */

#HotIf GetKeyState('XButton1', 'P')
*RButton Up::          MouseSend('{Enter}', thisHotkey)
RButton & LButton Up:: MouseSend('{Tab}')
#HotIf
