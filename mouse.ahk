#Include <default-settings>
#Include <constants>
#Include <functions>
#Include <accelerated-scroll>

; Disclaimer: Some mice don't do the 3-button combination hotkeys well.

;= =============================================================================
;= WD & WU / Accelerated scroll
;= =============================================================================

A_TrayMenu.insert('E&xit', 'Enable &Accelerated Scroll', ToggleAcceleratedScroll)

UsePriorAcceleratedScrollSetting()
UsePriorAcceleratedScrollSetting() {
    acceleratedScrollIsOn := IniRead('lib\user-settings.ini', '', 'AcceleratedScrollIsOn')
    action := acceleratedScrollIsOn ? 'On' : 'Off'

    Hotkey('WheelDown', action)
    Hotkey('WheelUp', action)

    if acceleratedScrollIsOn {
        A_TrayMenu.check('Enable &Accelerated Scroll')
    }
    AcceleratedScrollIndicatorFollowMouse()
}

; Do not use ~*WheelUp and ~*WheelDown.
; You just don't need it there;
; sends too many commands.
WheelDown::
WheelUp::
{
    AcceleratedScroll()
}

#^a:: {
    ToggleAcceleratedScroll()
    AcceleratedScrollIndicatorFollowMouse()
}

ToggleAcceleratedScroll(name := 'Enable &Accelerated Scroll', pos := 0, menu := {}) {
    acceleratedScrollIsOn := IniRead('lib\user-settings.ini', '', 'AcceleratedScrollIsOn')
    IniWrite(not acceleratedScrollIsOn, 'lib\user-settings.ini', '', 'AcceleratedScrollIsOn')

    Hotkey('WheelDown', 'Toggle')
    Hotkey('WheelUp', 'Toggle')

    A_TrayMenu.toggleCheck(name)
}

AcceleratedScrollIndicatorFollowMouse() {
    SetTimer(toolTipAcceleratedScroll, 10)
    SetTimer(closeAcceleratedScrollIndicator, -3000)

    closeAcceleratedScrollIndicator() {
        SetTimer(toolTipAcceleratedScroll, 0)
        ToolTip()
    }
    
    toolTipAcceleratedScroll() {
        acceleratedScrollIsOn := IniRead('lib\user-settings.ini', '', 'AcceleratedScrollIsOn')
        acceleratedScrollSetting := acceleratedScrollIsOn ? 'ON' : 'OFF'
        ToolTip('Accelerated Scroll ' acceleratedScrollSetting)
    }
}

;= =============================================================================
;= XButton1 / Window and typing shortcuts
;= =============================================================================

*XButton1 Up:: return

#HotIf GetKeyState('XButton1', 'P')
/**
 * These are needed so that they don't get stuck.
 * Idkw but it has something to do with X1+W.
 * See https://www.autohotkey.com/boards/viewtopic.php?f=82&t=125851
 * which may mean this is a bug:
 */
*MButton:: return
*LButton:: return
*RButton:: return

#HotIf

;== ============================================================================
;== ↕️ X1+W / Cycle through windows in used order
;== ============================================================================

; Moving the X1+W hotkeys below the X1+R+W hotkeys
; would make X1+R+W not work.
; See https://www.autohotkey.com/boards/viewtopic.php?f=14&t=125819
; which may mean this is a bug.

A_TrayMenu.insert('E&xit', 'Enable &MouseAltTab', ToggleMouseAltTab)
A_TrayMenu.check('Enable &MouseAltTab')

ToggleMouseAltTab(name := 'Enable &MouseAltTab', pos := 0, menu := {}) {
    Hotkey('XButton1 & WheelDown', 'Toggle')
    Hotkey('XButton1 & WheelUp', 'Toggle')

    A_TrayMenu.toggleCheck('Enable &MouseAltTab')
}

;=== ===========================================================================
;=== ⬇️ Cycle through windows in recently used order (Alt+Tab)
;=== ===========================================================================

XButton1 & WheelDown:: AltTab

;=== ===========================================================================
;=== ⬆️ Cycle through windows in reverse used order (Shift+Alt+Tab)
;=== ===========================================================================

