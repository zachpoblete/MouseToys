#Include accelerated-scroll-main.ahk

#Include lib
#Include mouse-functions.ahk

A_TrayMenu.insert('E&xit', 'Enable &Accelerated Scroll', ToggleAcceleratedScroll)
UseUserAcceleratedScrollSetting()

#^a:: {
    ToggleAcceleratedScroll()
    AcceleratedScrollIndicatorFollowMouse()
}

AcceleratedScrollIndicatorFollowMouse() {
    A_WorkingDir := RegExReplace(A_LineFile, '\\[^\\]+$')
    acceleratedScrollIsOn := IniRead('lib\user-settings.ini', '', 'AcceleratedScrollIsOn')
    acceleratedScrollSetting := acceleratedScrollIsOn ? 'ON' : 'OFF'
    TemporaryFollowingToolTip("Accelerated Scroll " . acceleratedScrollSetting, -2000)
    A_WorkingDir := A_ScriptDir
}

ToggleAcceleratedScroll(name := 'Enable &Accelerated Scroll', pos := 0, menu := {}) {
    A_WorkingDir := RegExReplace(A_LineFile, '\\[^\\]+$')
    acceleratedScrollIsOn := IniRead('lib\user-settings.ini', '', 'AcceleratedScrollIsOn')
    IniWrite(not acceleratedScrollIsOn, 'lib\user-settings.ini', '', 'AcceleratedScrollIsOn')

    Hotkey('WheelDown', 'Toggle')
    Hotkey('WheelUp', 'Toggle')

    A_TrayMenu.toggleCheck(name)
    A_WorkingDir := A_ScriptDir
}

UseUserAcceleratedScrollSetting() {
    A_WorkingDir := RegExReplace(A_LineFile, '\\[^\\]+$')
    acceleratedScrollIsOn := IniRead('lib\user-settings.ini', '', 'AcceleratedScrollIsOn')
    action := acceleratedScrollIsOn ? 'On' : 'Off'
    Hotkey('WheelDown', action)
    Hotkey('WheelUp', action)

    A_TrayMenu.toggleCheck('Enable &Accelerated Scroll')
    AcceleratedScrollIndicatorFollowMouse()
    A_WorkingDir := A_ScriptDir
}
