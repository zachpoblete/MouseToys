#Include <default-settings>
#Include <constants>
#Include <functions>
#Include <classes>

;====================================================================================================
; In-App
;====================================================================================================

BrowserHotkeys () => GetKeyState('NumLock', 'T')
BrowserHotkeys(hotif_ex_functor) {
    C_Hotkey.Browser.gotoSelectedFolder  'f', hotif_ex_functor
    C_Hotkey.Browser.searchSelectedAsUrl 'u', , hotif_ex_functor
    C_Hotkey.Browser.searchSelectedAsUrl 'g', 'https://www.google.com/search?q=', hotif_ex_functor
    C_Hotkey.Browser.searchSelectedAsUrl 'y', 'https://www.youtube.com/results?search_query=', hotif_ex_functor
}

#Hotif WinActive('ahk_exe msedge.exe')
^e:: Send '{Ctrl Down}{Shift Down},{Shift Up}{Ctrl Up}'  ; Toggle vertical tabs.

#Hotif WinActive('ahk_exe Notion.exe')
^+f:: Send '{Ctrl Down}{Shift Down}h{Shift Up}{Ctrl Up}'  ; Apply last text or highlight color used.

#Hotif WinActive('ahk_exe Spotify.exe')
; I switched the keyboard shortcuts for varying the navigation bar and friend activity widths.
; because when you increase the navigation bar width, the cover art grows taller
; hence assigning Down and Up to it
; and when you increase the friend activity width, the bar grows fatter
; hence assigning Left and Right to it:
!+Down::  Send '{Alt Down}{Shift Down}{Left}{Shift Up}{Alt Up}'   ; Decrease navigation bar width.
!+Up::    Send '{Alt Down}{Shift Down}{Right}{Shift Up}{Alt Up}'  ; Increase navigation bar width.
!+Left::  Send '{Alt Down}{Shift Down}{Down}{Shift Up}{Alt Up}'   ; Increase friend activity width.
!+Right:: Send '{Alt Down}{Shift Down}{Up}{Shift Up}{Alt Up}'     ; Decrease friend activity width.

; Spicetify:
/*
keyboardShortcut-Quarter.js:
    !+l:: toggleLyrics
    !+q:: toggleQueue
    !+m:: openSpicetifyMarketPlace
*/

; !+2 goes to Your Podcasts, but because of the Hide Podcasts extension,
; Your Podcasts isn't listed in Your Library, so !+2 should redirect to Your Artists instead.
; The same logic applies to !+3 and !+4:
!+2:: Send '{Alt Down}{Shift Down}3{Shift Up}{Alt Up}'  ; Go to your artists.
!+3:: Send '{Alt Down}{Shift Down}4{Shift Up}{Alt Up}'  ; Go to your albums.
!+4:: return
#Hotif

;----------------------------------------------------------------------------------------------------
; Zoom
;----------------------------------------------------------------------------------------------------

#Hotif WinActive(CLASSES['ZOOM']['MEETING']) and WinWaitActive(CLASSES['ZOOM']['TOOLBAR'], , 0.1)
~#Down:: WinActivate 'Zoom ahk_pid ' . TryWinGetPid()  ; Activate minimized video/control.

#Hotif WinActive(CLASSES['ZOOM']['WAIT_HOST']) or WinActive(CLASSES['ZOOM']['VID_PREVIEW'])
#Down:: WinMinimize

#Hotif WinActive(CLASSES['ZOOM']['MIN_VID']) or WinActive(CLASSES['ZOOM']['MIN_CONTROL'])
#Up:: {
    WinGetPos , , , &win_h
    ControlClick 'x200 y' . win_h - 30  ; Exit minimized video.
}

#Hotif WinActive(CLASSES['ZOOM']['HOME']) and not WinExist('Zoom ahk_pid ' . TryWinGetPid(CLASSES['ZOOM']['TOOLBAR']))  ; Check if a visible meeting window exists.
!F4:: ProcessClose 'Zoom.exe'  ; Can't use WinClose because that minimizes here.

