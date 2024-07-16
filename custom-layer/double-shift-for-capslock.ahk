<+RShift::
>+LShift::
{
    ; Prevent a combination like LShift+f+RShift
    ; from triggering this hotkey:
    if SubStr(A_PriorKey, 2) != 'Shift' {
        return
    }

    capsLockState := GetKeyState('CapsLock', 'T')
    SetCapsLockState(not capsLockState)
    Send('{Blind}{LShift Up}{RShift Up}')
}

