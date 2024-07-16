#Include <default-settings>
#Include <globals>
#Include <constants>
#Include <functions>
#Include <classes>

;= =============================================================================
;= Constants
;= =============================================================================

;= ===========================================================================
;= NumLock
;= ===========================================================================

DoOnNumLockToggle()
^CapsLock:: {
    numLockState := GetKeyState('NumLock', 'T')
    SetNumLockState(not numLockState)
    DoOnNumLockToggle()
}

DoOnNumLockToggle() {
    NumLockIndicatorFollowMouse()
    C_InsertInputRightOfCaret.toggle()
}

/**
 * Display ToolTip while NumLock is on.
 */
NumLockIndicatorFollowMouse() {
    Sleep(10)

    if GetKeyState('NumLock', 'T') {
        SetTimer(toolTipNumLock, 10)
    } else {
        SetTimer(toolTipNumLock, 0)
        ToolTip()
    }

    toolTipNumLock() => ToolTip('NumLock On')
}

;== ============================================================================
;== Directory
;== ============================================================================

#HotIf GetKeyState('NumLock', 'T')
^d:: WinOpenProcessDir()
WinOpenProcessDir() {
    WinExist('A')
    winProcessName := WinGetProcessName()
    winPid := WinGetPid()
    winPath := ProcessGetPath(winPid)
    winDir := RegExReplace(winPath, '\\[^\\]+$')
    Run(winDir)
    WinWaitActive('ahk_exe explorer.exe')
    Send(winProcessName)
}

^+d:: RunSelectedAsDir()
RunSelectedAsDir() {
    dir := GetSelectedElseExit()
    while RegExMatch(dir, '%(.+?)%', &match) {
        env := EnvGet(match[1])
        dir := StrReplace(dir, match[], env)
    }

    Run(dir)
}
#HotIf

;= =============================================================================
;= Specific app
;= =============================================================================

#HotIf not WinThatUsesCtrlYAsRedoIsActive()
$^+z:: Send('^y')
$^y::  Send('^+z')
#HotIf

/**
 * Open uniqoda.
 */
#+,:: {
    winKeysUp := ''
    loop parse 'LR' {
        if GetKeyState(A_LoopField 'Win', 'P') {
            winKeysUp .= '{' A_LoopField 'Win Up}'
        }
    }
    Send('{Blind}' winKeysUp '^+{F20}')
            ; {Blind#}^+{F20} does not work
            ; because that would be equivalent to
            ; {Blind}{LWin Up}^+{F20}{LWin Down}
                    ; (Well, actually, not sure how it accounts for RWin.)
            ; and fsr, uniqoda does something weird when a Win key is down
            ; a short time after F20 has already been sent.
}

;== ============================================================================
;== Acrobat
;== ============================================================================

#HotIf WinActive('ahk_exe AcroRd32.exe')
/**
 * Toggle Full Screen Mode.
 */
F11:: Send('^l')
#HotIf

;== ===========================================================================
;== Edge
;== ===========================================================================

#HotIf WinActive('ahk_exe msedge.exe')
^!+e:: Send('{Ctrl Down}w{PgUp}{Ctrl Up}')
        ; Close current tab and move to the tab that was to its left.

/**
 * Disable.
 */
^+Delete::
        ; Clear browsing data.
^r::
        ; I sometimes accidentally press this when I want to ^t.
        ; I will just use F5 instead.
{
    return
}
#HotIf

;= ============================================================================
;= Vimium C commands
;= ============================================================================
; For information on what Vimium C is:
; https://github.com/gdh1995/vimium-c

#HotIf WinActive('ahk_exe msedge.exe')
^;:: VimcCmd(2)
        ; LinkHints.activateEdit

^!r::    VimcCmd(6)
        ; reopenTab.
^!e::    VimcCmd(7)
        ; removeRightTab.

^+PgUp:: VimcCmd(8)
        ; moveTabLeft.
^+PgDn:: VimcCmd(9)
        ; moveTabRight.

VimcCmd(num) {
    if num > 24 {
        Send('!{F' (num - 12) '}')
    } else if num > 16 {
        Send('^{F' (num - 4) '}')
    } else if num > 8 {
        Send('+{F' (num + 4) '}')
    } else {
        Send('{F' (num + 12) '}')
    }
}
#HotIf

;== ============================================================================
;== Notion
;== ============================================================================

#HotIf WinActive('ahk_exe Notion.exe')
!Left::  Send('^[')
        ; Go back.
!Right:: Send('^]')
        ; Go forward.

^+f:: Send('^+h')
        ; Apply last text or highlight color used.
#HotIf

;== ============================================================================
;== Zoom
;== ============================================================================

#HotIf WinActive(K_CLASSES['ZOOM']['MEETING']) and WinWaitActive(K_CLASSES['ZOOM']['TOOLBAR'], , 0.1)
~#Down:: {
    winPid := WinGetPid()
    WinActivate('Zoom ahk_pid ' winPid)
        ; Activate minimized video/control window.
}

#HotIf WinActive(K_CLASSES['ZOOM']['WAIT_HOST']) or WinActive(K_CLASSES['ZOOM']['VID_PREVIEW'])
#Down:: WinMinimize()

#HotIf WinActive(K_CLASSES['ZOOM']['MIN_VID']) or WinActive(K_CLASSES['ZOOM']['MIN_CONTROL'])
/**
 * * Doesn't work when coming from #Down.
 */
#Up:: {
    WinGetPos(, , , &winH)
    ControlClick('x200 y' (winH - 30))
            ; Exit minimized video window.
}

#HotIf WinActive(K_CLASSES['ZOOM']['HOME']) and not Zoom_MeetingWinExist(true)
!F4:: ProcessClose('Zoom.exe')
        ; Can't use WinClose because that minimizes here.
