#Include ..\mouse-functions.ahk

/**
 * Press XButton1 + MButton
 * to restore a window and move it using the mouse 🚚.
 */

#HotIf GetKeyState('XButton1', 'P')
; Enable closing tabs when using the X1+W hotkeys:
!MButton Up:: {
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('Middle')
    }
}

*MButton Up:: return
MButton Up:: MouseWinRestoreAndMove(thisHotkey)
MouseWinRestoreAndMove(thisHotkey) {
    global G_MouseIsMovingWin := true

    MouseExitIfCantBeThisHk(thisHotkey, A_PriorHotkey, '*MButton')

    ; Enable closing tabs when using the X1+W hotkeys:
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('Middle')
        return
    }

    MouseWinActivate()
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
