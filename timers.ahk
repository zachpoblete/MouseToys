#Include <default-settings>
#Include <constants>

SetTimer ClosePopUps

ClosePopUps() {
    try WinClose 'RAKK Lam-Ang Pro FineTuner ' . CLASSES['DIALOG_BOX'] . ' ahk_exe RAKK Lam-Ang Pro Mechanical Keyboard.exe', 'Failed to activate profile!'  ; When selecting a different profile in RAKK Lam-Ang Pro FineTuner, close the pop-up error
    try WinClose 'qBittorrent Update Available ahk_class Qt5152QWindowIcon'  ; When opening qBittorent, close the pop-up update. The website it brings you to to download the new version just looks sus.
}

#Hotif GetKeyState('LWin', 'P')
LButton::  ; Not #LButton because LWin is a hotkey.
    WinDrag(this_hk) {
        if MouseWinActivate('ahk_class WorkerW ahk_exe Explorer.EXE') or WinGetMinMax() != 0
            return

        CoordMode 'Mouse', 'Screen'
        MouseGetPos &mouse_start_x, &mouse_start_y
        WinExist 'A'
        WinGetPos &win_original_x, &win_original_y

        while GetKeyState('LButton', 'P') {
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
#Hotif
