#Include <default-settings>
#Include <constants>
#Include <functions>
#Include <classes>

;===============================================================================
; In-App
;===============================================================================

BrowserHotkeys(() => GetKeyState('NumLock', 'T'))
BrowserHotkeys(hotIfExFn) {
    C_Hotkey.Browser.searchSelectedAsUrl('u', , hotIfExFn)
    C_Hotkey.Browser.searchSelectedAsUrl('g', 'https://www.google.com/search?q=', hotIfExFn)
    C_Hotkey.Browser.searchSelectedAsUrl('y', 'https://www.youtube.com/results?search_query=', hotIfExFn)
}

#HotIf WinActive('ahk_exe msedge.exe')
^e:: Send('{Ctrl Down}{Shift Down},{Shift Up}{Ctrl Up}')
        ; Toggle vertical tabs.

#HotIf WinActive('ahk_exe Notion.exe')
!Left::  Send('{Ctrl Down}[{Ctrl Up}')
        ; Go back.
!Right:: Send('{Ctrl Down}]{Ctrl Up}')
        ; Go forward.

^+f:: Send('{Ctrl Down}{Shift Down}h{Shift Up}{Ctrl Up}')
        ; Apply last text or highlight color used.

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

/**
 * Spicetify
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

;-------------------------------------------------------------------------------
; Zoom
;-------------------------------------------------------------------------------

#HotIf WinActive(K_CLASSES['ZOOM']['MEETING']) and WinWaitActive(K_CLASSES['ZOOM']['TOOLBAR'], , 0.1)
~#Down:: {
    winPid := WinGetPid()
    WinActivate('Zoom ahk_pid ' winPid)
        ; Activate minimized video/control window.
}

#HotIf WinActive(K_CLASSES['ZOOM']['WAIT_HOST']) or WinActive(K_CLASSES['ZOOM']['VID_PREVIEW'])
#Down:: WinMinimize()

#HotIf WinActive(K_CLASSES['ZOOM']['MIN_VID']) or WinActive(K_CLASSES['ZOOM']['MIN_CONTROL'])
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

#HotIf WinActive('ahk_pid ' WinGetPid.tryCall(K_CLASSES['ZOOM']['TOOLBAR']))
        ; Check if a meeting window is active.
!=::
Zoom_ThumbsUpReact(thisHotkey) {
    Zoom_OpenReactions(thisHotkey)
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

!e::
Zoom_OpenReactions(thisHotkey) {
    iconClick(imageFileName) {
        ImageSearch(&imageX, &imageY, controlX, controlY, controlX + controlW, controlY + controlH, '*50 images\' imageFileName '-icon.png')
        ControlClick('x' imageX ' y' imageY)
    }

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

    Loop {
        try {
            iconClick('reactions')
        } catch {
        } else {
            return
        }
        try {
            iconClick('more')
        } catch {
        } else {
            break
        }
        if A_Index = 2 {
            exit
        }
        Send('{Tab}')
                ; Maybe the reason the icon wasn't found was because there was a dotted rectangle surrounding it,
                ; so Send('{Tab}') to move the rectangle to a different item.
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

    virtualScreenW := SysGet(78)
    virtualScreenH := SysGet(79)
    ImageSearch(&imageX, &imageY, 0, 0, virtualScreenW, virtualScreenH, '*50 images\reactions-menu-item.png')
    
    Click(imageX ' ' imageY)
    Sleep(10)
    MouseMove(mouseX, mouseY)
}
#HotIf

;===============================================================================
; Run and Activate
;===============================================================================

#HotIf GetKeyState('NumLock', 'T')
d::
WinOpenDir(thisHotkey) {
    winPid := WinGetPID('A')
    winPath := ProcessGetPath(winPid)
    winDir := RegExReplace(winPath, '\\[^\\]+$')
    Run(winDir)
}

+d::
RunSelectedAsDir(thisHotkey) {
    dir := GetSelectedElseExit()

    while RegExMatch(dir, '%(.+?)%', &match) {
        env := EnvGet(match[1])
        dir := StrReplace(dir, match[], env)
    }
    Run(dir)
}
#HotIf

#!c:: ActivateRecentElseRun('C:\Users\Zach Poblete\Pictures\Camera Roll')
#!v:: Run('App volume and device preferences', 'C:\Windows')

GroupAdd('ExplorerWins', 'ahk_class CabinetWClass')
GroupAdd('PhotoWins', ' ' K_CHARS['LEFT_TO_RIGHT_MARK'] '- Photos$ ahk_exe ApplicationFrameHost.exe')
GroupAdd('ZoomWins', 'ahk_class Z ahk_exe Zoom.exe', , , 'ZPToolBarParentWnd')

#+e:: ActivateRecentElseRun('explorer', , 'ahk_group ExplorerWins')
#+p:: ActivateRecentIfExists.bind('ahk_group PhotoWins').setWinModeAndCall('RegEx')
#+z::
Zoom_ActivateElseRun(thisHotkey) {
    if not WinExist('ahk_exe Zoom.exe') {
        Run('Zoom', 'C:\Users\Zach Poblete\AppData\Roaming\Zoom\bin')
    } else if WinExist(K_CLASSES['ZOOM']['HIDDEN_TOOLBAR'])
            or WinExist('Zoom ahk_pid ' WinGetPid.tryCall(K_CLASSES['ZOOM']['TOOLBAR'])) {
                    ; Check if a visible meeting window exists.
        WinActivate()
    } else {
        ActivateRecentIfExists.bind('ahk_group ZoomWins').setWinModeAndCall('RegEx')
                ; Activate most recent visible Zoom window.
    }
}

;===============================================================================
; Multimedia
;===============================================================================

#HotIf GetKeyState('CapsLock', 'T')
$Volume_Up::   DisplayAndSetVolume(1)
$Volume_Down:: DisplayAndSetVolume(-1)

DisplayAndSetVolume(variation) {
    newVol := SoundGetVolume() + variation
    volDirection := (variation > 0 or Round(newVol) = 1)? 'Up' : 'Down'
            ; Fsr Round(newVol) before this point doesn't work.

    Send('{Volume_' volDirection '}')
            ; Vary volume by 2,
            ; and, importantly, display volume slider (and media overlay).
    SoundSetVolume(newVol)
            ; Override that normal variation of 2.
}
#HotIf

if not ProcessExist('brightness-setter.exe') {
    Run('brightness-setter')
}

OnExit((reason, code) => CloseBrightnessSetter())
CloseBrightnessSetter() {
    if ProcessExist('brightness-setter.exe') {
        ProcessClose('brightness-setter.exe')
        ProcessWaitClose('brightness-setter.exe')
    }
}

/**
 * * brightness-setter.exe:
 * *     #PgUp:: C_BrightnessSetter.setBrightness(2)
 * *     #PgDn:: C_BrightnessSetter.setBrightness(-2)
 */