#Hotif WinActive('ahk_pid ' . TryWinGetPid(CLASSES['ZOOM']['TOOLBAR']))  ; Check if a meeting window is active.
!=::
    Zoom_GiveThumbsUp(this_hk) {
        Zoom_OpenReactions(this_hk)
        SetTimer select, -50
        select() {
            WinGetPos , , &win_w, &win_h, CLASSES['ZOOM']['REACTION']
            ImageSearch &image_x, &image_y, 0, 0, win_w, win_h, '*60 images\thumbs up.png'
            ControlClick 'x' . image_x . ' y' image_y, CLASSES['ZOOM']['MEETING']
        }
    }

!e::
    Zoom_OpenReactions(this_hk) {
        if WinExist(CLASSES['ZOOM']['REACTION']) {
            WinActivate
            return
        }
        else if not WinExist(CLASSES['ZOOM']['MEETING']) {
            return
        }

        WinActivate
        WinGetPos , , &win_w, &win_h

        if not ImageSearch(&image_x, &image_y, 0, win_h - 60, win_w, win_h, '*60 images\reactions.png') {
            ControlClick 'x' . image_x . ' y' image_y, CLASSES['ZOOM']['MEETING']  ; Search meeting controls region.
            return
        }
        ImageSearch &image_x, &image_y, 0, win_h - 60, win_w, win_h, '*60 images\more.png'
        ControlClick 'x' . image_x . ' y' image_y, CLASSES['ZOOM']['MEETING']

        SetTimer select, -150
        select() {
            if ImageSearch(&image_x, &image_y, 0, win_h - 60, win_w, win_h, '*60 images\apps.png')
                Send '{Up}'
            Send '{Up}'
            SetTimer () => Send('{Space}'), -10
        }
    }
#Hotif

;====================================================================================================
; Activate
;====================================================================================================

#!c:: ActivateElseRun 'C:\Users\Zach Poblete\Pictures\Camera Roll'
#!v:: Run 'App volume and device preferences', 'C:\Windows'

GroupAdd 'ExplorerWins', 'ahk_class CabinetWClass'
GroupAdd 'PhotoWins', A_Space . CHARS["LEFT_TO_RIGHT_MARK"] . "- Photos$ ahk_exe ApplicationFrameHost.exe"
GroupAdd 'ZoomWins', 'ahk_class Z ahk_exe Zoom.exe', , , 'ZPToolBarParentWnd'

#+e:: ActivateElseRun 'explorer.exe', , 'ahk_group ExplorerWins'
#+p:: TitleMatch 'RegEx', () => GroupActivateRelIfExists('PhotoWins')
#+z::
    Zoom_ActivateElseRun(this_hk) {
        if not WinExist('ahk_exe Zoom.exe')
            Run 'Zoom', 'C:\Users\Zach Poblete\AppData\Roaming\Zoom\bin'
        else if WinExist(CLASSES['ZOOM']['HIDDEN_TOOLBAR']) or WinExist('Zoom ahk_pid ' . TryWinGetPid(CLASSES['ZOOM']['TOOLBAR']))  ; Check if a visible Zoom meeting window exists.
            WinActivate
        else
            TitleMatch('RegEx', () => GroupActivateRelIfExists('ZoomWins'))  ; Activate visible Zoom windows.
    }

;====================================================================================================
; Multimedia
;====================================================================================================

#Hotif GetKeyState('CapsLock', 'T')
$Volume_Up::   DisplayAndSetVolume 1
$Volume_Down:: DisplayAndSetVolume -1

DisplayAndSetVolume(variation) {
    new_vol := SoundGetVolume() + variation
    vol_direction := (variation > 0 or Round(new_vol) = 1) ? 'Up' : 'Down'  ; Idkwb Round(new_vol) before this point doesn't work.

    Send '{Volume_' . vol_direction . '}'  ; Vary volume by 2, and, importantly, display volume slider (and media overlay).
    SoundSetVolume new_vol  ; Override that normal variation of 2.
}
#Hotif

if not ProcessExist('brightness-setter.exe')
    Run 'brightness-setter'

OnExit CloseBrightnessSetter
CloseBrightnessSetter(reason, code) {
    if ProcessExist('brightness-setter.exe')
        ProcessClose 'brightness-setter.exe'
    ProcessWaitClose 'brightness-setter.exe'
}

