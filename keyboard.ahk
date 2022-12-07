#Include <default-settings>
#Include <globals>
#Include <constants>
#Include <functions>
#Include <classes>

;= =============================================================================
;= All Apps
;= =============================================================================

;== ============================================================================
;== Disable
;== ============================================================================

^+w:: return

;== ============================================================================
;== PrintScreen
;== ============================================================================

PrintScreen:: Send('{LWin Down}{Alt Down}{PrintScreen}{Alt Up}{LWin Up}')
        ; Save screenshot of window.

;== ============================================================================
;== Restart
;== ============================================================================

#F5:: ProcessRestart()
ProcessRestart() {
    WinExist('A')

    winPid := WinGetPID()
    winPath := ProcessGetPath(winPid)

    WinClose()
    ProcessWaitClose(winPid, 5)
    Sleep(1000)
    Run(winPath)
}

;= =============================================================================
;= Specific App
;= =============================================================================

#!m:: AppToggleMute()
AppToggleMute() {
    switch ChordInput() {
    case 'z': Send('{Ctrl Down}{Shift Down}{Alt Down}{F1}{Alt Up}{Shift Up}{Ctrl Up}')
    case 'd': Send('{Ctrl Down}{Shift Down}{Alt Down}{F2}{Alt Up}{Shift Up}{Ctrl Up}')
    }
}

;== ============================================================================
;== Browsers
;== ============================================================================

BrowserHotkeys(() => GetKeyState('NumLock', 'T'))
BrowserHotkeys(hotIfExFn) {
    C_Hotkey.Browser.searchSelectedAsUrl('u', , hotIfExFn)
    C_Hotkey.Browser.searchSelectedAsUrl('g', 'https://www.google.com/search?q=', hotIfExFn)
    C_Hotkey.Browser.searchSelectedAsUrl('y', 'https://www.youtube.com/results?search_query=', hotIfExFn)
}

;=== ===========================================================================
;=== Edge
;=== ===========================================================================

#HotIf WinActive('ahk_exe msedge.exe')
^Tab::  Send('{Ctrl Down}{Shift Down}a{Shift Up}{Ctrl Up}')
        ; Search tabs.
^+Tab:: Send('{Ctrl Down}{Shift Down},{Shift Up}{Ctrl Up}')
        ; Toggle vertical tabs.

#HotIf WinActive(' - Google Docs ahk_exe msedge.exe')
Alt Up:: {
    if not InStr(A_PriorKey, 'Alt') {
        return
    }
    Send('{F10}')
}
#HotIf

;=== ===========================================================================
;=== Firefox
;=== ===========================================================================

#HotIf WinActive('ahk_exe firefox.exe')
^e:: Send('{F1}')
        ; Toggle Tree Style Tab.

^q::  Firefox_SearchYouTube(false)
^+q:: Firefox_SearchYouTube(true)

Firefox_SearchYouTube(inNew) {
    inNew := (inNew)? 't' : 'l'
    Send('{Ctrl Down}' inNew '{Ctrl Up}')

    ;~ SetTitleMatchMode(3)
    ;~ newTabActive := WinWaitActive('Mozilla Firefox', , 5)

    ;~ if not newTabActive {
    ;~     return
    ;~ }
    Sleep(150)
    Send('@')
}

/**
 * Shortcut Forwarding Tool and Vimium C
 * These hotkeys activate the global browser shortcuts.
 * The reason some numbers are missing is because some combinations of Ctrl, Alt, Shift, and F[1-12] are
 * built-in to Firefox and are intercepted by Firefox first and not AutoHotkey;
 * thus, I've opted to leave their shortcuts in Firefox blank unless I choose
 * to supply a different shortcut from the Send pattern in Firefox_CustomShortcut.
 */

!'::  Firefox_CustomShortcut(1)
        ; LinkHints.activate.
!+':: Firefox_CustomShortcut(2)
        ; LinkHints.activateEdit.
^!':: Firefox_CustomShortcut(3)
        ; LinkHints.activateHover.