XButton1 & WheelUp::   ShiftAltTab

;== ============================================================================
;== ↕️ X1+M+W / Minimize and maximize window
;== ============================================================================

MouseWinMinMax(minOrMax) {
    if G_MouseIsMovingWin {
        WinExist('A')
    } else {
        MouseWinActivate()
    }
    Win%minOrMax%imize()
}

;=== ===========================================================================
;=== ↙️ X1+M+WD / Minimize window
;=== ===========================================================================

#HotIf GetKeyState('XButton1', 'P')
MButton & WheelDown:: MouseWinMinMax('Min')
#HotIf

;=== ===========================================================================
;=== ↗ X1+M+WU / Maximize window
;=== ===========================================================================

#HotIf GetKeyState('XButton1', 'P')
MButton & WheelUp::   MouseWinMinMax('Max')
#HotIf

;== ============================================================================
;== 🚚 X1+M / Restore window and move it using the mouse (+ misc)
;== ============================================================================

#HotIf GetKeyState('XButton1', 'P')
*MButton Up:: return
MButton Up:: MouseWinRestoreAndMove(thisHotkey)
MouseWinRestoreAndMove(thisHotkey) {
    global G_MouseIsMovingWin := true

    MouseExitIfCantBeThisHk(thisHotkey, A_PriorHotkey, '*MButton')

    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click('M')
        return
    }

    MouseWinActivate()
    if WinActive('ahk_class WorkerW ahk_exe Explorer.EXE') {
        return
    }

    WinExist('A')
    winMinMax := WinGetMinMax()
    if winMinMax = 1 {
        WinRestore()
        MoveWinMiddleToMouse()
    }

    CoordMode('Mouse')
    MouseGetPos(&mouseStartX, &mouseStartY)
    WinGetPos(&winOriginalX, &winOriginalY)

    while GetKeyState('XButton1', 'P')
            ; A loop is used instead of SetTimer to preserve the last found window.
    {
        if SubStr(A_ThisHotkey, 1, -2) = 'MButton & Wheel' {
            break
        }

        MouseGetPos(&mouseX, &mouseY)
        WinGetPos(&winX, &winY)
        WinMove(winX + (mouseX - mouseStartX), winY + (mouseY - mouseStartY))

        mouseStartX := mouseX
        mouseStartY := mouseY

        Sleep(10)
    }

    G_MouseIsMovingWin := false
}
#HotIf

;== ============================================================================
;== ❎ X1+M+R / Close window
;== ============================================================================

#HotIf GetKeyState('XButton1', 'P')
MButton & RButton Up:: MouseWinClose()
MouseWinClose() {
    MouseWinActivate()
    if WinActive(K_CLASSES['ZOOM']['MEETING']) {
        Send('!q')
                ; Show 'End Meeting or Leave Meeting?' prompt in the middle of the screen
                ; instead of the corner of the window.
    } else if WinActive(K_CLASSES['ZOOM']['HOME']) {
        if Zoom_MeetingWinExist(true) {
            ControlSend('!q', , K_CLASSES['ZOOM']['MEETING'])
        } else {
            ProcessClose('Zoom.exe')
        }
    } else if WinActive('ahk_exe PowerToys.Settings.exe') {
        WinClose()
    } else {
        Send('!{F4}')
    }
}
#HotIf

;== ============================================================================
;== ❎ X1+L / Send Delete key (+ misc)
;== ============================================================================

#HotIf GetKeyState('XButton1', 'P')
*LButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorHotkey)
    
    if WinActive('Task Switching ahk_class XamlExplorerHostIslandWindow') {
        Click()
        return
    }

    MouseSend('{Del}')
}
#HotIf

;== ============================================================================
;== ❎ X1+L+R / Send Backspace key
;== ============================================================================

#HotIf GetKeyState('XButton1', 'P')
LButton & RButton Up:: MouseSend('{BS}')
#HotIf

;== ============================================================================
;== ⬇️ X1+R / Send Enter key
;== ============================================================================

