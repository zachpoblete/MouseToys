#Include lib
#Include mouse-functions.ahk
#Include fix-x1.ahk

; A low A_WinDelay is very important for MouseWinRestoreAndMove to be smooth.
#Include default-settings.ahk

/**
 * Press XButton1 + MButton
 * to restore a window and move it using the mouse 🚚.
 */

#HotIf GetKeyState('XButton1', 'P')
!MButton Up:: MouseCloseWinInAltTabMenu()

; What's this hotkey for?
; *MButton Up:: return

*MButton Up:: {
    if thisHotkey and not MouseThisHkIsCorrect(thisHotkey) {
        return
    }
    ; ToolTip(thisHotkey ' and ' A_PriorHotkey)

    ; Click a window to close it when using the X1+W hotkeys:
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('Middle')
        return
    }

    MouseWinRestoreAndMove(thisHotkey)
}

MouseCloseWinInAltTabMenu() {
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('Middle')
    }
}

MouseWinRestoreAndMove(thisHotkey := "") {
    global G_MouseIsMovingWin := true

    MouseActivateWin()

    if WinActive('ahk_class WorkerW ahk_exe Explorer.EXE') {
        return
    }

    WinExist('A')
    winMinMax := WinGetMinMax()
    if winMinMax = 1 {
        WinRestore()
        moveWinMiddleToMouse()
    }

    CoordMode('Mouse')
    MouseGetPos(&mouseStartX, &mouseStartY)
    WinGetPos(&winOriginalX, &winOriginalY)

    while GetKeyState('XButton1', 'P')
            ; A loop is used instead of SetTimer to preserve the last found window.
    {
        if SubStr(A_ThisHotkey, 1, -2) = 'MButton & Wheel' {
            break
        }

        MouseGetPos(&mouseX, &mouseY)
        WinGetPos(&winX, &winY)
        WinMove(winX + (mouseX - mouseStartX), winY + (mouseY - mouseStartY))

        mouseStartX := mouseX
        mouseStartY := mouseY

        Sleep(10)
    }

    G_MouseIsMovingWin := false

    moveWinMiddleToMouse() {
        WinGetPos(, , &winW, &winH)

        CoordMode('Mouse')
        MouseGetPos(&mouseX, &mouseY)

        WinMove(mouseX - (winW / 2), mouseY - (winH / 2))
    }
}
#HotIf