/*
C_BrightnessSetter:
    #PgUp:: C_BrightnessSetter.setBrightness(2)
    #PgDn:: C_BrightnessSetter.setBrightness(-2)
*/

Pause:: Media_Play_Pause
F9::    Media_Prev
F10::   Media_Next

PrintScreen:: Send '{LWin Down}{Alt Down}{PrintScreen}{Alt Up}{LWin Up}'

;====================================================================================================
; Remap
;====================================================================================================

/*

(In order of decreasing input level)

RAKK Lam-Ang Pro FineTuner:
    Fn::       CapsLock
    Capslock:: BS
    BS::       `
    `::        NumLock

    Ins::      Home
    Home::     PgUp
    PgUp::     Ins

KeyTweak:
    AppsKey::  RWin

PowerToys:
    ScrollLock:: AppsKey

AHK:

*/

#Hotif RegExMatch(ControlGetFocus('A'), '^Edit\d+$')
^BS:: {  ; This hotkey doesn't natively work, so work around that.
    if GetSelected()
        Send '{Del}'
    else
        Send '{Ctrl Down}{Shift Down}{Left}{Del}{Shift Up}{Ctrl Up}'  ; Delete last word typed.
}

#Hotif
+BS::  Send '{Del}'
^+BS:: Send '{Ctrl Down}{Del}{Ctrl Up}'

;====================================================================================================
; Modifiers
;====================================================================================================

if GetKeyState('NumLock', 'T')
    ToolTip 'NumLock On'

#InputLevel 1
^Pause:: Send '{NumLock}'  ; When Ctrl is down, NumLock produces the key code of Pause while Pause produces CtrlBreak.
#InputLevel

~*NumLock:: {
    SetTimer logic, -10
    logic() {
        toolTipNumLock() => ToolTip('NumLock On')

        if GetKeyState('NumLock', 'T') {
            SetTimer toolTipNumLock, 10
        }
        else {
            SetTimer toolTipNumLock, 0
            ToolTip
        }
    }
}

~*Alt:: {
    if not TitleMatch('RegEx', () => WinActive('ahk_exe .EXE$'))  ; Check if an Office app isn't active.
        Send '{Ctrl}'
}

LWin::
RWin:: 
    WinKey(win_key) {
        Send '{' . win_key . ' Down}'
        KeyWait win_key

        if A_PriorKey = win_key and A_TimeSinceThisHotkey > 500
            Send '{Ctrl}'
        Send '{' . win_key . ' Up}'
    }

;====================================================================================================
; Special Chars.
;====================================================================================================
; For each Unicode character sent, the hostring abbreviation is the HTML entity (or something intuitive).

#InputLevel 1
+Space:: Send '_'
#InputLevel

#Hotstring EndChars `n`t

; Sorry if the hotstrings look weird!
; Currently, if you're using the X option,
; whitespace isn't allowed before the expression.
; In v1, I made heavy use of whitespace to align my Send commands.
; I've worked around this bug by adding the whitespace after the function name instead.
; TODO: When this is fixed, revert the hotstrings back to normal.

:?cx:&deg;::Send        '{U+00B0}'

:?cx:&leftarrow;::Send  '{U+2190}'
:?cx:&rightarrow;::Send '{U+2192}'

:?cx:&mdash;::Send      '{U+2014}'
:?cx:&ndash;::Send      '{U+2013}'

:?cx:&Ntilde;::Send     '{U+00D1}'
:?cx:&ntilde;::Send     '{U+00F1}'

:?cx:&peso;::Send       '{U+20B1}'

:*?b0c:&tab:: {
    ih := InputHook('L3 V', '{Enter}{Tab}')
    ih.KeyOpt '{Enter}{Tab}', 'S'
    ih.Start
    ih.Wait

    if not (ih.Endkey or ih.Input)
        return

    tabs := ''

    if ih.Input = ';'
        tabs := '	'
    else if RegExMatch(ih.Input, '\A(\d);\z', &match)
        Loop match[1]
            tabs .= '	'

    Send '{Ctrl Down}{Shift Down}{Left}{Ctrl Up}{Left}{Shift Up}'  ; Erase the abbreviation.
    SendInstantRaw tabs
}

