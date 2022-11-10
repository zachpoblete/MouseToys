#Include <default-settings>
#Include <constants>
#Include <functions>

;= =============================================================================
;= At Launch
;= =============================================================================

UpdateVSCodeExtList()
UpdateVSCodeExtList() {
    userProfileDir := EnvGet('USERPROFILE')
    vsCodeExtsDir := userProfileDir '\.vscode\extensions'
    list := ''

    Loop Files vsCodeExtsDir '\*', 'D' {
        list .= A_LoopFileName '`n'
    }
    extListFile := A_AppData '\Code\User\extensions.txt'
    FileDelete(extListFile)
    FileAppend(list, extListFile)
}

;= =============================================================================
;= Timers
;= =============================================================================

SetTimer(CloseRakkPopup, 1000)
CloseRakkPopup() {
    try {
        WinClose('RAKK Lam-Ang Pro FineTuner ' K_CLASSES['DIALOG_BOX'] ' ahk_exe RAKK Lam-Ang Pro Mechanical Keyboard.exe', 'Failed to activate profile!')
                ; When selecting a different profile in RAKK Lam-Ang Pro FineTuner,
                ; close the pop-up error.
    }
}

SetTimer(CloseMonokaiPopup, 1000)
CloseMonokaiPopup() {
    static monokaiMsg :=
    (Join`r`n
        '[Window Title]
        Visual Studio Code

        [Content]
        Thank you for evaluating Monokai Pro. Please purchase a license for extended use.

        [OK] [Cancel]'
    )

    if not WinExist('Visual Studio Code ' K_CLASSES['DIALOG_BOX'] ' ahk_exe Code.exe') {
        return
    }
    okButtonHwnd     := ControlGetHwndFromClassNnAndTextElseExit('Button1', 'OK')
    cancelButtonHwnd := ControlGetHwndFromClassNnAndTextElseExit('Button2', 'Cancel')

    activeMsg := GetSelected()

    if activeMsg != monokaiMsg {
        return
    }
    ControlClick(cancelButtonHwnd)
}
