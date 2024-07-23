A_TrayMenu.insert('E&xit', 'Enable &MouseAltTab', ToggleMouseAltTab)
A_TrayMenu.check('Enable &MouseAltTab')

/**
 * Press XButton1 + WheelDown
 * to cycle through windows in recently used order ⬇️ (Alt+Tab).
 * Press XButton1 + WheelUp
 * to cycle through windows in reverse used order ⬆️ (Shift+Alt+Tab).
 */

XButton1 & WheelDown:: AltTab
XButton1 & WheelUp::   ShiftAltTab

ToggleMouseAltTab(name := 'Enable &MouseAltTab', pos := 0, menu := {}) {
    Hotkey('XButton1 & WheelDown', 'Toggle')
    Hotkey('XButton1 & WheelUp', 'Toggle')

    A_TrayMenu.toggleCheck('Enable &MouseAltTab')
}
