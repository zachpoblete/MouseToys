#Include ..\mouse-functions.ahk

A_TrayMenu.insert('E&xit', 'Enable &Accelerated Scroll', ToggleAcceleratedScroll)

UsePriorAcceleratedScrollSetting()
UsePriorAcceleratedScrollSetting() {
    A_WorkingDir := RegExReplace(A_LineFile, '\\[^\\]+$')

    Hotkey('WheelDown', (thisHotkey) => AcceleratedScroll())
    Hotkey('WheelUp', (thisHotkey) => AcceleratedScroll())

    ; Always use the window underneath:
    ; (Not related to Accelerated scroll,
    ; but you will see why we need these hotkeys here soon.)
    Hotkey('~*WheelDown', (thisHotkey) => MouseWinActivate())
    Hotkey('~*WheelUp', (thisHotkey) => MouseWinActivate())

    acceleratedScrollIsOn := IniRead('..\..\user-settings.ini', '', 'AcceleratedScrollIsOn')
    if not acceleratedScrollIsOn {
        Hotkey('WheelDown', 'Off')
        Hotkey('WheelUp', 'Off')

        ; Turn off the hotkeys that activate the window underneath
        ; because if the window were the clipboard or emoji panel,
        ; it would close them upon scrolling:
        Hotkey('~*WheelDown', 'Off')
        Hotkey('~*WheelUp', 'Off')
    }

    if acceleratedScrollIsOn {
        A_TrayMenu.check('Enable &Accelerated Scroll')
    }
    AcceleratedScrollIndicatorFollowMouse()
    
    A_WorkingDir := A_ScriptDir
}

#^a:: {
    ToggleAcceleratedScroll()
    AcceleratedScrollIndicatorFollowMouse()
}

ToggleAcceleratedScroll(name := 'Enable &Accelerated Scroll', pos := 0, menu := {}) {
    A_WorkingDir := RegExReplace(A_LineFile, '\\[^\\]+$')
    acceleratedScrollIsOn := IniRead('..\..\user-settings.ini', '', 'AcceleratedScrollIsOn')
    IniWrite(not acceleratedScrollIsOn, '..\..\user-settings.ini', '', 'AcceleratedScrollIsOn')

    Hotkey('WheelDown', 'Toggle')
    Hotkey('WheelUp', 'Toggle')

    A_TrayMenu.toggleCheck(name)
    A_WorkingDir := A_ScriptDir
}

AcceleratedScrollIndicatorFollowMouse() {
    A_WorkingDir := RegExReplace(A_LineFile, '\\[^\\]+$')
    acceleratedScrollIsOn := IniRead('..\..\user-settings.ini', '', 'AcceleratedScrollIsOn')
    acceleratedScrollSetting := acceleratedScrollIsOn ? 'ON' : 'OFF'
    TemporaryFollowingToolTip("Accelerated Scroll " . acceleratedScrollSetting, -2000)
    A_WorkingDir := A_ScriptDir
}