^!c:: {
    switch ChordInput() {
    case '`'': Firefox_CustomShortcut(4)
        ; LinkHints.activateCopyLinkUrl.
    case '"':  Firefox_CustomShortcut(5)
        ; LinkHints.activateCopyLinkText.
    case 'i':  Firefox_CustomShortcut(7)
        ; LinkHints.activateCopyImage.
    case 't':  Firefox_CustomShortcut(8)
        ; copyCurrentTitle.
    }
}

!+Left::  Firefox_CustomShortcut(9)
        ; goPrevious.
!+Right:: Firefox_CustomShortcut(11)
        ; goNext.

!;::   Firefox_CustomShortcut(12)
        ; Marks.activateCreate swap.
!+;::  Firefox_CustomShortcut(13)
        ; Marks.activate swap.
^!;::  Firefox_CustomShortcut(14)
        ; Marks.clearGlobal.
^!+;:: Firefox_CustomShortcut(15)
        ; Marks.clearLocal.

!+/:: Firefox_CustomShortcut(17)
        ; showHelp.

!PgDn:: Firefox_CustomShortcut(18)
        ; scrollPageDown.
!PgUp:: Firefox_CustomShortcut(19)
        ; scrollPageUp.

^!d:: Firefox_CustomShortcut(20)
        ; duplicateTab.

/**
 * * These hotkeys are already configured in Firefox because they can be.
 * * These are the global shortcuts
 * * that I supplied a different shortcut from the Send pattern in Firefox_CustomShortcut:
 * *     ^F6:: Firefox_CustomShortcut(6)   ; nextFrame.
 * *     ^!r:: Firefox_CustomShortcut(10)  ; reopenTab.
 */

Firefox_CustomShortcut(num) {
    if num > 24 {
        Send('{Ctrl Down}{Alt Down}{F' (num - 24) '}{Alt Up}{Ctrl Up}')
    } else if num > 12 {
        Send('{Alt Down}{Shift Down}{F' (num - 12) '}{Shift Up}{Alt Up}')
    } else {
        Send('{Ctrl Down}{Shift Down}{F' num '}{Shift Up}{Ctrl Up}')
    }
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
;== PowerToys Run
;== ============================================================================

#;:: {
    ActivatePowerToysRun()
    Send('< ')
            ; Search open windows.
}

#':: {
    ActivatePowerToysRun()
    Send('* ')
            ; Search programs.
}

ActivatePowerToysRun() {
    DetectHiddenWindows(true)

    if not WinExist('ahk_exe PowerToys.PowerLauncher.exe') {
        return
    }
    Send('{LWin Down}{Space}{LWin Up}')
            ; Activate PowerToys Run.
    powerLauncherActive := WinWaitActive(, , 5)

    if not powerLauncherActive {
        return
    }
}

#HotIf WinActive('ahk_exe PowerToys.PowerLauncher.exe')
!;:: Send('{End}.exe{Ctrl Down}{Left}{Ctrl Up}{Left}')
        ; Search only for processes.
        ; This hotkey is meant to be used for Window Walker.
#HotIf

;== ============================================================================
;== Spotify
;== ============================================================================

#HotIf WinActive('ahk_exe Spotify.exe')
/** 
 * I switched the keyboard shortcuts for varying the navigation bar and friend activity widths.
 * When you increase the navigation bar width, the cover art grows taller,
 * so assign Down and Up to it,
 * When you increase the friend activity width, the bar grows fatter,
 * so assign Left and Right to it.
 */
!+Down::  Send('{Alt Down}{Shift Down}{Left}{Shift Up}{Alt Up}')
        ; Decrease navigation bar width.
!+Up::    Send('{Alt Down}{Shift Down}{Right}{Shift Up}{Alt Up}')
        ; Increase navigation bar width.
!+Left::  Send('{Alt Down}{Shift Down}{Down}{Shift Up}{Alt Up}')
        ; Increase friend activity width.
