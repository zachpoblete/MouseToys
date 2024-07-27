#Include accelerated-scroll-main.ahk

#Include lib
#Include get-user-settings-path.ahk

A_TrayMenu.insert('E&xit', 'Enable &Accelerated Scroll', (*) {
    ToggleAcceleratedScroll()
    MouseShowAcceleratedScrollSetting()
})

UseUserAcceleratedScrollSetting()
MouseShowAcceleratedScrollSetting()

MouseShowAcceleratedScrollSetting() {
    static acceleratedScrollSetting

    userSettingsPath := GetUserSettingsPath()
    acceleratedScrollIsOn := IniRead(userSettingsPath, '', 'AcceleratedScrollIsOn')
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

ToggleAcceleratedScroll() {
    userSettingsPath := GetUserSettingsPath()
    acceleratedScrollIsOn := IniRead(userSettingsPath, '', 'AcceleratedScrollIsOn')
    IniWrite(not acceleratedScrollIsOn, userSettingsPath, '', 'AcceleratedScrollIsOn')

    Hotkey('WheelDown', 'Toggle')
    Hotkey('WheelUp', 'Toggle')

    A_TrayMenu.toggleCheck('Enable &Accelerated Scroll')
    A_WorkingDir := A_ScriptDir
}

UseUserAcceleratedScrollSetting() {
    userSettingsPath := GetUserSettingsPath()
    acceleratedScrollIsOn := IniRead(userSettingsPath, '', 'AcceleratedScrollIsOn')
    if acceleratedScrollIsOn {
        A_TrayMenu.check('Enable &Accelerated Scroll')
        action := "On"
    } else {
        A_TrayMenu.uncheck('Enable &Accelerated Scroll')
        action := "Off"
    }
    Hotkey('WheelDown', action)
    Hotkey('WheelUp', action)
    A_WorkingDir := A_ScriptDir
}
