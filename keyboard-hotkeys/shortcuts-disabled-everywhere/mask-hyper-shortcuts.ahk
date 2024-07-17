A_MenuMaskKey := 'vkFF'

loop parse 'abcefghijklmnopqrstuvwxyz' {
    Hotkey('#^+!' A_LoopField, (ThisHotkey) => '')
}

#^+Alt::
#^!Shift::
#+!Ctrl::
^+!LWin::
^+!RWin::
{
    MaskMenu()
}

MaskMenu() {
    Send('{Blind}{' A_MenuMaskKey '}')
            ; No mapping.
}