#F5::
ProcessRestart(thisHotkey) {
    WinExist('A')

    winPid := WinGetPID()
    winPath := ProcessGetPath(winPid)

    WinClose()
    ProcessWaitClose(winPid)
    Run(winPath)
}

#F11::  Media_Prev
#F12::  Media_Next
Pause:: Media_Play_Pause

PrintScreen:: Send('{LWin Down}{Alt Down}{PrintScreen}{Alt Up}{LWin Up}')
        ; Save screenshot of window.

;===============================================================================
; Remap
;===============================================================================

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

;===============================================================================
; Modifiers
;===============================================================================

if GetKeyState('NumLock', 'T') {
    ToolTip('NumLock On')
}

#InputLevel 1
^Pause:: Send('{NumLock}')
        ; When Ctrl is down, NumLock produces the key code of Pause while Pause produces CtrlBreak.
#InputLevel

/**
 * Display ToolTip while NumLock is on.
 */
~*NumLock:: {
    SetTimer(logic, -10)
    logic() {
        toolTipNumLock() => ToolTip('NumLock On')

        if GetKeyState('NumLock', 'T') {
            SetTimer(toolTipNumLock, 10)
        } else {
            SetTimer(toolTipNumLock, 0)
            ToolTip()
        }
    }
}

~*Alt:: {
    if not WinActive.bind('ahk_exe .EXE$').setWinModeAndCall('RegEx') {
            ; Check if an Office app isn't active.
        Send(K_KEYS['MENU_MASK'])
        KeyWait('Alt')
                ; Prevent the masking key from being repeatedly sent.
    }
}

/**
 * Don't open the Start Menu if Win key is held down for longer than 500 ms.
 */
LWin::
RWin:: {
        Send('{' thisHotkey ' Down}')
        KeyWait(thisHotkey)

        if A_PriorKey = thisHotkey and A_TimeSinceThisHotkey > 500 {
            Send(K_KEYS['MENU_MASK'])
        }
        Send('{' thisHotkey ' Up}')
    }

;===============================================================================
; Hotstrings
;===============================================================================
; For each Unicode character sent, the hotstring abbreviation is the HTML entity (or something intuitive).

~^z:: {
    if A_PriorHotkey ~= '^:' {
            ; Match hotstrings.
        Send('{Ctrl Down}z{Ctrl Up}')
                ; Send an extra ^z to go back to the abbreviation.
    }
}

#Hotstring EndChars `t
/** 
 * * Sorry if the hotstrings look weird!
 * * Currently, when using the X option, whitespace isn't allowed before the expression.
 * * In v1, I made heavy use of whitespace to align my Send commands.
 * * I've worked around this bug by adding the whitespace after the function's open parenthesis.
 * TODO: When this is fixed, revert the hotstrings back to normal.
 */

:?cx:&deg;::Send(   '{U+00B0}')

