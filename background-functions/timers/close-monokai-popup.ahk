#Include ..\..\functions\_functions.ahk

CloseMonokaiPopup() {
    static _monokaiMsg :=
    (Join`r`n
        '[Window Title]
        Visual Studio Code

        [Content]
        Thank you for evaluating Monokai Pro. Please purchase a license for extended use.

        [OK] [Cancel]'
    )

    if not WinExist('Visual Studio Code ahk_class #32770 ahk_exe Code.exe')
            ; VS Code still needs to be active fsr.
    {
        return
    }

    WinActivate()

    activeMsg := GetSelected()
    if activeMsg != _monokaiMsg {
        return
    }
    WinClose()
}
