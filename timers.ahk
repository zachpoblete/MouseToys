#Include <default-settings>
#Include <constants>

SetTimer ClosePopUps
ClosePopUps() {
    try WinClose 'RAKK Lam-Ang Pro FineTuner ' . CLASSES['DIALOG_BOX'] . ' ahk_exe RAKK Lam-Ang Pro Mechanical Keyboard.exe', 'Failed to activate profile!'  ; When selecting a different profile in RAKK Lam-Ang Pro FineTuner, close the pop-up error
}

#LButton::
    WinDrag(this_hk) {
        WinExist 'A'
        
        if MouseWinActivate('ahk_class WorkerW ahk_exe Explorer.EXE') or WinGetMinMax() != 0
            return

        CoordMode 'Mouse', 'Screen'
        MouseGetPos &mouse_start_x, &mouse_start_y
        WinGetPos &win_original_x, &win_original_y

        while GetKeyState('LButton', 'P') {  ; SetTimer isn't used to retain the last found window.
            if GetKeyState('Esc', 'P') {
                WinMove win_original_x, win_original_y
                break
            }

            MouseGetPos &mouse_x, &mouse_y
            WinGetPos &win_x, &win_y
            WinMove win_x + (mouse_x - mouse_start_x), win_y + (mouse_y - mouse_start_y)

            mouse_start_x := mouse_x
            mouse_start_y := mouse_y

            Sleep 10
        }
    }
