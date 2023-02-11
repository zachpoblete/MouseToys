#Include <default-settings>
#Include <constants>
#Include <functions>

;= =============================================================================
;= Update
;= =============================================================================

AddUpdateSubMenuToTray()
AddUpdateSubMenuToTray() {
    menu_Update := Menu()
    A_TrayMenu.insert('E&xit', 'Update...', menu_Update)
    menu_Update.add('VS Code Extension List', UpdateVsCodeExtList)
    menu_Update.add('Browser History Backup', UpdateBrowserHistoryBackup)
    menu_Update.add('Edge Extensions List', (name, pos, menu) =>
            Run('PowerShell.exe Start-ScheduledTask -TaskPath "\Custom" -TaskName "update-edge-extensions-list"'))
}

UpdateVsCodeExtList(name, pos, menu) {
    vsCodeExtsDir := EnvGet('USERPROFILE') '\.vscode\extensions'
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

UpdateBrowserHistoryBackup(name, pos, menu) {
    backupFileNamePattern := 'history_autobackup_*_full.tsv'
    newBackupPath := EnvGet('USERPROFILE') '\Downloads\' backupFileNamePattern
    
    if not FileExist(newBackupPath) {
        MsgBox('New browser history backup does not exist')
    }
        
    oldBackupDir := A_MyDocuments '\Browser Extensions (Private)\Backups'
    FileDelete(oldBackupDir '\' backupFileNamePattern)
    FileMove(newBackupPath, oldBackupDir)
}

;= =============================================================================
;= Timers
;= =============================================================================

;~ SetTimer(CloseRakkPopup, 1000)
;~ CloseRakkPopup() {
;~     try {
;~         WinClose('RAKK Lam-Ang Pro FineTuner ' K_CLASSES['DIALOG_BOX'] ' ahk_exe RAKK Lam-Ang Pro Mechanical Keyboard.exe', 'Failed to activate profile!')
;~                 ; When selecting a different profile in RAKK Lam-Ang Pro FineTuner,
;~                 ; close the pop-up error.
;~     }
;~ }

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
            ; VS Code still needs to be active fsr.
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
