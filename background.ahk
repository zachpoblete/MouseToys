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
    extList := ''
    Loop Files vsCodeExtsDir '\*', 'D' {
        extList .= A_LoopFileName '`r`n'
    }
    
    obsoleteFile := vsCodeExtsDir '\.obsolete'
    try {
        obsoleteFilesStr := FileRead(obsoleteFile)
        obsoleteFilesStr := LTrim(obsoleteFilesStr, '{"')
        obsoleteFilesStr := RTrim(obsoleteFilesStr, '":true}')

        obsoleteFilesStr := StrReplace(obsoleteFilesStr, '":true,"', '|')
        Loop Parse obsoleteFilesStr, '|' {
            extList := RegExReplace(extList, A_LoopField '`r`n')
        }
    }

    extList := RegExReplace(extList, 'm)-\d+(\.\d+){2}$')

    extListFile := A_AppData '\Code\User\extensions.txt'
    FileDelete(extListFile)
    FileAppend(extList, extListFile)
}

UpdateBrowserHistoryBackup()
UpdateBrowserHistoryBackup() {
    destDir := A_MyDocuments '\Browser Extension Backups'
    backupFileName := 'history_autobackup_*_full.tsv'

    FileDelete(destDir '\' backupFileName)

    userProfileDir := EnvGet('USERPROFILE')
    downloadsDir := userProfileDir '\Downloads'
    FileMove(downloadsDir '\' backupFileName, destDir)
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

SetTimer(CloseMonokaiPopup, 500)
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
    okBtnHwnd     := ControlGetHwndFromClassNnAndTextElseExit('Button1', 'OK')
    cancelBtnHwnd := ControlGetHwndFromClassNnAndTextElseExit('Button2', 'Cancel')

    activeMsg := GetSelected()

    if activeMsg != monokaiMsg {
        return
    }
    ControlClick(cancelBtnHwnd)
}
