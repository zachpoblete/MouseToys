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
    extsCsvText := ''
    loop files vsCodeExtsDir '\*', 'D' {
        loop files A_LoopFilePath '\package.json' {
            jsonPackageText := FileRead(A_LoopFilePath)
            getJsonPackageProp(&extName, 'name')
            getJsonPackageProp(&extDisplayName, 'displayName')
            getJsonPackageProp(&extPublisher, 'publisher')
            getJsonPackageProp(&extPublisherDisplayName, 'publisherDisplayName')
            getJsonPackageProp(&extVer, 'version')
            getJsonPackageProp(&extWorkspaceSuffix, 'workspaceSuffix')

            extsCsvText .= '`r`n"'
            try {
                extsCsvText .= extWorkspaceSuffix[1]
            } catch {
                try {
                    extsCsvText .= extDisplayName[1]
                } catch {
                    extsCsvText .= extName[1]
                }
            }

            extsCsvText .= '","' extPublisherDisplayName[1] '","https://marketplace.visualstudio.com/items?itemName='
                    . extPublisher[1] '.' extName[1] '-' extVer[1]
        }
    }

    obsoleteFile := vsCodeExtsDir '\.obsolete'
    try {
        obsoleteFileText := FileRead(obsoleteFile)
        obsoleteFileText := LTrim(obsoleteFileText, '{"')
        obsoleteFileText := RTrim(obsoleteFileText, '":true}')

        obsoleteFileText := StrReplace(obsoleteFileText, '":true,"', '|')
        loop parse obsoleteFileText, '|' {
            extsCsvText := RegExReplace(extsCsvText, 'i).+' A_LoopField '`r`n')
        }
    }

    extsCsvText := RegExReplace(extsCsvText, 'm)-\d+(\.\d+){2}$', '"')
    extsCsvText := Sort(extsCsvText)
    extsCsvText := '"Extension","Publisher","Link"' extsCsvText

    extsCsv := A_AppData '\Code\User\extensions.csv'
    FileRecycle(extsCsv)
    FileAppend(extsCsvText, extsCsv)

    getJsonPackageProp(&extProp, prop) {
        RegExMatch(jsonPackageText, 'm)^' A_Tab '+"' prop '": "(.+)",?$', &extProp)
    }
}

UpdateBrowserHistoryBackup(name, pos, menu) {
    backupFileNamePattern := 'history_autobackup_*_full.tsv'
    newBackupPath := EnvGet('USERPROFILE') '\Downloads\' backupFileNamePattern
    if not FileExist(newBackupPath) {
        MsgBox('New browser history backup does not exist')
    }

    oldBackupDir := A_MyDocuments '\Browser Extensions (Private)\Backups'
    FileRecycle(oldBackupDir '\' backupFileNamePattern)
    FileMove(newBackupPath, oldBackupDir)
}

;= =============================================================================
;= Timers
;= =============================================================================

SetTimer(ClosePopups)
ClosePopups() {
    CloseMonokaiPopup()
}

CloseMonokaiPopup() {
    static _monokaiMsg :=
    (Join`r`n
        '[Window Title]
        Visual Studio Code

        [Content]
        Thank you for evaluating Monokai Pro. Please purchase a license for extended use.

        [OK] [Cancel]'
    )

    if not WinExist('Visual Studio Code ' K_CLASSES['DIALOG_BOX'] ' ahk_exe Code.exe')
            ; VS Code still needs to be active fsr.
    {
        return
    }

    WinActivate()

    activeMsg := GetSelected()
    if activeMsg != _monokaiMsg {
        return
    }
    WinClose()
}