!+Right:: Send('{Alt Down}{Shift Down}{Up}{Shift Up}{Alt Up}')
        ; Decrease friend activity width.
#HotIf

;=== ===========================================================================
;=== Spicetify
;=== ===========================================================================

#HotIf WinActive('ahk_exe Spotify.exe')
/**
 * * keyboardShortcut-Quarter.js:
 * *     !+l:: toggleLyrics()
 * *     !+q:: toggleQueue()
 * *     !+m:: openSpicetifyMarketPlace()
 *
 * !+2 goes to Your Podcasts,
 * but because of the Hide Podcasts extension,
 * Your Podcasts isn't listed in Your Library,
 * so !+2 should redirect to Your Artists instead.
 * The same logic applies to !+3 and !+4.
 */
!+2:: Send('{Alt Down}{Shift Down}3{Shift Up}{Alt Up}')
        ; Go to Your Artists.
!+3:: Send('{Alt Down}{Shift Down}4{Shift Up}{Alt Up}')
        ; Go to Your Albums.
!+4:: return
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

#HotIf WinActive(K_CLASSES['ZOOM']['HOME'])
        and not WinExist('Zoom ahk_pid ' WinGetPid.tryCall(K_CLASSES['ZOOM']['TOOLBAR']))
                ; Check if a visible meeting window doesn't exist.
!F4:: ProcessClose('Zoom.exe')
        ; Can't use WinClose because that minimizes here.
#HotIf

;=== ===========================================================================
;=== Reactions
;=== ===========================================================================

#HotIf WinActive('ahk_pid ' WinGetPid.tryCall(K_CLASSES['ZOOM']['TOOLBAR']))
        ; Check if a meeting window is active.
