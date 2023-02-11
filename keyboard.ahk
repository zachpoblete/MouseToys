#Include <default-settings>
#Include <globals>
#Include <constants>
#Include <functions>
#Include <classes>

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

    check(groupName) {
        if not WinActive('ahk_group ' groupName) {
            return
        }
        Group%action%(groupName)
        exit
    }
}

;= =============================================================================
;= All Apps
;= =============================================================================

;== ============================================================================
;== Disable
;== ============================================================================

^+w:: return

#c:: return

;== ============================================================================
;== Macro Recorder
;== ============================================================================

#+!r:: MacroRecorder()
MacroRecorder() {
    switch ChordInput() {
    case 'n': Send('{Ctrl Down}{Shift Down}{F13}{Shift Up}{Ctrl Up}')
            ; Start new recording.
    case 'p': Send('{Ctrl Down}{Shift Down}{F14}{Shift Up}{Ctrl Up}')
            ; Playback.
    }
}

;== ============================================================================
;== Remap Shortcuts
;== ============================================================================

PrintScreen:: Send('{LWin Down}{Alt Down}{PrintScreen}{Alt Up}{LWin Up}')
        ; Save screenshot of window.

^y:: Send('{Ctrl Down}{Shift Down}z{Shift Up}{Ctrl Up}')
        ; More consistent redo.

;== ============================================================================
;== Restart
;== ============================================================================

#F5:: ProcessRestart()
ProcessRestart() {
    WinExist('A')

    winId := WinGetID()
    winProcessName := WinGetProcessName()
    winClass := WinGetClass()

    winProcessPath := ProcessGetPath(winProcessName)
    similarWinIds := WinGetList('ahk_class ' winClass ' ahk_exe ' winProcessName)

    if similarWinIds.length < 2 {
        WinClose()
        restartCurrentInstance()
        return
    }

    gui_RestartOptions := Gui()
    gui_RestartOptions.opt('-SysMenu')
    gui_RestartOptions.setFont('s9')
    gui_RestartOptions.add('Text', , 'Do you want to restart the current instance and close all other instances?')

    btn_AllInstances    := gui_RestartOptions.add('Button', 'Default y+20',
            'Restart current instance and close all other &instances')
    btn_CurrentInstance := gui_RestartOptions.add('Button', 'x+10', 'Just restart c&urrent instance')
    btn_Cancel          := gui_RestartOptions.add('Button', 'w70 x+10', '&Cancel')

    btn_AllInstances.onEvent('Click', onClick_Btn_AllInstances)
    btn_CurrentInstance.onEvent('Click', onClick_Btn_CurrentInstance)
    btn_Cancel.onEvent('Click', onClick_Btn_Cancel)

    gui_RestartOptions.show()

    onClick_Btn_AllInstances(guiCtrlObj, info) {
        for thisWinId in similarWinIds {
            WinClose(thisWinId)
        }
        gui_RestartOptions.destroy()
        restartCurrentInstance()
    }
    onClick_Btn_CurrentInstance(guiCtrlObj, info) {
        WinClose(winId)
        gui_RestartOptions.destroy()
        restartCurrentInstance()
    }
    onClick_Btn_Cancel(guiCtrlObj, info) {
        gui_RestartOptions.destroy()
    }

    restartCurrentInstance() {
        Sleep(1000)

        winDoesExist := WinWaitClose(winId, , 5)
        if not winDoesExist {
            MsgBox('Unable to close current instance')
            exit
        }

        Run(winProcessPath)
    }
}

;= =============================================================================
;= Characters
;= =============================================================================

;== ============================================================================
;== Hotstrings
;== ============================================================================
; For each Unicode character sent, the hotstring abbreviation is the HTML entity (or something intuitive).

~^z:: {
    if A_PriorHotkey ~= '^:' {
            ; Match hotstrings.
        Send('{Ctrl Down}z{Ctrl Up}')
                ; Send an extra ^z to go back to the abbreviation.
    }
}

#Hotstring EndChars `t

:?x:&l';::     Send('{U+2018}')
        ; Left single quotation mark.
