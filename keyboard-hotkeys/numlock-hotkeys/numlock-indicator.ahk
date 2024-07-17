CreateFollowingNumLockIndicator()
^CapsLock:: {
    ToggleNumLock()
    CreateFollowingNumLockIndicator()
}

ToggleNumLock() {
    numLockState := GetKeyState('NumLock', 'T')
    SetNumLockState(not numLockState)
}

/**
 * Display ToolTip while NumLock is on.
 */
CreateFollowingNumLockIndicator() {
    Sleep(10)

    if GetKeyState('NumLock', 'T') {
        SetTimer(toolTipNumLock, 10)
    } else {
        SetTimer(toolTipNumLock, 0)
        ToolTip()
    }

    toolTipNumLock() => ToolTip('NumLock On')
}
