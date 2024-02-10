#Include <default-settings>
#Include <globals>
#Include <constants>
#Include <functions>
#Include <classes>

;= =============================================================================
;= Disable
;= =============================================================================

^+w::
#w::
#^d::
{
    return
}

;= =============================================================================
;= Hotkeys in Other Programs
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
~#+r:: {
        ; Screen Ruler.
    return
}

;= =============================================================================
;= Keys
;= =============================================================================

;== ============================================================================
;== Backspace
;== ============================================================================

#HotIf WinWhereBsProducesControlCharIsActive()
^BS:: CtrlBsWithDel()
#HotIf

;== ============================================================================
;== Modifiers
;== ============================================================================

;=== ===========================================================================
;=== F13 - F24
;=== ===========================================================================

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

;=== ===========================================================================
;=== Mask Hyper Shortcuts
;=== ===========================================================================

loop parse 'abcefghijklmnopqrstuvwxyz' {
    Hotkey('#^+!' A_LoopField, (ThisHotkey) => '')
}

#^+Alt::
#^!Shift::
#+!Ctrl::
^+!LWin::
^+!RWin:: {
    MaskMenu()
}

;=== ===========================================================================
;=== Custom Layer
;=== ===========================================================================

*CapsLock:: return

; Enabling the following causes CapsLock to be enabled on press and disabled on release.
; This is because custom combinations have special behavior explained here:
; https://www.autohotkey.com/docs/v2/Hotkeys.htm#combo
; *CapsLock:: return
; CapsLock & h:: Left
; CapsLock & j:: Down
; CapsLock & k:: Up
; CapsLock & l:: Right
; But even if CapsLock didn't turn on as expected.
; The modifiers could still get stuck in the same way as described below.
; You can see this by turning uncommenting everything but the "*CapsLock:: return"

; Note: There are additional custom layer hotkeys in Browsers > Vimium C Commands

#HotIf GetKeyState('CapsLock', 'P')
h:: Left
j:: Down
k:: Up
l:: Right

; How do they manage to activate the ^+PgDn and ^+PgUp VimcCmds
; if they use SendInput?
u:: PgDn
i:: PgUp

m::  Home
,::  End
n::  Insert
p::  PrintScreen
BS:: Del

3::
        ; The hotkey is 3
        ; because 3 key is also for #.
        ; We can think of # as standing for NumLock.
{
    numLockState := GetKeyState('NumLock', 'T')
    SetNumLockState(not numLockState)
    DoOnNumLockToggle()
}

Space:: ^BS
#HotIf GetKeyState('CapsLock', 'P') and WinWhereBsProducesControlCharIsActive()
Space:: CtrlBsWithDel()

#HotIf

;=== ===========================================================================
;=== Double Shift for CapsLock
;=== ===========================================================================

<+RShift::
>+LShift::
{
    ; Prevent a combination like LShift+f+RShift
    ; from triggering this hotkey:
    if SubStr(A_PriorKey, 2) != 'Shift' {
        return
    }

    capsLockState := GetKeyState('CapsLock', 'T')
    SetCapsLockState(not capsLockState)
    Send('{Blind}{LShift Up}{RShift Up}')
}

;=== ===========================================================================
;=== NumLock
;=== ===========================================================================

DoOnNumLockToggle()
~NumLock:: DoOnNumLockToggle()

;= =============================================================================
;= Multimedia
;= =============================================================================

;== ============================================================================
;== Media
;== ============================================================================

#HotIf GetKeyState('CapsLock', 'T')
Volume_Mute:: vk13
        ; Pause key.
#HotIf

Pause:: OneBtnRemote()
OneBtnRemote() {
    static _quickPressCount := 0

    _quickPressCount++
    if _quickPressCount > 2 {
        return
    } else {
        Send('{Media_Play_Pause}')
    }

    SetTimer(chooseMediaControl, -500)

    chooseMediaControl() {
        switch _quickPressCount {
        case 2: Send('{Media_Next}')
        case 3: Send('{Media_Prev}')
        }

        _quickPressCount := 0
    }
}

;== ============================================================================
;== Volume
;== ============================================================================

#HotIf GetKeyState('CapsLock', 'T')
$Volume_Up::   DisplayAndSetVolume(1)
$Volume_Down:: DisplayAndSetVolume(-1)