:?x:&r';::     Send('{U+2019}')
        ; Right single quotation mark.
:?x:&l";::     Send('{U+201C}')
        ; Left double quotation mark.
:?x:&r";::     Send('{U+201D}')
        ; Right double quotation mark.

:?x:&deg;::    Send('{U+00B0}')
        ; Degree.

:?x:&lr;::     Send('{U+200E}')
        ; Left-to-right mark.

:?x:&la;::     Send('{U+2190}')
        ; Left arrow.
:?x:&ra;::     Send('{U+2192}')
        ; Right arrow.

:?x:&md;::     Send('{U+2014}')
        ; Em dash.

:?cx:&N~;::     Send('{U+00D1}')
        ; N tilde.
:?cx:&n~;::     Send('{U+00F1}')
        ; n tilde.

:?x:&peso;::   Send('{U+20B1}')

:*?b0:&tab:: {
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
    Send('{Shift Down}{Left}{Ctrl Down}{Left}{Ctrl Up}{Left}{Shift Up}')
            ; Erase the abbreviation.
            ; Although this version takes longer,
            ; it works on more text inputs.
    SendInstantRaw(tabs)
}

;=== ===========================================================================
;=== Greek Alphabet
;=== ===========================================================================

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

;=== ===========================================================================
;=== Math and Science
;=== ===========================================================================

:?x:&bullet;::  Send('{U+2219}')

:?x:&infin;::   Send('{U+221E}')
        ; Infinity.

:?x:&ne;::      Send('{U+2260}')
        ; Not equal.
:?x:&le;::      Send('{U+2264}')
        ; Lesser than or equal.
:?x:&ge;::      Send('{U+2265}')
        ; Greater than or equal.
:?x:&pm;::      Send('{U+00B1}')
        ; Plus-minus.

:?x:&radic3;::  Send('{U+221B}')
:?x:&radic4;::  Send('{U+221C}')

:?x:&scriptM;:: Send('{U+2133}')

:?x:&sqrt;::    Send('{U+221A}')

:?x:&times;::   Send('{U+00D7}')

:?x:&xbar;::    Send('{U+0078}{U+0305}')

;== ============================================================================
;== Space <-> Underscore
;== ============================================================================

#InputLevel 1
+Space:: Send('_')
+-::     Send('{U+2013}')
        ; En dash.
#InputLevel

;= =============================================================================
;= Multimedia
;= =============================================================================

;== ============================================================================
;== Media
;== ============================================================================

#HotIf GetKeyState('CapsLock', 'T')
#InputLevel 1
Volume_Mute:: vk13
        ; Pause key.
#InputLevel
#HotIf

Pause:: OneBtnRemote()
OneBtnRemote() {
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

;= =============================================================================
;= Run
;= =============================================================================

;== ============================================================================
;== Directory
;== ============================================================================

#HotIf GetKeyState('NumLock', 'T')
d:: WinOpenProcessDir()
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
    case 's': ActivatePowerToysRunPlugin('$')
            ; Search Windows settings.
    case 'v': Run('App volume and device preferences', 'C:\Windows')
    }
}

;= =============================================================================
;= Specific App
;= =============================================================================

#!m:: AppToggleMute()
AppToggleMute() {
    switch ChordInput() {
    case 'z': Send('{Ctrl Down}{Shift Down}{Alt Down}{F13}{Alt Up}{Shift Up}{Ctrl Up}')
    case 'd': Send('{Ctrl Down}{Shift Down}{Alt Down}{F14}{Alt Up}{Shift Up}{Ctrl Up}')
    }
}

;== ============================================================================
;== Adobe Reader
;== ============================================================================

#HotIf ControlClassNnFocused('ahk_exe AcroRd32.exe', '^AVL_AVView', true)
^Left::  Send('{Ctrl Down}{Shift Down}{Left}{Shift Up}{Ctrl Up}{Up}')
^Right:: Send('{Ctrl Down}{Shift Down}{Right}{Shift Up}{Ctrl Up}{Down}')

;~ hk := HkSplit(thisHotkey)
;~ horiz := '{' hk[2] '}'

