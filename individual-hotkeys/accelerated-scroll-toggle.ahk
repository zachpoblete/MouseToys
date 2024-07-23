#Include accelerated-scroll-main.ahk

#Include lib
#Include mouse-functions.ahk

A_TrayMenu.insert('E&xit', 'Enable &Accelerated Scroll', ToggleAcceleratedScroll)
UseUserAcceleratedScrollSetting()
AcceleratedScrollIndicatorFollowMouse()

#^a:: {
    ToggleAcceleratedScroll()
    AcceleratedScrollIndicatorFollowMouse()
}

AcceleratedScrollIndicatorFollowMouse() {
    static acceleratedScrollSetting

    A_WorkingDir := RegExReplace(A_LineFile, '\\[^\\]+$')
    acceleratedScrollIsOn := IniRead('lib\user-settings.ini', '', 'AcceleratedScrollIsOn')
    acceleratedScrollSetting := acceleratedScrollIsOn ? 'ON' : 'OFF'

    SetTimer(tempToolTip, 0)
    SetTimer(tempToolTip, 10)
    SetTimer(closeTempToolTip, -3000)

    A_WorkingDir := A_ScriptDir

    ; Make tempToolTip static so that it doesn't flicker upon toggling quickly.
    static tempToolTip() {
        ToolTip('Accelerated Scroll ' acceleratedScrollSetting)
    }

    closeTempToolTip() {
        SetTimer(tempToolTip, 0)
        ToolTip()
    }
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
    A_WorkingDir := A_ScriptDir
}