DisplayAndSetVolume(variation) {
    newVol := SoundGetVolume() + variation
    newVol := Round(newVol)

    Send('{Blind}{Volume_Up Down}{Volume_Up Up}')
            ; On the surface, this increases the volume by 2,
            ; but what this line is actually for is to display the volume slider (and media overlay).
            ; because SoundSetVolume doesn't do that on its own.
            ; We use {Blind}{Key Up} so that keyboards that send Volume_Up and Volume_Down as artificial keys
            ; don't trick AHK into thinking the hotkey was pressed again,
            ; resulting in an infinite loop
            ; We send Volume_Up instead of Volume_Down
            ; because if Volume_Down were used, then when the volume is at 2,
            ; the volume would briefly mute for a split second if the keyboard sends inputs slow.
    SoundSetVolume(newVol)
            ; Override that normal volume variation/increase of 2
            ; with the actual new volume variation we want.
}
#HotIf

;= =============================================================================
;= Run
;= =============================================================================

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
;= Specific App
;= =============================================================================

#HotIf not WinThatUsesCtrlYAsRedoIsActive()
$^+z:: Send('{Ctrl Down}y{Ctrl Up}')
$^y::  Send('{Ctrl Down}{Shift Down}z{Shift Up}{Ctrl Up}')
#HotIf

/**
 * Open uniqoda.
 */
#+,:: {
    Send('{Blind}{Shift Up}{LWin Up}')
    Send('{Ctrl Down}{Shift Down}{F20}{Shift Up}{Ctrl Up}')
}

;== ============================================================================
;== Acrobat
;== ============================================================================

#HotIf WinActive('ahk_exe AcroRd32.exe')
/**
 * Toggle Full Screen Mode.
 */
F11:: Send('{Ctrl Down}l{Ctrl Up}')
#HotIf

;== ============================================================================
;== Browsers
;== ============================================================================

;=== ===========================================================================
;=== Vimium C Commands
;=== ===========================================================================

#HotIf GetKeyState('CapsLock', 'P') and WinActive('ahk_exe msedge.exe')
`;:: VimcCmd(1)
        ; LinkHints.activate.
+;:: VimcCmd(2)
        ; LinkHints.activateEdit.
^;:: VimcCmd(3)
        ; LinkHints.activateHover.

+':: VimcCmd(4)
        ; LinkHints.activateCopyLinkUrl.
'::  VimcCmd(5)
        ; LinkHints.activateCopyLinkText.

#HotIf WinActive('ahk_exe msedge.exe')
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
        Send('{Alt Down}{F' (num - 12) '}{Alt Up}')
    } else if num > 16 {
        Send('{Ctrl Down}{F' (num - 4) '}{Ctrl Up}')
    } else if num > 8 {
        Send('{Shift Down}{F' (num + 4) '}{Shift Up}')
    } else {
        Send('{F' (num + 12) '}')
    }
}
#HotIf

;=== ===========================================================================
;=== Edge
;=== ===========================================================================

#HotIf WinActive('ahk_exe msedge.exe')
^!+e:: Send('{Ctrl Down}w{PgUp}{Ctrl Up}')
        ; Close current tab and move to the tab that was to its left.

/**
 * Disable.
 */
^+Del::
        ; Clear browsing data.
^r:: {
        ; I sometimes accidentally press this when I want to Ctrl+T.
        ; I will just use F5 instead.
    return
}
#HotIf

;== ============================================================================
;== Notion
;== ============================================================================

#HotIf WinActive('ahk_exe Notion.exe')
!Left::  Send('{Ctrl Down}[{Ctrl Up}')
        ; Go back.
!Right:: Send('{Ctrl Down}]{Ctrl Up}')
        ; Go forward.

^+f:: Send('{Ctrl Down}{Shift Down}h{Shift Up}{Ctrl Up}')
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
;= Functions
;= =============================================================================

/**
 * ^BS doesn't natively work because it produces a control character,
 * so work around that.
 */
CtrlBsWithDel() {
    if GetSelected() {
        Send('{Del}')
    } else {
        Send('{Ctrl Down}{Shift Down}{Left}')
        Sleep(0)
                ; For Premiere Pro.
        Send('{Shift Up}{Ctrl Up}{Del}')
                ; Delete last word typed.
                ; Delete comes last because fsr,
                ; Photoshop doesn't delete the word unless Delete comes last
                ; even though ^+Del will delete the word if you do it manually.
    }
}

WinWhereBsProducesControlCharIsActive() {
    if ControlClassNnFocused('A', '^Edit\d+$', true)
            or ControlClassNnFocused('ahk_exe AcroRd32.exe', '^AVL_AVView', true)
            or WinActive('ahk_exe mmc.exe') {
        return true
    }
}

;== ============================================================================
;== NumLock
;== ============================================================================

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