:?cx:&la;::Send(    '{U+2190}')
        ; Left arrow.
:?cx:&ra;::Send(    '{U+2192}')
        ; Right arrow.

:?cx:&mdash;::Send( '{U+2014}')
:?cx:&ndash;::Send( '{U+2013}')

:?cx:&Ntilde;::Send('{U+00D1}')
:?cx:&ntilde;::Send('{U+00F1}')

:?cx:&peso;::Send(  '{U+20B1}')

:*?b0c:&tab:: {
    ih := InputHook('L3 V', '{Tab}')
    ih.keyOpt('{Tab}', 'S')
    ih.Start()
    ih.Wait()

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
    Send('{Ctrl Down}{Shift Down}{Left 2}{Ctrl Up}{Left}{Shift Up}')
            ; Erase the abbreviation.
    SendInstantRaw(tabs)
}

;-------------------------------------------------------------------------------
; Math and Science
;-------------------------------------------------------------------------------

:?cx:&bullet;::Send( '{U+2219}')

:?cx:&infin;::Send(  '{U+221E}')

:?cx:&ne;::Send(     '{U+2260}')
        ; Not equal.
:?cx:&le;::Send(     '{U+2264}')
        ; Lesser than or equal.
:?cx:&ge;::Send(     '{U+2265}')
        ; Greater than or equal.
:?cx:&pm;::Send(     '{U+00B1}')
        ; Plus-minus.

:?cx:&radic3;::Send( '{U+221B}')
:?cx:&radic4;::Send( '{U+221C}')

:?cx:&scriptM;::Send('{U+2133}')

:?cx:&times;::Send(  '{U+00D7}')

:?cx:&xbar;::Send(   '{U+0078}{U+0305}')

;-------------------------------------------------------------------------------
; Greek Alphabet
;-------------------------------------------------------------------------------

:?cx:&Alpha;::Send(   '{U+0391}')
:?cx:&alpha;::Send(   '{U+03B1}')
:?cx:&Beta;::Send(    '{U+0392}')
:?cx:&beta;::Send(    '{U+03B2}')
:?cx:&Gamma;::Send(   '{U+0393}')
:?cx:&gamma;::Send(   '{U+03B3}')
:?cx:&Delta;::Send(   '{U+0394}')
:?cx:&delta;::Send(   '{U+03B4}')
:?cx:&Epsilon;::Send( '{U+0395}')
:?cx:&epsilon;::Send( '{U+03B5}')
:?cx:&Zeta;::Send(    '{U+0396}')
:?cx:&zeta;::Send(    '{U+03B6}')
:?cx:&Eta;::Send(     '{U+0397}')
:?cx:&eta;::Send(     '{U+03B7}')
:?cx:&Theta;::Send(   '{U+0398}')
:?cx:&theta;::Send(   '{U+03B8}')
:?cx:&Iota;::Send(    '{U+0399}')
:?cx:&iota;::Send(    '{U+03B9}')
:?cx:&Kappa;::Send(   '{U+039A}')
:?cx:&kappa;::Send(   '{U+03BA}')
:?cx:&Lambda;::Send(  '{U+039B}')
:?cx:&lambda;::Send(  '{U+03BB}')
:?cx:&Mu;::Send(      '{U+039C}')
:?cx:&mu;::Send(      '{U+03BC}')
:?cx:&Nu;::Send(      '{U+039D}')
:?cx:&nu;::Send(      '{U+03BD}')
:?cx:&Xi;::Send(      '{U+039E}')
:?cx:&xi;::Send(      '{U+03BE}')
:?cx:&Omicron;::Send( '{U+039F}')
:?cx:&omicron;::Send( '{U+03BF}')
:?cx:&Pi;::Send(      '{U+03A0}')
:?cx:&pi;::Send(      '{U+03C0}')
:?cx:&Rho;::Send(     '{U+03A1}')
:?cx:&rho;::Send(     '{U+03C1}')
:?cx:&Sigma;::Send(   '{U+03A3}')
:?cx:&sigma;::Send(   '{U+03C3}')
:?cx:&varsigma;::Send('{U+03C2}')
:?cx:&Tau;::Send(     '{U+03A4}')
:?cx:&tau;::Send(     '{U+03C4}')
:?cx:&Upsilon;::Send( '{U+03A5}')
:?cx:&upsilon;::Send( '{U+03C5}')
:?cx:&Phi;::Send(     '{U+03A6}')
:?cx:&phi;::Send(     '{U+03C6}')
:?cx:&Chi;::Send(     '{U+03A7}')
:?cx:&chi;::Send(     '{U+03C7}')
:?cx:&Psi;::Send(     '{U+03A8}')
:?cx:&psi;::Send(     '{U+03C8}')
:?cx:&Omega;::Send(   '{U+03A9}')
:?cx:&omega;::Send(   '{U+03C9}')
