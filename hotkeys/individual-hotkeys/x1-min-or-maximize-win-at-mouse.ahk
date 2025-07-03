#Include ahk-utils
#Include default-settings.ahk

#Include ..\mouse-lib
#Include mouse-globals.ahk
#Include mouse-functions.ahk
#Include fix-x1-shortcuts.ahk

; Press XButton1 + MButton + WheelDown
; to minimize a window ↙️.
; Press XButton1 + MButton + WheelUp
; to maximize a window ↗.
#HotIf GetKeyState('XButton1', 'P')
    MButton & WheelDown:: MinimizeWinAtMouse()
    MButton & WheelUp::   MaximizeWinAtMouse()
#HotIf

MinimizeWinAtMouse() {
    if MouseWinIsMoving {
        WinExist('A')
    } else {
        ActivateWinAtMouse()
    }

    ; If the Desktop is active, don't proceed because there will be buggy behavior.
    if WinActive('ahk_class WorkerW ahk_exe explorer.exe') || WinActive("ahk_class Progman ahk_exe explorer.exe") {
        return
    }

    WinMinimize()
}

MaximizeWinAtMouse() {
    if MouseWinIsMoving {
        WinExist('A')
    } else {
        ActivateWinAtMouse()
    }

    ; If the Desktop is active, don't proceed because there will be buggy behavior.
    if WinActive('ahk_class WorkerW ahk_exe explorer.exe') || WinActive("ahk_class Progman ahk_exe explorer.exe") {
        return
    }

    winMinMax := WinGetMinMax()

    if winMinMax = 0 {
        WinMaximize()
        return
    }

    ; This means winMinMax = 1, and the window should already by maximized. But
    ; sometimes, for some reason, when waking up my laptop from sleep, a window that
    ; was previously maximized on my 2nd screen becomes smaller. (Specifically, I
    ; think it becomes the size of a maximized window on my smaller laptop screen.)
    ; But the window still remains on my 2nd scren and thinks it's maximized. This
    ; is reflected by the maximize/restore button showing the icon for restore, not
    ; maximize. When clicking the restore button, the window is restored relative to
    ; the 2nd screen. (Weirdly, I checked, and the monitor the window thinks it
    ; belongs to is correct.)

    ; This AHK forum post describes a similar issue:
    ; https://www.autohotkey.com/boards/viewtopic.php?t=46033
    ; But the way they reproduce the issue is different, and it seems all their
    ; windows becomes smaller. Whereas I can't even consistently reproduce my issue
    ; and I've so far seen only 1-2 windows become smaller after waking up my
    ; laptop.

    ; I've tried to WinMaximize the window, but it doesn't do anything. The docs
    ; recommends PostMessage(0x0112, 0xF030) if WinMaximize doesn't work, but the
    ; PostMessage hasn't been any more effective. (PostMessage is recommended by
    ; https://www.autohotkey.com/docs/v2/lib/WinMaximize.htm#Remarks)

    ; What we'll do instead is WinRestore first then WinMaximize. But using
    ; WinRestore right before WinMaximize on a maximized window is jarring, so we
    ; only want to WinRestore if necessary. So we'll manually check if the window is
    ; actually maximized for the monitor:

    activeWin := WinExist("A")
    activeMonitor := DllCall("MonitorFromWindow", "Ptr", activeWin, "UInt", 0x2)
    activeMonitorInfo := Buffer(40)
    NumPut("UInt", 40, activeMonitorInfo)
    ; For more info on GetMonitorInfo, see
    ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getmonitorinfoa#remarks
    DllCall("GetMonitorInfo", "Ptr", activeMonitor, "Ptr", activeMonitorInfo)
    workLeft   := NumGet(activeMonitorInfo, 20, "Int")
    workRight  := NumGet(activeMonitorInfo, 28, "Int")
    workTop    := NumGet(activeMonitorInfo, 24, "Int")
    workBottom := NumGet(activeMonitorInfo, 32, "Int")

    workWidth := workRight - workLeft
    workHeight := workBottom - workTop
    WinGetPos(, , &winWidth, &winHeight)

    ; It's normal for the dimensions of a maximized window to exceed the dimensions
    ; of the monitor. See https://www.autohotkey.com/boards/viewtopic.php?t=32628
    ; For example, winWidth is 1936, but monitorRight and workRight are both 1920.
    if (winWidth >= workWidth) and (winHeight >= workHeight) {
        ; The window correctly thinks it's maximized.
        return
    }


    ; Best solution I've come up with:
    WinRestore()
    WinMaximize()
}
