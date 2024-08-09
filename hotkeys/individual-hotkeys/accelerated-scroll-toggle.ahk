#Include accelerated-scroll-main.ahk

#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include get-user-settings-path.ahk
#Include accelerated-scroll-show-user-setting.ahk

A_TrayMenu.insert('E&xit', 'Enable &Accelerated Scroll', (*) => ToggleAcceleratedScroll())

ToggleAcceleratedScroll() {
    userSettingsPath := GetUserSettingsPath()
    acceleratedScrollIsOn := IniRead(userSettingsPath, '', 'AcceleratedScrollIsOn')
    IniWrite(not acceleratedScrollIsOn, userSettingsPath, '', 'AcceleratedScrollIsOn')

    Hotkey('WheelDown', 'Toggle')
    Hotkey('WheelUp', 'Toggle')

    A_TrayMenu.toggleCheck('Enable &Accelerated Scroll')
    ShowAcceleratedScrollSettingAtMouse()
}
