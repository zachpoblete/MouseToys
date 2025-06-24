#Include accelerated-scroll-main.ahk

#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include user-settings-path.ahk
#Include accelerated-scroll-show-user-setting.ahk

A_TrayMenu.insert('E&xit', 'Enable &Accelerated Scroll', (*) => ToggleAcceleratedScroll())

ToggleAcceleratedScroll() {
    acceleratedScrollIsOn := IniRead(UserSettingsPath, '', 'AcceleratedScrollIsOn')
    IniWrite(not acceleratedScrollIsOn, UserSettingsPath, '', 'AcceleratedScrollIsOn')

    Hotkey('WheelDown', 'Toggle')
    Hotkey('WheelUp', 'Toggle')

    A_TrayMenu.toggleCheck('Enable &Accelerated Scroll')
    ShowAcceleratedScrollSettingAtMouse()
}
