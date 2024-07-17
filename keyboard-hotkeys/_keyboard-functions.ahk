/**
 * Display ToolTip while NumLock is on.
 */
NumLockIndicatorFollowMouse() {
    Sleep(10)

    if GetKeyState('NumLock', 'T') {
        SetTimer(toolTipNumLock, 10)
    } else {
        SetTimer(toolTipNumLock, 0)
        ToolTip()
    }

    toolTipNumLock() => ToolTip('NumLock On')
}

VimcCmd(num) {
    if num > 24 {
        Send('!{F' (num - 12) '}')
    } else if num > 16 {
        Send('^{F' (num - 4) '}')
    } else if num > 8 {
        Send('+{F' (num + 4) '}')
    } else {
        Send('{F' (num + 12) '}')
    }
}
