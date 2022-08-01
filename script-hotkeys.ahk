#Include <default-settings>

#SuspendExempt
#^s:: Suspend
#SuspendExempt false

#^r:: Run '*UIAccess "' . A_ScriptName . '"'
#^p:: Pause -1
#^x:: ExitApp

#^e:: {
    if WinExist('ahk_exe Code.exe')
        WinActivate
    else
        Loop Files '*.code-workspace'
            Run A_LoopFileName
}

#^h::
    OpenDocs(thisHotkey) {
        static DIRECTORY := 'https://lexikos.github.io/v2/docs'

        if GetKeyState('CapsLock', 'T') {
            selected := GetSelected()
            if not selected
                return
            command := StrReplace(selected, '#', '_', , , 1)
            Run DIRECTORY . '/commands/' . command . '.htm'
        }
        else {
            Run DIRECTORY . '/AutoHotkey.htm'
        }
    }

#^w::
    WinSpy(thisHotkey) {
        static WIN_SPY := 'Window Spy ahk_class AutoHotkeyGUI'
        
        try {
            minMax := WinGetMinMax(WIN_SPY)
        }
        catch TargetError {
            Run 'WindowSpy.ahk', A_ProgramFiles . '\AutoHotkey'
            return
        }

        if minMax = -1 {
            WinActive 'A'
            WinActivate WIN_SPY
            WinActivate
        }
        else {
            WinClose WIN_SPY
        }
    }
