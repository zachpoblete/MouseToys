; For an explanation as to why these hotkeys are needed, see
; https://github.com/zachpoblete/MouseToys/wiki/Why-fix‐x1‐shortcuts.ahk-and-fix‐x2‐shortcuts.ahk-are-needed

*XButton1 Up:: {
    if A_PriorKey != "XButton1" {
        return
    }
    Click("X1")
}

#HotIf GetKeyState('XButton1', 'P')
    *LButton:: return
    MButton::  return
    RButton::  return
#HotIf
