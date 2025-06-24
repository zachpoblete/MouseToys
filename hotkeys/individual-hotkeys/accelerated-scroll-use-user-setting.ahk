#Include accelerated-scroll-main.ahk

#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include user-settings-path.ahk
#Include accelerated-scroll-show-user-setting.ahk

UseUserAcceleratedScrollSetting()

UseUserAcceleratedScrollSetting() {
    acceleratedScrollIsOn := IniRead(UserSettingsPath, '', 'AcceleratedScrollIsOn')
    if acceleratedScrollIsOn {
        A_TrayMenu.check('Enable &Accelerated Scroll')
        action := "On"
    } else {
        A_TrayMenu.uncheck('Enable &Accelerated Scroll')
        action := "Off"
    }
    Hotkey('WheelDown', action)
    Hotkey('WheelUp', action)
    ShowAcceleratedScrollSettingAtMouse()
}
