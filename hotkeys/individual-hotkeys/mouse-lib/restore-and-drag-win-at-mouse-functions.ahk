IsWinAtMouseStillRestored() {
    try {
        winMinMax := WinGetMinMax()
    } catch {
        return false
    }
    if winMinMax {
        return false
    }

    return true
}

IsWinPerMonitorDpiAware(hwnd) {
    winDpiAwarenessContext := DllCall("GetWindowDpiAwarenessContext", "ptr", hwnd, "ptr")
    return (
        DllCall("AreDpiAwarenessContextsEqual", "ptr", winDpiAwarenessContext, "ptr", -3)
        or DllCall("AreDpiAwarenessContextsEqual", "ptr", winDpiAwarenessContext, "ptr", -4)
    )
}

MoveWinMiddleToMouse() {
    CoordMode('Mouse', "Screen")
    MouseGetPos(&mouseX, &mouseY)

    WinGetPos(, , &winWidth, &winHeight)
    winHalfWidth  := winWidth / 2
    winHalfHeight := winHeight / 2

    winX := mouseX - winHalfWidth
    winY := mouseY - winHalfHeight
    WinMove(winX, winY)
}

DragWinAtMouse() {
    CoordMode('Mouse', "Screen")
    MouseGetPos(&mouseStartX, &mouseStartY)
    global MouseWinIsMoving := true

    ; Enable *thread* per-monitor DPI awareness for windows that are per-monitor DPI
    ; aware so that the system doesn't try to automatically rescale them when moving
    ; across monitors with different DPI settings because these per-monitor DPI
    ; aware windows can already do that themselves. See
    ; https://www.autohotkey.com/docs/v2/misc/DPIScaling.htm
    ; For an explanation of the -3 (and -4) arguments, see
    ; https://learn.microsoft.com/en-us/windows/win32/hidpi/dpi-awareness-context
    existingHwnd := WinExist()
    winIsPerMonitorDpiAware := IsWinPerMonitorDpiAware(existingHwnd)
    if winIsPerMonitorDpiAware {
        oldThreadDpiAwarenessContext := DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
    }

    while GetKeyState('XButton1', 'P') and IsWinAtMouseStillRestored()
            ; A loop is used instead of SetTimer to preserve the last found window.
    {
        WinGetPos(&winX, &winY)
        MouseGetPos(&mouseX, &mouseY)
        changeInMouseX := mouseX - mouseStartX
        changeInMouseY := mouseY - mouseStartY
        winX += changeInMouseX
        winY += changeInMouseY
        WinMove(winX, winY)

        mouseStartX := mouseX
        mouseStartY := mouseY
        Sleep(10)
    }

    MouseWinIsMoving := false
    if winIsPerMonitorDpiAware {
        DllCall("SetThreadDpiAwarenessContext", "ptr", oldThreadDpiAwarenessContext, "ptr")
    }
}
