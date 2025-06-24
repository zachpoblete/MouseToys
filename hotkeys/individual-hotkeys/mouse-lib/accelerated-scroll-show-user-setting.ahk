#Include user-settings-path.ahk

ShowAcceleratedScrollSettingAtMouse() {
    static acceleratedScrollSetting

    acceleratedScrollIsOn := IniRead(UserSettingsPath, '', 'AcceleratedScrollIsOn')
    acceleratedScrollSetting := acceleratedScrollIsOn ? 'ON' : 'OFF'

    SetTimer(tempToolTip, 0)
    SetTimer(tempToolTip, 10)
    SetTimer(closeTempToolTip, -3000)

    ; Make tempToolTip static so that it doesn't flicker upon toggling quickly.
    static tempToolTip() {
        ToolTip('Accelerated Scroll ' acceleratedScrollSetting)
    }

    closeTempToolTip() {
        SetTimer(tempToolTip, 0)
        ToolTip()
    }
}
