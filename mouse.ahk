#Include <default-settings>
#Include <constants>
#Include <functions>
#Include <classes>
#Include <accelerated-scroll>

;====================================================================================================
; Wheel + Native Modifiers
;====================================================================================================

WheelUp::
WheelDown:: {
    AcceleratedScroll()
}

~^WheelUp::
~^WheelDown:: {
    MouseWinActivate()
}

;====================================================================================================
; RButton
;====================================================================================================

RButton & WheelDown:: AltTab
RButton & WheelUp::   ShiftAltTab

RButton & LButton:: {
    if GetKeyState('Shift', 'P') {
        Send('{Shift Down}{Del}{Shift Up}')
    } else if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click()
    } else {
        Send('{Del}')
    }
}

RButton & MButton:: {
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('M')
    }
}

RButton:: Click('R')

;====================================================================================================
; MButton
;====================================================================================================

MButton & WheelUp:: {
    MouseWinActivate()
    WinMaximize('A')
}

MButton & WheelDown:: {
    if MouseWinActivate(CLASSES['ZOOM']['WAIT_HOST']) or WinActive(CLASSES['ZOOM']['VID_PREVIEW']) {
        WinMinimize()
    } else {
        Send('{LWin Down}{Down}{LWin Up}')
    }
}

MButton & RButton:: Send('{Ctrl Down}{Shift Down}{Click}{Shift Up}{Ctrl Up}')

MButton:: {
    if MouseWinActivate(CLASSES['ZOOM']['MEETING']) {
        Send('{LWin Down}{Alt Down}{PrintScreen}{Alt Up}{LWin Up}')
    } else if WinActive('AutoHotkey Community ahk_exe msedge.exe') or WinActive.bind('ahk_exe .EXE$').setWinModeAndCall('RegEx') {  ; Check if an Office app is active.
        Send('{Ctrl Down}{Click}{Ctrl Up}')
    } else {
        Click('M')
    }
}

;====================================================================================================
; XButton1
;====================================================================================================

#HotIf MouseWinActivate('ahk_exe msedge.exe')
XButton1 & WheelDown:: {
    if GetKeyState('Ctrl') {
        Send('{Ctrl Up}')
    }
    Send('{Ctrl Down}{Shift Down}a{Shift Up}{Ctrl Up}')
}
XButton1 & WheelUp:: Send('{Esc}')

#HotIf WinActive('ahk_exe AcroRd32.exe')
XButton1 & WheelDown:: Send('{Ctrl Down}{PgDn}{Ctrl Up}')
XButton1 & WheelUp::   Send('{Ctrl Down}{PgUp}{Ctrl Up}')

#HotIf
C_Hotkey.ctrlTab('XButton1 & WheelDown', false)
C_Hotkey.ctrlTab('XButton1 & WheelUp', true)

XButton1 & LButton:: X1LR('[', 'X1')
XButton1 & RButton:: X1LR(']', 'X2')

X1LR(states*) {
    if MouseWinActivate('ahk_exe Notion.exe') {
        Send('{Ctrl Down}' states[1] '{Ctrl Up}')
    } else {
        Click(states[-1])
    }
}

XButton1 & MButton:: {
    MouseWinActivate()
    Send('{F5}')
}

;====================================================================================================
; XButton2
;====================================================================================================

XButton2 & WheelDown:: X2DU('{Down}', '{PgDn}', '{Tab}',                       '{PgDn}')
XButton2 & WheelUp::   X2DU('{Up}',   '{PgUp}', '{Shift Down}{Tab}{Shift Up}', '{PgUp}')

X2DU(states*) {
    if MouseWinActivate('ahk_exe Discord.exe') or WinActive('ahk_exe Messenger.exe') {
        Send('{Alt Down}' states[1] '{Alt Up}')
    } else if WinActive('ahk_exe POWERPNT.EXE') {
        Send(states[2])
    } else if WinActive('ahk_exe AcroRd32.exe') or WinActive('ahk_exe WindowsTerminal.exe') {
        Send('{Ctrl Down}' states[3] '{Ctrl Up}')
    } else {
        Send('{Ctrl Down}' states[-1] '{Ctrl Up}')
    }
}

XButton2 & LButton:: X2LR('{Shift Down}t{Shift Up}')
XButton2 & RButton:: X2LR('w')

X2LR(states*) {
    MouseWinActivate()
    Send('{Ctrl Down}' states[-1] '{Ctrl Up}')
}

XButton2 & MButton:: {
    if MouseWinActivate(CLASSES['ZOOM']['MEETING']) {
        Send('{Alt Down}q{Alt Up}')  ; Show 'End Meeting or Leave Meeting?' prompt in the middle of the screen instead of the corner of the window.
    } else if WinActive(CLASSES['ZOOM']['HOME']) {
        if WinExist('Zoom ahk_pid ' WinGetPid.tryCall(CLASSES['ZOOM']['TOOLBAR'])) {  ; Check if a visible Zoom meeting window exists.
            ControlSend('{Alt Down}q{Alt Up}', , CLASSES['ZOOM']['MEETING'])
        } else {
            ProcessClose('Zoom.exe')
        }
    } else if WinActive('ahk_exe PowerToys.Settings.exe') {
        WinClose()
    } else {
        Send('{Alt Down}{F4}{Alt Up}')
    }
}
