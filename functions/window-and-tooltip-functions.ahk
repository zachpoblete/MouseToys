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
    if not WinActive('ahk_exe Photoshop.exe') {
        return true
    }
}

Zoom_MeetingWinExist(isVisible) {
    try {
        meetingWinPid := WinGetPid(K_CLASSES['ZOOM']['TOOLBAR'])
    } catch {
        return
    }

    winTitle := isVisible ? 'Zoom' : ''
    return WinExist(winTitle ' ahk_pid ' meetingWinPid)
}
