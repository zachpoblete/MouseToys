#Include lib
#Include fix-x1.ahk

/**
 * Press XButton1 + MButton + LButton
 * to take a screenshot 📸.
 */

#HotIf GetKeyState('XButton1', 'P')
MButton & LButton Up:: MouseScreenshot()

MouseScreenshot() {
    Send("#+s")
}
#HotIf
