#Include <default-settings>
#Include <constants>
#Include <functions>

#SuspendExempt
/**
 * Suspend.
 */
#^s:: {
    Suspend()

    DetectHiddenWindows(true)

    if WinExist('ahk_exe brightness-setter.exe') {
        SendMessage(K_WIN32_CONSTS['WM_COMMAND'], K_CONTROL_CODES['TRAY']['SUSPEND'])
    }
}
#SuspendExempt false

/**
 * Reload.
 */
#^r:: {
    global G_WillReload := true
    Run('*UIAccess "' A_ScriptName '"')
}

#^p:: Pause(-1)
#^x:: ExitApp()

/**
 * Edit.
 */
#^e:: {
    Loop Files '*.code-workspace' {
        Run(A_LoopFileName)
    }
}

#^h:: Run('https://lexikos.github.io/v2/docs/AutoHotkey.htm')

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
