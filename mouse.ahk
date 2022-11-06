#Include <default-settings>
#Include <constants>
#Include <functions>
#Include <classes>

;= =============================================================================
;= Touchpad
;= =============================================================================

#LButton::  Click('R')
#!LButton:: Click('M')

;= =============================================================================
;= Wheel + Native Modifiers
;= =============================================================================

WheelUp::
WheelDown:: {
    AcceleratedScroll()
}

~^WheelUp::
~^WheelDown:: {
    MouseWinActivate()
}

;= =============================================================================
;= RButton
;= =============================================================================

;== ============================================================================
;== Wheel
;== ============================================================================

RButton & WheelDown:: AltTab
RButton & WheelUp::   ShiftAltTab

;== ============================================================================
;== LButton
;== ============================================================================

/**
 * Delete.
 */
RButton & LButton:: {
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click()
        return
    }
    if GetKeyState('Shift', 'P') {
        Send('{Shift Down}{Del}{Shift Up}')
    } else {
        Send('{Del}')
    }
}

;== ============================================================================
;== MButton
;== ============================================================================

/**
 * Click link,
 * open it in a new tab,
 * and switch to that tab.
 */
RButton & MButton:: {
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('M')
        return
    }
    Send('{Ctrl Down}{Shift Down}{Click}{Shift Up}{Ctrl Up}')
}

;== ============================================================================
;== None
;== ============================================================================

RButton:: Click('R')

;= =============================================================================
;= MButton
;= =============================================================================

;== ============================================================================
;== Wheel
;== ============================================================================

MButton & WheelUp::
MouseWinMaximize(thisHotkey) {
    MouseWinActivate()
    WinMaximize('A')
}

MButton & WheelDown::
MouseWinMinimizeOrRestore(ThisHotkey) {
    MouseWinActivate()
    if WinActive(K_CLASSES['ZOOM']['WAIT_HOST']) or WinActive(K_CLASSES['ZOOM']['VID_PREVIEW']) {
        WinMinimize()
        return
    }
    winMinMax := WinGetMinMax()

    if winMinMax {
        WinRestore()
    } else {
        WinMinimize()
    }
}

;== ============================================================================
;== RButton
;== ============================================================================

MButton & RButton::
MouseWinMove(thisHotkey) {
    MouseWinActivate()

    if WinActive('ahk_class WorkerW ahk_exe Explorer.EXE') {
        return
    }
    WinExist('A')
    
    winMinMax := WinGetMinMax()

    if winMinMax = 1 {
        WinRestore()
    }
    CoordMode('Mouse')
    MouseGetPos(&mouseStartX, &mouseStartY)
    WinGetPos(&winOriginalX, &winOriginalY)

    while GetKeyState('MButton', 'P') {
            ; A loop is used instead of SetTimer to preserve the last found window.
        if GetKeyState('Esc', 'P') {
            WinMove(winOriginalX, winOriginalY)
            break
        }
        switch A_ThisHotkey {
        case 'WheelUp':
            MouseWinMaximize(thisHotkey)
            break
        case 'WheelDown':
            MouseWinMinimizeOrRestore(thisHotkey)
            break
        }
        MouseGetPos(&mouseX, &mouseY)
        WinGetPos(&winX, &winY)
        WinMove(winX + (mouseX - mouseStartX), winY + (mouseY - mouseStartY))

        mouseStartX := mouseX
        mouseStartY := mouseY

        Sleep(10)
    }
}

;== ============================================================================
;== None
;== ============================================================================

/**
 * Click link,
 * and open it in a new tab.
 */
MButton:: {
    MouseWinActivate()

    if WinActive(K_CLASSES['ZOOM']['MEETING']) {
        Send('{LWin Down}{Alt Down}{PrintScreen}{Alt Up}{LWin Up}')
    } else if WinActive('AutoHotkey Community ahk_exe msedge.exe')
            or WinActive.bind('ahk_exe .EXE$').setWinModeAndCall('RegEx') {
                    ; Check if an Office app is active.
        Send('{Ctrl Down}{Click}{Ctrl Up}')
    } else {
        Click('M')
    }
}

;= =============================================================================
;= XButton1
;= =============================================================================

;== ============================================================================
;== Wheel
;== ============================================================================

