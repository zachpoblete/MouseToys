#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include fix-x1.ahk

; Press XButton1 + MButton + LButton
; to take a screenshot 📸.
#HotIf GetKeyState('XButton1', 'P')
    MButton & LButton Up:: MouseScreenshot()
#HotIf

MouseScreenshot() {
    Send("#+s")
}
