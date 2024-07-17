#HotIf WinWhereBackspaceProducesCtrlCharIsActive()
WinWhereBackspaceProducesCtrlCharIsActive() {
    if ControlClassNnFocused('A', '^Edit\d+$', true)
            or ControlClassNnFocused('ahk_exe AcroRd32.exe', '^AVL_AVView', true)
            or WinActive('ahk_exe mmc.exe') {
        return true
    }
}

^Backspace:: CtrlBackspaceUsingDelete()
/**
 * ^Backspace doesn't natively work because it produces a control character,
 * so work around that.
 */
CtrlBackspaceUsingDelete() {
    if GetSelected() {
        Send('{Delete}')
    } else {
        Send('{Ctrl Down}{Shift Down}{Left}')
        Sleep(0)
                ; For Premiere Pro.
        Send('{Shift Up}{Ctrl Up}{Delete}')
                ; Delete last word typed.
                ; Delete comes last because fsr,
                ; Photoshop doesn't delete the word unless Delete comes last
                ; even though ^+Delete will delete the word if you do it manually.
    }
}

#HotIf