;~ if horiz = '{Left}' {
;~     oppHoriz := '{Right}'
;~     vert := '{Up}'

;~ } else {
;~     oppHoriz := '{Left}'
;~     vert := '{Down}'
;~ }

;~ Send('{Ctrl Down}{Shift Down}' horiz '{Shift Up}{Ctrl Up}')
;~ selected := GetSelected()

;~ if not StrReplace(selected, ' ') {
;~     Send('{Ctrl Down}{Shift Down}' horiz '{Shift Up}{Ctrl Up}')
;~ }

;~ Sleep(30)
;~ Send(vert oppHoriz)

#HotIf

;== ============================================================================
;== Browsers
;== ============================================================================

;=== ===========================================================================
;=== Vimium C Commands
;=== ===========================================================================

#HotIf WinActive('ahk_exe msedge.exe') or WinActive('ahk_exe firefox.exe')
!;::  VimcCmd(1)
        ; LinkHints.activate.
+!;:: VimcCmd(2)
        ; LinkHints.activateEdit.
^!;:: VimcCmd(3)
        ; LinkHints.activateHover.

^!+c:: VimcCmd(4)
        ; LinkHints.activateCopyLinkUrl.
^!c::  VimcCmd(5)
        ; LinkHints.activateCopyLinkText.

^!Left::  VimcCmd(8)
        ; goPrevious.
^!Right:: VimcCmd(9)
        ; goNext.

^F6:: VimcCmd(10)
        ; nextFrame.

^!p::    VimcCmd(11)
        ; togglePinTab.
^+!d::   VimcCmd(12)
        ; duplicateTab.
^!r::    VimcCmd(13)
        ; reopenTab.
^!]::     VimcCmd(14)
        ; removeRightTab.
^+PgUp:: VimcCmd(15)
        ; moveTabLeft.
^+PgDn:: VimcCmd(16)
        ; moveTabRight.

^!d:: VimcCmd(17)
        ; scrollDown.
^!u:: VimcCmd(18)
        ; scrollUp.
!j::  VimcCmd(19)
        ; scrollDown count=3.
!k::  VimcCmd(20)
        ; scrollUp count=3.
!d::  VimcCmd(21)
        ; scrollPageDown.
!u::  VimcCmd(22)
        ; scrollPageUp.
^!j:: VimcCmd(23)
        ; scrollToBottom.
^!k:: VimcCmd(24)
        ; scrollToTop.

!h::  VimcCmd(25)
        ; scrollLeft.
!l::  VimcCmd(26)
        ; scrollRight.
^!h:: VimcCmd(27)
        ; scrollToLeft.
^!l:: VimcCmd(28)
        ; scrollToRight.

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

#':: ActivatePowerToysRunPlugin('<')
        ; Search open windows.

#;:: ActivatePowerToysRunPlugin('*')
        ; Search programs.

#/:: ActivatePowerToysRunPlugin('?')
        ; Search web.

#=:: ActivatePowerToysRunPlugin('=')
        ; Do mathematical calculations.

ActivatePowerToysRunPlugin(activationCmd) {
    DetectHiddenWindows(true)

    if not WinExist('ahk_exe PowerToys.PowerLauncher.exe') {
        return
    }
    Send('{LWin Down}{Space}{LWin Up}')
            ; Activate PowerToys Run.
    powerLauncherActive := WinWaitActive(, , 5)

    Send(activationCmd ' ')
}

#HotIf WinActive('ahk_exe PowerToys.PowerLauncher.exe')
!':: Send('{End}.exe{Ctrl Down}{Left}{Ctrl Up}{Left}')
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
+!Down::  Send('{Shift Down}{Alt Down}{Left}{Alt Up}{Shift Up}')
        ; Decrease navigation bar width.
+!Up::    Send('{Shift Down}{Alt Down}{Right}{Alt Up}{Shift Up}')
        ; Increase navigation bar width.
+!Left::  Send('{Shift Down}{Alt Down}{Down}{Alt Up}{Shift Up}')
        ; Increase friend activity width.
+!Right:: Send('{Shift Down}{Alt Down}{Up}{Alt Up}{Shift Up}')
        ; Decrease friend activity width.
