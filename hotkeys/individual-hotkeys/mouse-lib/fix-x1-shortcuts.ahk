; For an explanation as to why these hotkeys are needed, see
; https://github.com/zachpoblete/MouseToys/wiki/Why-fix‐x1‐shortcuts.ahk-and-fix‐x2‐shortcuts.ahk-are-needed

*XButton1 Up:: return

#HotIf GetKeyState('XButton1', 'P')
    MButton::  return
    LButton::  return
    RButton::  return
    *MButton:: return
    *LButton:: return
    *RButton:: return
#HotIf
