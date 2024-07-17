NumLockIndicatorFollowMouse()
^CapsLock:: {
    numLockState := GetKeyState('NumLock', 'T')
    SetNumLockState(not numLockState)
    NumLockIndicatorFollowMouse()
}