#HotIf

;=== ===========================================================================
;=== Reactions
;=== ===========================================================================

#HotIf Zoom_MeetingWinExist(false)
!=:: Zoom_ThumbsUpReact()
Zoom_ThumbsUpReact() {
    Zoom_OpenReactions()
    Sleep(200)
            ; WinWaitActive(K_CLASSES['ZOOM']['REACTION']) doesn't work fsr.

    CoordMode('Mouse', 'Client')
    CoordMode('Pixel', 'Client')

    WinExist('A')
            ; Reaction window.
    WinGetPos(, , &winW, &winH)
    ImageSearch(&imageX, &imageY, 0, 0, winW, winH, '*50 images\thumbs-up-icon.png')
    ControlClick('x' imageX ' y' imageY)
    WinActivate(K_CLASSES['ZOOM']['MEETING'])
            ; Prevent the activation of the most recent window when the reaction disappears.
}

!e:: Zoom_OpenReactions()
Zoom_OpenReactions() {
    if not WinExist(K_CLASSES['ZOOM']['MEETING']) {
        return
    }
    if WinExist(K_CLASSES['ZOOM']['REACTION']) {
        WinActivate()
        return
    }

    if not WinActive()
            ; Check if the meeting window isn't active.
    {
        WinActivate()
    }

    if not ControlGetVisible(K_CONTROLS['ZOOM']['MEETING_CONTROLS']) {
        ControlShow(K_CONTROLS['ZOOM']['MEETING_CONTROLS'])
    }

    ControlGetPos(&controlX, &controlY, &controlW, &controlH, K_CONTROLS['ZOOM']['MEETING_CONTROLS'])

    loop {
        try {
            iconClick('reactions')
        } catch {
        } else {
            return
        }

        if A_Index = 1 {
            Send('{Tab}')
                    ; Maybe the reason the icon wasn't found was because there was a dotted rectangle surrounding it,
                    ; so Send('{Tab}') to move the rectangle to a different item.
            continue
        }

        try {
            iconClick('more')
        } catch {
            exit
        } else {
            break
        }
    }

    Sleep(150)

    /**
     * I want my coordinates to be relative to the menu window
     * because that's where the Reactions menu item is,
     * but fsr, when I activate or ControlClick the window, I lose it.
     * As a work around, use Click,
     * and make it relative to the virtual screen.
     * Do the same with ImageSearch.
     */

    CoordMode('Mouse')
    CoordMode('Pixel')

    MouseGetPos(&mouseX, &mouseY)
    ImageSearch(&imageX, &imageY, 0, 0, G_VirtualScreenW, G_VirtualScreenH, '*50 images\reactions-menu-item.png')

    Click(imageX ' ' imageY)
    Sleep(10)
    MouseMove(mouseX, mouseY)

    iconClick(imageFileName) {
        ImageSearch(&imageX, &imageY, controlX, controlY, controlX + controlW, controlY + controlH, '*50 images\' imageFileName '-icon.png')
        ControlClick('x' imageX ' y' imageY)
    }
}
#HotIf

;= =============================================================================
;= Keys
;= =============================================================================

;== ============================================================================
;== Backspace
;== ============================================================================

#HotIf WinWhereBackspaceProducesCtrlCharIsActive()
^Backspace:: CtrlBackspaceUsingDelete()
#HotIf

;== ============================================================================
;== F13 - F24
;== ============================================================================

MapF13UntilF24()
MapF13UntilF24() {
    HotIf((thisHotkey) => GetKeyState('NumLock', 'T'))
    loop 12 {
        if A_Index < 3 {
            num := A_Index + 22
        } else {
            num := A_Index + 10
        }

        Hotkey('*F' (A_Index), remap.bind(num))
    }
    HotIf

    remap(num, thisHotkey) => Send('{Blind}{F' num '}')
}

;= =============================================================================
;= Disable
;= =============================================================================

^+w::
#w::
#^d::
{
    return
}

;== ============================================================================
;== Mask Hyper shortcuts
;== ============================================================================

loop parse 'abcefghijklmnopqrstuvwxyz' {
    Hotkey('#^+!' A_LoopField, (ThisHotkey) => '')
}

#^+Alt::
#^!Shift::
#+!Ctrl::
^+!LWin::
^+!RWin::
{
    MaskMenu()
}

;= =============================================================================
;= Hotkeys in other programs
;= =============================================================================

/**
 * PowerToys hotkeys.
 * These hotkeys are redefined here
 * so that if I forget they exist and redefine them somewhere else,
 * I get an error.
 */
~#+a::
        ; Global mute microphone.
~#+c::
        ; Color picker.
~#+r::
        ; Screen Ruler.
{
    return
}

;= =============================================================================
;= Functions
;= =============================================================================

/**
 * ^Backspace doesn't natively work because it produces a control character,
 * so work around that.
 */
CtrlBackspaceUsingDelete() {
    if GetSelected() {
        Send('{Delete}')
    } else {
        Send('{Ctrl Down}{Shift Down}{Left}')
        Sleep(0)
                ; For Premiere Pro.
        Send('{Shift Up}{Ctrl Up}{Delete}')
                ; Delete last word typed.
                ; Delete comes last because fsr,
                ; Photoshop doesn't delete the word unless Delete comes last
                ; even though ^+Delete will delete the word if you do it manually.
    }
}

WinWhereBackspaceProducesCtrlCharIsActive() {
    if ControlClassNnFocused('A', '^Edit\d+$', true)
            or ControlClassNnFocused('ahk_exe AcroRd32.exe', '^AVL_AVView', true)
            or WinActive('ahk_exe mmc.exe') {
        return true
    }
}

