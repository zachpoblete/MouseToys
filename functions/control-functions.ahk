ControlClassNnFocused(winTitle := '', controlClassNn := '', useRegEx := false) {
    try {
        focusedControlHwnd    := ControlGetFocus(winTitle)
        focusedControlClassNn := ControlGetClassNn(focusedControlHwnd)
    } catch {
        return
    }

    if not controlClassNn {
        return focusedControlClassNn
    }
    
    if not useRegEx and (focusedControlClassNn != controlClassNn) {
        return
    } else if not RegExMatch(focusedControlClassNn, controlClassNn) {
        return
    }

    return focusedControlClassNn
}

ControlGetHwndFromClassNnAndTextElseExit(controlClassNn, controlText) {
    try {
        controlHwnd := ControlGetHwnd(controlClassNn)
    } catch {
        exit
    }

    controlTextFromClassNn := ControlGetText(controlClassNn)
    if controlText != controlTextFromClassNn {
        exit
    }

    return controlHwnd
}
