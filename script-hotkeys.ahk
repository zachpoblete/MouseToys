#Include <default-settings>

#SuspendExempt
#^s:: Suspend()
#SuspendExempt false

#^r:: Run('*UIAccess "' A_ScriptName '"')
#^p:: Pause(-1)
#^x:: ExitApp()

#^e:: {  ; Edit.
    if WinExist('ahk_exe Code.exe') {
        WinActivate()
    } else {
        Loop Files '*.code-workspace' {
            Run(A_LoopFileName)
        }
    }
}

#^h::
    OpenDocs(thisHotkey) {
        docs := 'https://lexikos.github.io/v2/docs/AutoHotkey.htm'

        if GetKeyState('CapsLock', 'T') {
            selected := GetSelectedElseExit()
            command := StrReplace(selected, '#', '_', , , 1)
            docs := StrReplace(docs, 'AutoHotkey', 'commands/' command)
        }

        Run(docs)
    }

#^w::
    WinSpy(thisHotkey) {
        static WIN_SPY := 'Window Spy ahk_class AutoHotkeyGUI'

        try {
            minMax := WinGetMinMax(WIN_SPY)
        } catch TargetError {
            Run('WindowSpy.ahk', A_ProgramFiles '\AutoHotkey')
        } else if minMax = -1 {
            WinExist('A')
            WinActivate(WIN_SPY)
            WinActivate()
        } else {
            WinClose(WIN_SPY)
        }
    }
