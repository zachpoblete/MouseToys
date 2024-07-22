TemporaryFollowingToolTip(text, duration) {
    tt() => ToolTip(text)
    SetTimer(tt, 10)
    SetTimer(turnOff, -Abs(duration))
    turnOff() {
        SetTimer(tt, 0)
        ToolTip()
    }
}

CanRedoWithCtrlY() {
    return not WinActive('ahk_exe Photoshop.exe')
}
