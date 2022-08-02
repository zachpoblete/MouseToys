#Include <default-settings>
#Include <constants>

SetTimer ClosePopUps
ClosePopUps() {
    try {
        WinClose 'RAKK Lam-Ang Pro FineTuner ' CLASSES['DIALOG_BOX'] ' ahk_exe RAKK Lam-Ang Pro Mechanical Keyboard.exe', 'Failed to activate profile!'  ; When selecting a different profile in RAKK Lam-Ang Pro FineTuner, close the pop-up error
    }
}

#LButton::
    WinDrag(thisHotkey) {
        WinExist 'A'

        if MouseWinActivate('ahk_class WorkerW ahk_exe Explorer.EXE') or WinGetMinMax() != 0 {
            return
        }
        CoordMode 'Mouse', 'Screen'
        MouseGetPos &mouseStartX, &mouseStartY
        WinGetPos &winOriginalX, &winOriginalY

        while GetKeyState('LButton', 'P') {  ; SetTimer isn't used to retain the last found window.
            if GetKeyState('Esc', 'P') {
                WinMove winOriginalX, winOriginalY
                break
            }
            MouseGetPos &mouseX, &mouseY
            WinGetPos &winX, &winY
            WinMove winX + (mouseX - mouseStartX), winY + (mouseY - mouseStartY)

            mouseStartX := mouseX
            mouseStartY := mouseY

            Sleep 10
        }
    }
