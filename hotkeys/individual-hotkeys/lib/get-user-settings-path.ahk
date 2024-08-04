GetUserSettingsPath() {
    libDir := RegExReplace(A_LineFile, '\\[^\\]+$')
    return libDir . "\user-settings.ini"
}