#HotIf

;=== ===========================================================================
;=== Spicetify
;=== ===========================================================================

#HotIf WinActive('ahk_exe Spotify.exe')
/**
 * * keyboardShortcut-Quarter.js:
 * *     +!l:: toggleLyrics()
 * *     +!q:: toggleQueue()
 * *     +!m:: openSpicetifyMarketPlace()
 *
 * +!2 goes to Your Podcasts,
 * but because of the Hide Podcasts extension,
 * Your Podcasts isn't listed in Your Library,
 * so +!2 should redirect to Your Artists instead.
 * The same logic applies to +!3 and +!4.
 */
+!2:: Send('{Shift Down}{Alt Down}3{Alt Up}{Shift Up}')
        ; Go to Your Artists.
+!3:: Send('{Shift Down}{Alt Down}4{Alt Up}{Shift Up}')
        ; Go to Your Albums.
+!4:: return
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
    if not WinActive() {
            ; Check if the meeting window isn't active.
        WinActivate()
    }

    if not ControlGetVisible(K_CONTROLS['ZOOM']['MEETING_CONTROLS']) {
        ControlShow(K_CONTROLS['ZOOM']['MEETING_CONTROLS'])
    }
    ControlGetPos(&controlX, &controlY, &controlW, &controlH, K_CONTROLS['ZOOM']['MEETING_CONTROLS'])
    
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
;== BackSpace
;== ============================================================================

#HotIf ControlClassNnFocused('A', '^Edit\d+$', true)
        or ControlClassNnFocused('ahk_exe AcroRd32.exe', '^AVL_AVView', true)
        or WinActive('ahk_exe mmc.exe')
/**
 * ^BS doesn't natively work because it produces a control character,
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

;== ============================================================================
;== Insert Any Key Right of Caret
;== ============================================================================

~CapsLock:: {
    ih := InputHook('I')
    ih.keyOpt('{All}', 'N')
    ih.backspaceIsUndo := false
    ih.onKeyDown := insertKeyRightOfCaret
    priorInput := ''

    ih.start()
    KeyWait('CapsLock')
    ih.stop()

    if not ih.input {
        return
    }

    capsLockIsOn := GetKeyState('CapsLock', 'T')
    SetCapsLockState(capsLockIsOn ? false : true)

    insertKeyRightOfCaret(ih, vk, sc) {
        if ih.input = priorInput {
            return
        }
        Send(Format('{vk{:x}}{Left}', vk))
        priorInput := ih.input
    }
}

;== ============================================================================
;== Modifiers
;== ============================================================================

;=== ===========================================================================
;=== F13 - F24
;=== ===========================================================================

MapF13UntilF24()
MapF13UntilF24() {
    HotIf((thisHotkey) => GetKeyState('CapsLock', 'T'))
    Loop 12 {
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
;=== Mask
;=== ===========================================================================

#^+Alt::
#^!Shift::
#+!Ctrl::
^+!LWin::
^+!RWin:: {
    MaskMenu()
}

#HotIf not OfficeAppIsActive()
OfficeAppIsActive() {
    SetTitleMatchMode('RegEx')
    return WinActive('ahk_exe .EXE$')
}

Alt:: MaskAlt()
MaskAlt() {
    SetKeyDelay(-1)
    SendEvent('{Blind}{Alt DownR}')
    MaskMenu()
    KeyWait('Alt')
    SendEvent('{Blind}{Alt Up}')
}
#HotIf

;=== ===========================================================================
;=== NumLock
;=== ===========================================================================

if GetKeyState('NumLock', 'T') {
    NumLockIndicatorFollowMouse()
}

#InputLevel 1
!CapsLock:: SendEvent('{NumLock}')
^Pause::    SendEvent('{NumLock}')
        ; This hotkey exists because when Ctrl is down,
        ; NumLock produces the key code of Pause (while Pause produces CtrlBreak).
#InputLevel

/**
 * Display ToolTip while NumLock is on.
 */
~*NumLock:: NumLockIndicatorFollowMouse()
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