#HotIf GetKeyState('XButton1', 'P')
*RButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorHotkey)
    MouseSend('{Enter}')
}
#HotIf

;== ============================================================================
;== ➡️ X1+R+L / Send Tab key
;== ============================================================================

#HotIf GetKeyState('XButton1', 'P')
RButton & LButton Up:: MouseSend('{Tab}')
#HotIf

;== ============================================================================
;== ↩️ X1+R+WD / Undo
;== ============================================================================

#HotIf GetKeyState('XButton1', 'P')
RButton & WheelDown:: MouseSend('^z')
#HotIf

;== ============================================================================
;== ↪ X1+R+WU / Redo
;== ============================================================================

#HotIf GetKeyState('XButton1', 'P')
RButton & WheelUp:: {
    MouseWinActivate()
    
    if WinThatUsesCtrlYAsRedoIsActive() {
        Send('^y')
    } else {
        Send ('^+z')
    }
}
#HotIf

;= ============================================================================
;= XButton2 / Tab shortcuts
;= =============================================================================

*XButton2 Up:: return

;== ============================================================================
;== ↔️ X2+W / Switch to adjacent tab
;== ============================================================================

MouseAdjacentTabSwitch(states*) {
    MouseWinActivate()

    WinExist('A')
    activeWin := {}
    activeWin.class := WinGetClass()
    activeWin.processName := WinGetProcessName()

    if activeWin.processName  ~= 'i)\A(Discord.exe|Messenger.exe)\z' {
        Send('!' states[1])
    } else if activeWin.processName ~= 'i)\A(POWERPNT.EXE)\z' {
        Send(states[2])
    } else if activeWin.class ~= 'i)\A(CabinetWClass)\z'
        or activeWin.processName ~= 'i)\A(AcroRd32.exe|Notion.exe|Photoshop.exe|WindowsTerminal.exe)' {
        Send('^' states[3])
    } else {
        Send('^' states[-1])
    }
}

;=== ===========================================================================
;=== ⬅️ X2+WD / Switch to left tab
;=== ===========================================================================

#HotIf GetKeyState('XButton2', 'P')
WheelDown:: MouseAdjacentTabSwitch('{Down}', '{PgDn}', '{Tab}',                       '{PgDn}')
#HotIf

;=== ===========================================================================
;=== ➡️ X2+WU / Switch to right tab
;=== ===========================================================================

#HotIf GetKeyState('XButton2', 'P')
WheelUp::   MouseAdjacentTabSwitch('{Up}',   '{PgUp}', '+{Tab}', '{PgUp}')
#HotIf

;== ============================================================================
;== ↕️ X2+R+W / Cycle through tabs in used order (+ misc)
;== ============================================================================

; Each condition has its own #HotIf
; because if they were all under the same hotkey variant,
; then the KeyWait under "#HotIf GetKeyState('XButton2', 'P')"
; would prevent any further inputs from going through. 

#HotIf GetKeyState('XButton2', 'P') and MouseWinActivate('ahk_exe msedge.exe')
/**
 * Search tabs.
 */
RButton & WheelDown:: {
    if GetKeyState('Ctrl') {
        Send('{Ctrl Up}')
    }

    Send('^+a')
}
RButton & WheelUp:: Send('{Esc}')

#HotIf GetKeyState('XButton2', 'P') and WinActive('ahk_exe AcroRd32.exe')
RButton & WheelDown:: Send('^{PgDn}')
        ; Jump one page down.
RButton & WheelUp::   Send('^{PgUp}')
        ; Jump one page up.

#HotIf GetKeyState('XButton2', 'P') and GetKeyState('Ctrl')
RButton & WheelDown:: Send('{Tab}')
RButton & WheelUp::   Send('+{Tab}')

#HotIf GetKeyState('XButton2', 'P')
RButton & WheelDown:: MouseViewFirstTabInUsedOrder('{Tab}')
RButton & WheelUp::   MouseViewFirstTabInUsedOrder('+{Tab}')

