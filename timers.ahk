#Include <default-settings>
#Include <constants>

SetTimer(CloseRakkPopup)
CloseRakkPopup() {
    try {
        WinClose('RAKK Lam-Ang Pro FineTuner ' CLASSES['DIALOG_BOX'] ' ahk_exe RAKK Lam-Ang Pro Mechanical Keyboard.exe', 'Failed to activate profile!')  ; When selecting a different profile in RAKK Lam-Ang Pro FineTuner, close the pop-up error
    }
}

SetTimer(CloseMonokaiPopup)
CloseMonokaiPopup() {
    static monokaiMsg :=
    (Join`r`n
        '[Window Title]
        Visual Studio Code

        [Content]
        Thank you for evaluating Monokai Pro. Please purchase a license for extended use.

        [OK] [Cancel]'
    )

    if not WinActive('Visual Studio Code ' CLASSES['DIALOG_BOX'] ' ahk_exe Code.exe') {
        return
    }
    try {
        focusedControlHwnd := ControlGetFocus()
        focusedControlClassNn := ControlGetClassNN(focusedControlHwnd)
        focusedControlText := ControlGetText(focusedControlHwnd)
        hasOkButton := focusedControlClassNn = 'Button1' and focusedControlText = 'OK'

        if not hasOkButton {
            return
        }
        cancelButtonHwndFromClassNn := ControlGetHwnd('Button2')
        cancelButtonHwndFromText := ControlGetHwnd('Cancel')
        hasCancelButton := cancelButtonHwndFromClassNn = cancelButtonHwndFromText

        if not hasCancelButton {
            return
        }
    } catch {
        return
    }
    activeMsg := GetSelected()
    
    if activeMsg != monokaiMsg {
        return
    }
    cancelButton := cancelButtonHwndFromClassNn
    ControlClick(cancelButton)
}
