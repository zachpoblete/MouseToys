#Include default-settings.ahk

TryFunc(fn) {
    try {
        return fn()
    }
}

TryFuncCatchExit(fn) {
    try {
        return fn()
    }
    catch {
        exit
    }
}

;====================================================================================================
; Clipboard
;====================================================================================================

GetSelected() {
    savedClipboard := ClipboardAll()
    A_Clipboard := ''

    Send '{Ctrl Down}c{Ctrl Up}'
    ClipWait 0.05

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
    ClipWait 0.05
    Send '{Ctrl Down}v{Ctrl Up}'
    Sleep 1000
    SetTimer () => A_Clipboard := savedClipboard, -50
}

;====================================================================================================
; File
;====================================================================================================

GetFileExt(fileName) {
    RegExMatch fileName, '\.[^.]+$', &fileExt
    return fileExt
}

OnFileSave(fileName, fn, shouldCall := true) {
    funcIfSave(fn) {            
        if not InStr(FileGetAttrib(fileName), 'A') {
            return
        }
        
        FileSetAttrib '-A', fileName
        fn
    }

    periodMs := (shouldCall)? 1000 : 0
    SetTimer () => funcIfSave(fn), periodMs
}

;====================================================================================================
; Hotkey
;====================================================================================================

HotkeyDelModifierSymbols(hk) {
    hk := StrReplace(RegExReplace(hk, ' Up$'), A_Space)

    if InStr(hk, '&') {
        return StrSplit(hk, '&')
    }
    else {
        return RegExReplace(hk, '[#!^+<>*~$]')
    }
}

HotkeyEncloseInBraces(hk) {
    if InStr(hk, '&') {
        return '{' . RegExReplace(hk, ' *& *', '}{') . '}'
    }
    else if RegExMatch(hk, ' Up$') {
        return '{' . hk . '}'
    }
    else {
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
    }
    else {
        return hkKeys[1]
    }
}

HotstringGetAbbrev(hs) {
    RegExMatch hs, '^:[^:]*:\K.+', &abbrev
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

ActivateElseRun(toRun, workingDir := '', toActivate := '') {
    if toActivate = '' {
        toActivate := 'ahk_exe ' . toRun
    }

    if not WinExist(toActivate) {
        Run toRun, workingDir
    }
    else if InStr(toActivate, 'ahk_group') {
        GroupActivate LTrim(StrDel(toActivate, 'ahk_group')), 'R'
    }
    else {
        WinActivate toActivate
    }
}

GroupActivateRelIfExists(groupName) {
    if not WinExist('ahk_group ' . groupName) {
        return
    }

    GroupActivate groupName, 'R'
}

MouseControlFocus(control := '', winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos , , &mouseHwnd, &mouseControlHwnd, 2
    WinActivate mouseHwnd
    ControlFocus mouseControlHwnd

    mouseClassNn := ControlGetClassNN(mouseControlHwnd)
    mouseControlText := ControlGetText(mouseControlHwnd)

    if not control ~= '\A(' mouseClassNn '|' mouseControlText '|' mouseControlHwnd ')\z' {
        if control.hwnd != mouseControlHwnd {
            return
        }
    }
    if not WinActive(winTitle . ' ahk_id ' . mouseHwnd, winText, excludedTitle, excludedText) {
        return
    }

    return mouseControlHwnd
}

MouseWinActivate(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos , , &mouseHwnd
    WinActivate mouseHwnd
    return WinActive(winTitle . ' ahk_id ' . mouseHwnd, winText, excludedTitle, excludedText)  ; The mouseHwnd is there for the case when all the parameters are blank and there is no last found window.
}

MatchTitleAndCallFunc(options, fn) {
    if RegExMatch(options, 'i)1|2|3|RegEx', &matchMode) {
        SetTitleMatchMode matchMode[]
    }
    
    if RegExMatch(options, 'i)Fast|Slow', &speed) {
        SetTitleMatchMode speed[]
    }

    if InStr(options, 'Hidden') {
        DetectHiddenWindows true
    }
    else if InStr(options, 'Visible') {
        DetectHiddenWindows false
    }

    fn
}
