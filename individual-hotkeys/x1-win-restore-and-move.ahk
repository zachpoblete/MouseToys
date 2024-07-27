#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

; A low A_WinDelay is very important for MouseWinRestoreAndMove to be smooth.
#Include default-settings.ahk

; Press XButton1 + MButton
; to restore a window and move it using the mouse 🚚.
#HotIf GetKeyState('XButton1', 'P')
!MButton Up:: MouseWinCloseInAltTabMenu()

MButton Up:: {
    if thisHotkey and not MouseIsThisHotkeyCorrect(thisHotkey) {
        return
    }

    if MouseWinCloseInAltTabMenu() {
        return
    }

    MouseWinRestoreAndMove(thisHotkey)
}

MouseWinCloseInAltTabMenu() {
    wasAWinClosed := false
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('Middle')
        wasAWinClosed := true
    }
    return wasAWinClosed
}

MouseWinRestoreAndMove(thisHotkey := "") {
    MouseWinActivate()
    if WinActive('ahk_class WorkerW ahk_exe Explorer.EXE') {
        return
    }

    WinExist('A')
    winMinMax := WinGetMinMax()
    if winMinMax = 1 {
        WinRestore()
        MouseWinMoveMiddle()
    }

    MouseWinMove()
}
#HotIf

MouseWinIsStillRestored() {
    a_thisHotkeyNoDirection := SubStr(A_ThisHotkey, 1, -2)
    return a_thisHotkeyNoDirection != 'MButton & Wheel'
}

MouseWinMoveMiddle() {
    CoordMode('Mouse', "Screen")
    MouseGetPos(&mouseX, &mouseY)

    WinGetPos(, , &winWidth, &winHeight)
    winHalfWidth  := winWidth / 2
    winHalfHeight := winHeight / 2

    winX := mouseX - winHalfWidth
    winY := mouseY - winHalfHeight
    WinMove(winX, winY)
}

MouseWinMove() {
    CoordMode('Mouse', "Screen")
    MouseGetPos(&mouseStartX, &mouseStartY)
    global MouseWinIsMoving := true

    ; Enable *thread* per-monitor DPI awareness for windows that are per-monitor DPI
    ; aware so that the system doesn't try to automatically rescale them when moving
    ; across monitors with different DPI settings because these per-monitor DPI
    ; aware windows can already do that themselves. See
    ; https://www.autohotkey.com/docs/v2/misc/DPIScaling.htm
    hwnd := WinActive()
    winDpiAwarenessContext := DllCall("GetWindowDpiAwarenessContext", "ptr", hwnd, "ptr")
    isWinPerMonitorDpiAware :=
           DllCall("AreDpiAwarenessContextsEqual", "ptr", winDpiAwarenessContext, "ptr", -3)
        or DllCall("AreDpiAwarenessContextsEqual", "ptr", winDpiAwarenessContext, "ptr", -4)
    if isWinPerMonitorDpiAware {
        oldThreadDpiAwarenessContext := DllCall("GetThreadDpiAwarenessContext", "ptr")
        DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
    }

    while GetKeyState('XButton1', 'P') and MouseWinIsStillRestored()
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
    if isWinPerMonitorDpiAware {
        DllCall("SetThreadDpiAwarenessContext", "ptr", oldThreadDpiAwarenessContext, "ptr")
    }
}
