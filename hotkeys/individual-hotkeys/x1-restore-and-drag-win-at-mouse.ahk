#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk
#Include restore-and-drag-win-at-mouse-functions.ahk

; Press XButton1 + MButton
; to restore a window and move it using the mouse 🚚.
#HotIf GetKeyState('XButton1', 'P')
    MButton Up:: {
        if A_PriorKey != "MButton" {
            return
        }

        ; Don't restore and drag if the intention of activating this hotkey was actually
        ; to close a cycling window at the mouse because the because the X1+W hotkey was
        ; used.
        CloseCyclingWinAtMouse(&wasAWinClosed)
        if wasAWinClosed {
            return
        }

        RestoreAndDragWinAtMouse()
    }
#HotIf

RestoreAndDragWinAtMouse() {
    ActivateWinAtMouse()

    ; If the Desktop is active, don't proceed:
    if WinActive("ahk_class Progman ahk_exe explorer.exe") || WinActive('ahk_class WorkerW ahk_exe Explorer.EXE') {
        return
    }

    winMinMax := WinGetMinMax()
    if winMinMax = 1 {
        WinRestore()
        MoveWinMiddleToMouse()
    }

    DragWinAtMouse()
}
