; For an explanation as to why these hotkeys are needed, see
; https://github.com/zachpoblete/MouseToys/wiki/Why-fix‐x1‐shortcuts.ahk-and-fix‐x2‐shortcuts.ahk-are-needed

*XButton2 Up:: {
    if A_PriorKey != "XButton2" {
        return
    }
    Click("X2")
}

#HotIf GetKeyState('XButton2', 'P')
    MButton:: return
    LButton:: return
    RButton:: return
#HotIf
