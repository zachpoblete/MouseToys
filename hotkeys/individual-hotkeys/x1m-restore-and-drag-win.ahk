#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk
#Include restore-and-drag-win-functions.ahk

#HotIf GetKeyState('XButton1', 'P')
    MButton Up:: {
        if A_PriorKey != "MButton" {
            return
        }

        RestoreAndDragWinAtMouse()
    }
#HotIf

RestoreAndDragWinAtMouse() {
    ActivateWinAtMouse()

    ; If the Desktop is active, don't proceed:
    if WinActive("ahk_class Progman ahk_exe explorer.exe") or WinActive('ahk_class WorkerW ahk_exe explorer.exe') {
        return
    }

    winMinMax := WinGetMinMax()
    if winMinMax = 1 {
        WinRestore()
        MoveWinMiddleToMouse()
    }

    DragWinAtMouse()
}
