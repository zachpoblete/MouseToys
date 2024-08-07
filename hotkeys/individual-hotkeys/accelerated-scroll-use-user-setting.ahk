#Include accelerated-scroll-main.ahk

#Include lib
#Include get-user-settings-path.ahk
#Include accelerated-scroll-show-user-setting.ahk

#Include ahk-utils
#Include default-settings.ahk

UseUserAcceleratedScrollSetting()

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
    MouseShowAcceleratedScrollSetting()
}