!=:: Zoom_ThumbsUpReact()
Zoom_ThumbsUpReact() {
    Zoom_OpenReactions()
    Sleep(50)
    
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
    if not WinActive() {
            ; Check if the meeting window isn't active.
        WinActivate()
    }

    if not ControlGetVisible(K_CONTROLS['ZOOM']['MEETING_TOOLS']) {
        ControlShow(K_CONTROLS['ZOOM']['MEETING_TOOLS'])
    }
    ControlGetPos(&controlX, &controlY, &controlW, &controlH, K_CONTROLS['ZOOM']['MEETING_TOOLS'])
    
    iconClick(imageFileName) {
        ImageSearch(&imageX, &imageY, controlX, controlY, controlX + controlW, controlY + controlH, '*50 images\' imageFileName '-icon.png')
        ControlClick('x' imageX ' y' imageY)
    }

    Loop {
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
    ImageSearch(&imageX, &imageY, 0, 0, G_.virtualScreenW, G_.virtualScreenH, '*50 images\reactions-menu-item.png')
    
    Click(imageX ' ' imageY)
    Sleep(10)
    MouseMove(mouseX, mouseY)
}
#HotIf

;= =============================================================================
;= Run
;= =============================================================================

;== ============================================================================
;== Directory
;== ============================================================================

#HotIf GetKeyState('NumLock', 'T')
d:: WinOpenDir()
WinOpenDir() {
    winPid := WinGetPID('A')
    winPath := ProcessGetPath(winPid)
    winDir := RegExReplace(winPath, '\\[^\\]+$')
    Run(winDir)
}

+d:: RunSelectedAsDir()
RunSelectedAsDir() {
    dir := GetSelectedElseExit()

    while RegExMatch(dir, '%(.+?)%', &match) {
        env := EnvGet(match[1])
        dir := StrReplace(dir, match[], env)
    }
    Run(dir)
}
#HotIf

;== ============================================================================
;== App
;== ============================================================================

#i:: OpenSettings()
OpenSettings() {
    switch ChordInput() {
    case 'i': Send('{LWin Down}i{LWin Up}')
    case 'v': Run('App volume and device preferences', 'C:\Windows')
    }
}

;= =============================================================================
;= Activate
;= =============================================================================

; A_TitleMatchMode = 2:
GroupAdd('ExplorerWins', 'ahk_class CabinetWClass')

; A_TitleMatchMode = 'RegEx':
GroupAdd('PhotoWins', ' ' K_CHARS['LEFT_TO_RIGHT_MARK'] '- Photos$ ahk_exe ApplicationFrameHost.exe')
GroupAdd('ZoomWins', 'ahk_class ^Z ahk_exe Zoom.exe')

^!Tab::  OperateOnActiveGroup('Activate')
^+!Tab:: OperateOnActiveGroup('Close')

OperateOnActiveGroup(action) {
    check(groupName) {
        if not WinActive('ahk_group ' groupName) {
            return
        }
        Group%action%(groupName)
        exit
    }
    
    check('ExplorerWins')

    SetTitleMatchMode('RegEx')
    check('PhotoWins')
    check('ZoomWins')

    SetTitleMatchMode(2)

    processName := WinGetProcessName('A')
    groupName := StrReplace(processName, '.exe')
    groupName := StrReplace(groupName, ' ', '_')
    
    GroupAdd(groupName, 'ahk_exe ' processName)
    Group%action%(groupName)
}

;= =============================================================================
;= Multimedia
;= =============================================================================

;== ============================================================================
;== Media
;== ============================================================================

Pause:: OneButtonRemote()
OneButtonRemote() {
    static pressCount := 0
    
    pressCount++

    if pressCount > 2 {
        return
    } else {
        Send('{Media_Play_Pause}')
    }
    period := RegRead('HKEY_CURRENT_USER\Control Panel\Mouse', 'DoubleClickSpeed')
    SetTimer(chooseMediaControl, -period)

    chooseMediaControl() {
        switch pressCount {
        case 2: Send('{Media_Next}')
        case 3: Send('{Media_Prev}')
        }
        pressCount := 0
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

    if variation > 0 or newVol = 1 {
        volDirection := 'Up'
    } else {
        volDirection := 'Down'
    }

    Send('{Volume_' volDirection '}')
            ; Vary volume by 2,
            ; and, importantly, display volume slider (and media overlay).
    SoundSetVolume(newVol)
            ; Override that normal variation of 2.
}

#HotIf GetKeyState('CapsLock', 'T')
#InputLevel 1
Volume_Mute:: vk13
        ; Pause key.
#InputLevel
#HotIf

;= =============================================================================
;= Keys
;= =============================================================================

;== ============================================================================
;== Insert Whitespace
;== ============================================================================

SetCapsLockState('AlwaysOff')

CapsLock & Space::
CapsLock & Enter:: 
CapsLock & Tab:: {
    hk := HotkeySplit(thisHotkey)
    Send('{' hk[2] '}{Left}')
}

CapsLock Up:: {
    if GetKeyState('CapsLock', 'T') {
        SetCapsLockState('AlwaysOff')
    } else {
        SetCapsLockState('AlwaysOn')
    }
}

;== =============================================================================
;== Modifiers
;== =============================================================================

;=== ============================================================================
;=== Mask
;=== ============================================================================

#^+Alt::
#^!Shift::
#+!Ctrl::
^+!LWin::
^+!RWin:: {
    MaskMenu()
}

#HotIf SetTitleMatchMode('RegEx') and not WinActive('ahk_exe .EXE$')
    ; Check if an Office app isn't active.
Alt:: MaskAlt()
MaskAlt() {
    SetKeyDelay(-1)
    SendEvent('{Blind}{Alt DownR}')
    MaskMenu()
    KeyWait('Alt')
    SendEvent('{Blind}{Alt Up}')
}
#HotIf

;=== ============================================================================
;=== NumLock
;=== ============================================================================

if GetKeyState('NumLock', 'T') {
    NumLockIndicatorFollowMouse()
}

#InputLevel 1
^Pause:: Send('{NumLock}')
        ; This hotkey exists because when Ctrl is down,
        ; NumLock produces the key code of Pause (while Pause produces CtrlBreak).
#InputLevel

/**
 * Display ToolTip while NumLock is on.
 */
~*NumLock:: NumLockIndicatorFollowMouse()
NumLockIndicatorFollowMouse() {
    toolTipNumLock() => ToolTip('NumLock On')

    Sleep(10)

    if GetKeyState('NumLock', 'T') {
        SetTimer(toolTipNumLock, 10)
    } else {
        SetTimer(toolTipNumLock, 0)
        ToolTip()
    }
}

;=== ============================================================================
;=== F13 - F24
;=== ============================================================================

MapF13UntilF24()
MapF13UntilF24() {
    remap := (num) => Send('{Blind!^}{F' (num + 12) '}')

    Loop 12 {
        Hotkey('#^!+F' A_Index, remap.bind(A_Index))
    }
}

;== ============================================================================
;== Remaps in Other Programs
;== ============================================================================

/**
 * (In order of decreasing input level)
 * * RAKK Lam-Ang Pro FineTuner:
 * *     Fn::         CapsLock
 * *     CapsLock::   BS
 * *     BS::         `
 * *     `::          NumLock
 * * 
 * *     Ins::        Home
 * *     Home::       PgUp
 * *     PgUp::       Ins
 * * 
 * * KeyTweak:
 * *     AppsKey::    RWin
 * * 
 * * PowerToys:
 * *     ScrollLock:: AppsKey
*/

;== ============================================================================
;== BackSpace
;== ============================================================================

#HotIf RegExMatch(ControlGetFocus.tryCall('A'), '^Edit\d+$')
/**
 * ^BS doesn't natively work,
 * so work around that.
 */
^BS:: {
    if GetSelected() {
        Send('{Del}')
    } else {
        Send('{Ctrl Down}{Shift Down}{Left}{Del}{Shift Up}{Ctrl Up}')
                ; Delete last word typed.
    }
}
#HotIf

+BS::  Send('{Del}')
^+BS:: Send('{Ctrl Down}{Del}{Ctrl Up}')

;= =============================================================================
;= Characters
;= =============================================================================

;== ============================================================================
;== Space <-> Underscore
;== ============================================================================

#InputLevel 1
+Space:: Send('_')

/**
 * Send square root symbol.
 */
+-:: {
    if WinActive('Desmos ahk_exe msedge.exe') or WinActive('ahk_exe EXCEL.EXE') {
        Send('sqrt')
    } else {
        Send('{U+221A}')
    }
}
#InputLevel

;== =============================================================================
;== Hotstrings
;== =============================================================================
; For each Unicode character sent, the hotstring abbreviation is the HTML entity (or something intuitive).

~^z:: {
    if A_PriorHotkey ~= '^:' {
            ; Match hotstrings.
        Send('{Ctrl Down}z{Ctrl Up}')
                ; Send an extra ^z to go back to the abbreviation.
    }
}

#Hotstring EndChars `t

:?cx:&deg;::    Send('{U+00B0}')
        ; Degree.

:?cx:&lr;::     Send('{U+200E}')
        ; Left-to-right mark.

:?cx:&la;::     Send('{U+2190}')
        ; Left arrow.
:?cx:&ra;::     Send('{U+2192}')
        ; Right arrow.

:?cx:&md;::     Send('{U+2014}')
        ; Em dash.
:?cx:&nd;::     Send('{U+2013}')
        ; En dash.

:?cx:&N~;::     Send('{U+00D1}')
        ; N tilde.
:?cx:&n~;::     Send('{U+00F1}')
        ; n tilde.

:?cx:&peso;::   Send('{U+20B1}')

:*?b0c:&tab:: {
    ih := InputHook('L3 V', '{Tab}')
    ih.keyOpt('{Tab}', 'S')
    ih.start()
    ih.wait()

    if not ih.Endkey {
        return
    }
    tabs := ''

    if ih.input = ';' {
        tabs := A_Tab
    } else if RegExMatch(ih.Input, '\A(\d);\z', &match) {
        Loop match[1] {
            tabs .= A_Tab
        }
    }
    Send('{Ctrl Down}{Shift Down}{Left}{Ctrl Up}{Left}{Shift Up}')
            ; Erase the abbreviation.
    SendInstantRaw(tabs)
}

;=== ============================================================================
;=== Math and Science
;=== ============================================================================

:?cx:&bullet;::  Send('{U+2219}')

:?cx:&infin;::   Send('{U+221E}')
        ; Infinity.

:?cx:&ne;::      Send('{U+2260}')
        ; Not equal.
:?cx:&le;::      Send('{U+2264}')
        ; Lesser than or equal.
:?cx:&ge;::      Send('{U+2265}')
        ; Greater than or equal.
:?cx:&pm;::      Send('{U+00B1}')
        ; Plus-minus.

:?cx:&radic3;::  Send('{U+221B}')
:?cx:&radic4;::  Send('{U+221C}')

:?cx:&scriptM;:: Send('{U+2133}')

:?cx:&times;::   Send('{U+00D7}')

:?cx:&xbar;::    Send('{U+0078}{U+0305}')

;=== ============================================================================
;=== Greek Alphabet
;=== ============================================================================

:?cx:&Alpha;::    Send('{U+0391}')
:?cx:&alpha;::    Send('{U+03B1}')
:?cx:&Beta;::     Send('{U+0392}')
:?cx:&beta;::     Send('{U+03B2}')
:?cx:&Gamma;::    Send('{U+0393}')
:?cx:&gamma;::    Send('{U+03B3}')
:?cx:&Delta;::    Send('{U+0394}')
:?cx:&delta;::    Send('{U+03B4}')
:?cx:&Epsilon;::  Send('{U+0395}')
:?cx:&epsilon;::  Send('{U+03B5}')
:?cx:&Zeta;::     Send('{U+0396}')
:?cx:&zeta;::     Send('{U+03B6}')
:?cx:&Eta;::      Send('{U+0397}')
:?cx:&eta;::      Send('{U+03B7}')
:?cx:&Theta;::    Send('{U+0398}')
:?cx:&theta;::    Send('{U+03B8}')
:?cx:&Iota;::     Send('{U+0399}')
:?cx:&iota;::     Send('{U+03B9}')
:?cx:&Kappa;::    Send('{U+039A}')
:?cx:&kappa;::    Send('{U+03BA}')
:?cx:&Lambda;::   Send('{U+039B}')
:?cx:&lambda;::   Send('{U+03BB}')
:?cx:&Mu;::       Send('{U+039C}')
:?cx:&mu;::       Send('{U+03BC}')
:?cx:&Nu;::       Send('{U+039D}')
:?cx:&nu;::       Send('{U+03BD}')
:?cx:&Xi;::       Send('{U+039E}')
:?cx:&xi;::       Send('{U+03BE}')
:?cx:&Omicron;::  Send('{U+039F}')
:?cx:&omicron;::  Send('{U+03BF}')
:?cx:&Pi;::       Send('{U+03A0}')
:?cx:&pi;::       Send('{U+03C0}')
:?cx:&Rho;::      Send('{U+03A1}')
:?cx:&rho;::      Send('{U+03C1}')
:?cx:&Sigma;::    Send('{U+03A3}')
:?cx:&sigma;::    Send('{U+03C3}')
:?cx:&varsigma;:: Send('{U+03C2}')
:?cx:&Tau;::      Send('{U+03A4}')
:?cx:&tau;::      Send('{U+03C4}')
:?cx:&Upsilon;::  Send('{U+03A5}')
:?cx:&upsilon;::  Send('{U+03C5}')
:?cx:&Phi;::      Send('{U+03A6}')
:?cx:&phi;::      Send('{U+03C6}')
:?cx:&Chi;::      Send('{U+03A7}')
:?cx:&chi;::      Send('{U+03C7}')
:?cx:&Psi;::      Send('{U+03A8}')
:?cx:&psi;::      Send('{U+03C8}')
:?cx:&Omega;::    Send('{U+03A9}')
:?cx:&omega;::    Send('{U+03C9}')
