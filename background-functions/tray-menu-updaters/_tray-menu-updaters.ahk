#Include update-browser-history-backup.ahk
#Include update-vs-code-ext-list.ahk

AddUpdateSubMenuToTray()
AddUpdateSubMenuToTray() {
    menu_Update := Menu()
    A_TrayMenu.insert('E&xit', 'Update...', menu_Update)
    menu_Update.add('VS Code Extension List', UpdateVsCodeExtList)
    menu_Update.add('Browser History Backup', UpdateBrowserHistoryBackup)
    menu_Update.add('Edge Extensions List', (name, pos, menu) =>
            Run('PowerShell.exe Start-ScheduledTask -TaskPath "\Custom" -TaskName "update-edge-extensions-list"'))
}