;----------------------------------------------------------------------------------------------------
; Math and Science
;----------------------------------------------------------------------------------------------------

#InputLevel 1
+-:: {
    if WinActive('Desmos ahk_exe msedge.exe') or WinActive('ahk_exe EXCEL.EXE')
        Send 'sqrt'
    else
        Send '{U+221A}'  ; Send square root symbol.
}
#InputLevel

:?cx:&bullet;::Send  '{U+2219}'

:?cx:&infin;::Send   '{U+221E}'

:?cx:&ne;::Send      '{U+2260}'
:?cx:&le;::Send      '{U+2264}'
:?cx:&ge;::Send      '{U+2265}'
:?cx:&pm;::Send      '{U+00B1}'

:?cx:&radic3;::Send  '{U+221B}'
:?cx:&radic4;::Send  '{U+221C}'

:?cx:&scriptM;::Send '{U+2133}'

:?cx:&times;::Send   '{U+00D7}'

:?cx:&xbar;::Send    '{U+0078}{U+0305}'

;----------------------------------------------------------------------------------------------------
; Greek Alphabet
;----------------------------------------------------------------------------------------------------

:?cx:&Alpha;::Send    '{U+0391}'
:?cx:&alpha;::Send    '{U+03B1}'
:?cx:&Beta;::Send     '{U+0392}'
:?cx:&beta;::Send     '{U+03B2}'
:?cx:&Gamma;::Send    '{U+0393}'
:?cx:&gamma;::Send    '{U+03B3}'
:?cx:&Delta;::Send    '{U+0394}'
:?cx:&delta;::Send    '{U+03B4}'
:?cx:&Epsilon;::Send  '{U+0395}'
:?cx:&epsilon;::Send  '{U+03B5}'
:?cx:&Zeta;::Send     '{U+0396}'
:?cx:&zeta;::Send     '{U+03B6}'
:?cx:&Eta;::Send      '{U+0397}'
:?cx:&eta;::Send      '{U+03B7}'
:?cx:&Theta;::Send    '{U+0398}'
:?cx:&theta;::Send    '{U+03B8}'
:?cx:&Iota;::Send     '{U+0399}'
:?cx:&iota;::Send     '{U+03B9}'
:?cx:&Kappa;::Send    '{U+039A}'
:?cx:&kappa;::Send    '{U+03BA}'
:?cx:&Lambda;::Send   '{U+039B}'
:?cx:&lambda;::Send   '{U+03BB}'
:?cx:&Mu;::Send       '{U+039C}'
:?cx:&mu;::Send       '{U+03BC}'
:?cx:&Nu;::Send       '{U+039D}'
:?cx:&nu;::Send       '{U+03BD}'
:?cx:&Xi;::Send       '{U+039E}'
:?cx:&xi;::Send       '{U+03BE}'
:?cx:&Omicron;::Send  '{U+039F}'
:?cx:&omicron;::Send  '{U+03BF}'
:?cx:&Pi;::Send       '{U+03A0}'
:?cx:&pi;::Send       '{U+03C0}'
:?cx:&Rho;::Send      '{U+03A1}'
:?cx:&rho;::Send      '{U+03C1}'
:?cx:&Sigma;::Send    '{U+03A3}'
:?cx:&sigma;::Send    '{U+03C3}'
:?cx:&varsigma;::Send '{U+03C2}'
:?cx:&Tau;::Send      '{U+03A4}'
:?cx:&tau;::Send      '{U+03C4}'
:?cx:&Upsilon;::Send  '{U+03A5}'
:?cx:&upsilon;::Send  '{U+03C5}'
:?cx:&Phi;::Send      '{U+03A6}'
:?cx:&phi;::Send      '{U+03C6}'
:?cx:&Chi;::Send      '{U+03A7}'
:?cx:&chi;::Send      '{U+03C7}'
:?cx:&Psi;::Send      '{U+03A8}'
:?cx:&psi;::Send      '{U+03C8}'
:?cx:&Omega;::Send    '{U+03A9}'
:?cx:&omega;::Send    '{U+03C9}'
