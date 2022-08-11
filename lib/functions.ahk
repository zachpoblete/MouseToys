#Include default-settings.ahk

Func.prototype.defineProp('tryCall', {call: FuncPrototype_TryCall})
FuncPrototype_TryCall(this, params*) {
    try {
        return this(params*)
    }
}

;====================================================================================================
; Clipboard
;====================================================================================================

GetSelected() {
    savedClipboard := ClipboardAll()
    A_Clipboard := ''

    Send('{Ctrl Down}c{Ctrl Up}')
    ClipWait(0.05)

    selected := A_Clipboard
    A_Clipboard := savedClipboard
    return selected
}

GetSelectedElseExit() {
    selected := GetSelected()

    if not selected {
        exit
    }
    return selected
}

SendInstantRaw(text) {
    savedClipboard := ClipboardAll()
    A_Clipboard := text
    ClipWait(0.05)
    Send('{Ctrl Down}v{Ctrl Up}')
    Sleep(1000)
    SetTimer(() => A_Clipboard := savedClipboard, -50)
}

;====================================================================================================
; File
;====================================================================================================

GetFileExt(fileName) {
    RegExMatch(fileName, '\.[^.]+$', &fileExt)
    return fileExt
}

OnFileSave(fileName, fn, shouldCall := true) {
    funcIfSave(fn) {            
        if not InStr(FileGetAttrib(fileName), 'A') {
            return
        }
        FileSetAttrib('-A', fileName)
        fn()
    }

    periodMs := (shouldCall)? 1000 : 0
    SetTimer(() => funcIfSave(fn), periodMs)
}

StdOut(text, delay := '', delimiter := '') {
    if delay = '' {
        FileAppend(text, '*')
        return
    }
    Loop Parse text, delimiter {
        FileAppend(A_LoopField delimiter, '*')
        Sleep(delay)
    }
}

;====================================================================================================
; Hotkey
;====================================================================================================

HotkeyDelModifierSymbols(hk) {
    hk := StrReplace(RegExReplace(hk, ' Up$'), A_Space)

    if InStr(hk, '&') {
        return StrSplit(hk, '&')
    } else {
        return RegExReplace(hk, '[#!^+<>*~$]')
    }
}

HotkeyEncloseInBraces(hk) {
    if InStr(hk, '&') {
        return '{' RegExReplace(hk, ' *& *', '}{') '}'
    } else if RegExMatch(hk, ' Up$') {
        return '{' hk '}'
    } else {
        return RegExReplace(hk, '([#!^+<>]*)([*~$]*)([^*~$]+)', '$1{$3}')
    }
}

HotkeyGetPrefixKey(hk) {
    if HotstringGetAbbrev(hk) {
        return
    }
    hkKeys := HotkeyDelModifierSymbols(hk)

    if not IsObject(hkKeys) {
        return hkKeys
    } else {
        return hkKeys[1]
    }
}

HotstringGetAbbrev(hs) {
    RegExMatch(hs, '^:[^:]*:\K.+', &abbrev)
    return abbrev
}

;====================================================================================================
; String
;====================================================================================================

StrDel(haystack, needle, limit := 1) {
    return StrReplace(haystack, needle, , , , limit)
}

;====================================================================================================
; Window
;====================================================================================================

ActivateRecent(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    if InStr(winTitle, 'ahk_group') {
        groupName := LTrim(StrDel(winTitle, 'ahk_group'))
        GroupActivate(groupName, 'R')
    } else {
        WinActivate(winTitle, winText, excludedTitle, excludedText)
    }
}

ActivateRecentElseRun(target, workingDir := '', winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    if winTitle = '' and winText = '' and excludedTitle = '' and excludedText = '' {
        winTitle := target
    }
    if not WinExist(winTitle, winText, excludedTitle, excludedText) {
        Run(target, workingDir)
    } else {
        ActivateRecent(winTitle, winText, excludedTitle, excludedText)
    }
}

ActivateRecentIfExists(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    if not WinExist(winTitle, winText, excludedTitle, excludedText) {
        return
    }
    ActivateRecent(winTitle, winText, excludedTitle, excludedText)
}

MouseControlFocus(control := '', winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd, &mouseControlHwnd, 2)
    WinActivate(mouseHwnd)
    ControlFocus(mouseControlHwnd)

    mouseControlClassNn := ControlGetClassNN(mouseControlHwnd)
    mouseControlText := ControlGetText(mouseControlHwnd)

    if not control ~= '\A(' mouseControlClassNn '|' mouseControlText '|' mouseControlHwnd ')\z' {
        if control.hwnd != mouseControlHwnd {
            return
        }
    }
    if not WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText) {
        return
    }
    return mouseControlHwnd
}

MouseWinActivate(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd)
    WinActivate(mouseHwnd)
    return WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText)  ; The mouseHwnd is there for the case when all the parameters are blank and there is no last found window.
}

Func.prototype.defineProp('setWinModeAndCall', {call: FuncPrototype_SetWinModeAndCall})
FuncPrototype_SetWinModeAndCall(this, matchMode := '', matchModeSpeed := '', shouldDetectHiddenWin := '', shouldDetectHiddenText := '') {
    if matchMode {
        SetTitleMatchMode(matchMode)
    }
    if matchModeSpeed {
        SetTitleMatchMode(matchModeSpeed)
    }
    if shouldDetectHiddenWin != '' {
        DetectHiddenWindows(shouldDetectHiddenWin)
    }
    if shouldDetectHiddenText != '' {
        DetectHiddentext(shouldDetectHiddenText)
    }
    return this()
}
