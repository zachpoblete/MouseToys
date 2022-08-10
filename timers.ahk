#Include <default-settings>
#Include <constants>

SetTimer(ClosePopUps)
ClosePopUps() {
    try {
        WinClose('RAKK Lam-Ang Pro FineTuner ' CLASSES['DIALOG_BOX'] ' ahk_exe RAKK Lam-Ang Pro Mechanical Keyboard.exe', 'Failed to activate profile!')  ; When selecting a different profile in RAKK Lam-Ang Pro FineTuner, close the pop-up error
    }
}
