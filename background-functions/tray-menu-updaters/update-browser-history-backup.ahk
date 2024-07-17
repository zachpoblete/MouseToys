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
