#SuspendExempt
#^s:: Suspend()
#SuspendExempt false

/**
 * Reload.
 */
#^r:: Run('meta-launcher.ahk')

#^p:: Pause(-1)
#^x:: ExitApp()

/**
 * Edit.
 */
#^e:: {
    loop files '*.code-workspace' {
        Run(A_LoopFileName)
    }
}

#^h:: Run('https://www.autohotkey.com/docs/v2/')

#^w:: WinSpy()
WinSpy() {
    static WIN_SPY := 'Window Spy ahk_class AutoHotkeyGUI'

    try {
        minMax := WinGetMinMax(WIN_SPY)
    } catch {
        Run('WindowSpy.ahk', A_ProgramFiles '\AutoHotkey')
    } else if minMax = -1 {
        WinExist('A')
        WinActivate(WIN_SPY)
        WinActivate()
    } else {
        WinClose(WIN_SPY)
    }
}