#HotIf MouseWinActivate('ahk_exe msedge.exe')
/**
 * Search tabs.
 */
XButton1 & WheelDown:: {
    if GetKeyState('Ctrl') {
        Send('{Ctrl Up}')
    }
    Send('{Ctrl Down}{Shift Down}a{Shift Up}{Ctrl Up}')
}
XButton1 & WheelUp:: Send('{Esc}')

#HotIf WinActive('ahk_exe AcroRd32.exe')
XButton1 & WheelDown:: Send('{Ctrl Down}{PgDn}{Ctrl Up}')
        ; Jump one page down.
XButton1 & WheelUp::   Send('{Ctrl Down}{PgUp}{Ctrl Up}')
        ; Jump one page up.

#HotIf
C_Hotkey.ctrlTab('XButton1 & WheelDown', false)
C_Hotkey.ctrlTab('XButton1 & WheelUp', true)

;== ============================================================================
;== LButton and RButton
;== ============================================================================

XButton1 & LButton:: X1LR('[', 'X1')
        ; Go back.
XButton1 & RButton:: X1LR(']', 'X2')
        ; Go forward.

X1LR(states*) {
    MouseWinActivate()

    if WinActive('ahk_exe Notion.exe') {
        Send('{Ctrl Down}' states[1] '{Ctrl Up}')
    } else {
        Click(states[-1])
    }
}

;== ============================================================================
;== MButton
;== ============================================================================

XButton1 & MButton::
MouseWinReload(thisHotkey) {
    MouseWinActivate()
    Send('{F5}')
}

;= =============================================================================
;= XButton2
;= =============================================================================

;== ============================================================================
;== Wheel
;== ============================================================================

XButton2 & WheelDown:: X2W('{Down}', '{PgDn}', '{Tab}',                       '{PgDn}')
        ; Switch to next tab.
XButton2 & WheelUp::   X2W('{Up}',   '{PgUp}', '{Shift Down}{Tab}{Shift Up}', '{PgUp}')
        ; Switch to previous tab.

X2W(states*) {
    MouseWinActivate()

    if WinActive('ahk_exe Discord.exe') or WinActive('ahk_exe Messenger.exe') {
        Send('{Alt Down}' states[1] '{Alt Up}')
    } else if WinActive('ahk_exe POWERPNT.EXE') {
        Send(states[2])
    } else if WinActive('ahk_exe AcroRd32.exe') or WinActive('ahk_exe WindowsTerminal.exe') {
        Send('{Ctrl Down}' states[3] '{Ctrl Up}')
    } else {
        Send('{Ctrl Down}' states[-1] '{Ctrl Up}')
    }
}

;== ============================================================================
;== LButton and RButton
;== ============================================================================

XButton2 & LButton:: {
    MouseWinActivate()
    Send('{Ctrl Down}{Shift Down}t{Shift Up}{Ctrl Up}')
            ; Reopen last closed tab,
            ; and switch to it.
}
XButton2 & RButton:: {
    MouseWinActivate()
    
    if WinActive('ahk_exe Notion.exe') {
        return
    } else {
        Send('{Ctrl Down}w{Ctrl Up}')
                ; Close current tab.
    }
}

;== ============================================================================
;== MButton
;== ============================================================================

XButton2 & MButton::
MouseWinClose(thisHotkey) {
    MouseWinActivate()

    if WinActive(K_CLASSES['ZOOM']['MEETING']) {
        Send('{Alt Down}q{Alt Up}')
                ; Show 'End Meeting or Leave Meeting?' prompt in the middle of the screen
                ; instead of the corner of the window.
    } else if WinActive(K_CLASSES['ZOOM']['HOME']) {
        if WinExist('Zoom ahk_pid ' WinGetPid.tryCall(K_CLASSES['ZOOM']['TOOLBAR'])) {
                ; Check if a visible Zoom meeting window exists.
            ControlSend('{Alt Down}q{Alt Up}', , K_CLASSES['ZOOM']['MEETING'])
        } else {
            ProcessClose('Zoom.exe')
        }
    } else if WinActive('ahk_exe PowerToys.Settings.exe') {
        WinClose()
    } else {
        Send('{Alt Down}{F4}{Alt Up}')
    }
}
