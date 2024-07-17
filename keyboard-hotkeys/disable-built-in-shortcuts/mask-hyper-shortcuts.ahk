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
