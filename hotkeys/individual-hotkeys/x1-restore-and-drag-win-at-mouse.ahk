#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1.ahk
#Include restore-and-drag-win-at-mouse-functions.ahk

; Press XButton1 + MButton
; to restore a window and move it using the mouse 🚚.
#HotIf GetKeyState('XButton1', 'P')
    MButton Up:: {
        if not IsThisMouseHotkeyCorrect(thisHotkey) {
            return
        }

        if CloseCyclingWinAtMouse() {
            return
        }

        RestoreAndDragWinAtMouse(thisHotkey)
    }
#HotIf

RestoreAndDragWinAtMouse(thisHotkey := "") {
    ActivateWinAtMouse()
    if WinActive('ahk_class WorkerW ahk_exe Explorer.EXE') {
        return
    }

    WinExist('A')
    winMinMax := WinGetMinMax()
    if winMinMax = 1 {
        WinRestore()
        MoveWinMiddleToMouse()
    }

    DragWinAtMouse()
}