MouseViewFirstTabInUsedOrder(tab) {
    Send('{Ctrl Down}' tab)
    KeyWait('RButton')
    Send('{Ctrl Up}')
}
#HotIf

;== ============================================================================
;== ❎ X2+R / Close tab
;== ============================================================================

#HotIf GetKeyState('XButton2', 'P')
RButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorKey)
    MouseWinActivate()
    Send('^w')
}
#HotIf

;== ============================================================================
;== ↪ X2+R+L / Reopen last closed tab (+ misc)
;== ============================================================================

#HotIf GetKeyState('XButton2', 'P')
RButton & LButton Up:: {
    MouseWinActivate()
    if WinActive('ahk_exe Adobe Premiere Pro.exe') {
        Send('+3{F2}')
                ; Focus on timeline,
                ; and move playhead to cursor.
    } else {
        Send('^+t')
    }
}
#HotIf

;== ============================================================================
;== 🔄 X2+L+M / Refresh page or reload window (Ctrl+R)
;== ============================================================================

#HotIf GetKeyState('XButton2', 'P')
LButton & MButton Up:: MouseCtrlR()
MouseCtrlR() {
    MouseWinActivate()
    Send('^r')
}
#HotIf

;== ============================================================================
;== ↔️ X2+L(+R) / Go back and forward a page
;== ============================================================================

MouseGoBackAndForward(states*) {
    MouseWinActivate()
    if WinActive('ahk_exe Notion.exe') {
        Send('^' states[1])
    } else {
        Click(states[-1])
    }
}

;=== ===========================================================================
;=== ⬅️ X2+L / Go back a page (+ misc)
;=== ===========================================================================

#HotIf GetKeyState('XButton2', 'P')
LButton Up:: {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorKey)
    MouseGoBackAndForward('[', 'X1')
}
#HotIf

;=== ===========================================================================
;=== ➡️ X2+L+R / Go forward a page
;=== ===========================================================================

#HotIf GetKeyState('XButton2', 'P')
LButton & RButton Up:: {
    MouseGoBackAndForward(']', 'X2')
}
#HotIf

;== ============================================================================
;== 🔗 X2+M / Open link in new active tab
;== ============================================================================

#HotIf GetKeyState('XButton2', 'P')
MButton Up:: MouseLinkOpenInNewActiveTab(thisHotkey)
MouseLinkOpenInNewActiveTab(thisHotkey) {
    MouseExitIfCantBeThisHk(thisHotkey, A_PriorKey)
    Send('^+{Click}')
}
#HotIf

;= ============================================================================
;= Always use the window underneath
;= ============================================================================

~*WheelDown::
~*WheelUp::
{
    MouseWinActivate()
}

;= =============================================================================
;= Alternate right and middle click for touchpad
;= =============================================================================

#LButton::  Click('R')
#!LButton:: Click('M')

;= =============================================================================
;= Functions
;= =============================================================================

MouseControlFocus(control := '', winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd, &mouseControlHwnd, 2)
    WinActivate(mouseHwnd)
    if not WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText) {
        return
    }

    ControlFocus(mouseControlHwnd)
    if control = '' {
        return mouseControlHwnd
    }

    try {
        controlHwnd := ControlGetHwnd(control)
    } catch {
        return
    }

    if controlHwnd != mouseControlHwnd {
        return
    }

    return mouseControlHwnd
}

MouseExitIfCantBeThisHk(thisHotkey, target, reference?) {
    if not IsSet(reference) {
        reference := SubStr(thisHotkey, 1 , -3)
    }
    if target != reference {
        exit
    }
}

MouseSend(keys) {
    MouseWinActivate()
    Send('{Blind}' keys)
}

MouseWinActivate(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd)
    WinActivate(mouseHwnd)
    return WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText)
        ; mouseHwnd is there for the case
        ; when all the parameters are blank and there is no last found window.
}

MoveWinMiddleToMouse() {
    WinGetPos(, , &winW, &winH)

    CoordMode('Mouse')
    MouseGetPos(&mouseX, &mouseY)

    WinMove(mouseX - (winW / 2), mouseY - (winH / 2))
}

