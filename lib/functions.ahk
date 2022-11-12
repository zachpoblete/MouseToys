#Include default-settings.ahk

Func.prototype.defineProp('tryCall', {call: FuncProto_TryCall})
FuncProto_TryCall(this, params*) {
    try {
        return this(params*)
    }
}

;= =============================================================================
;= Clipboard
;= =============================================================================

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
    SetTimer(() => A_Clipboard := savedClipboard, -50)
            ; Fsr, Sleep(50) is too fast.
}

;= =============================================================================
;= File
;= =============================================================================

GetFileExt(fileName) {
    RegExMatch(fileName, '\.[^.]+$', &fileExt)
    return fileExt
}

OnFileSave(fileName, fn, shouldCall := true) {
    funcIfSave(fn) {
        fileAttrib := FileGetAttrib(fileName)
        if not InStr(fileAttrib, 'A') {
            return
        }
        FileSetAttrib('-A', fileName)
        fn()
    }

    periodMs := (shouldCall)? 1000 : 0
    SetTimer(() => funcIfSave(fn), periodMs)
}

StdOut(text, delayMs := '', delimiter := '') {
    if delayMs = '' {
        FileAppend(text, '*')
        return
    }
    Loop Parse text, delimiter {
        FileAppend(A_LoopField delimiter, '*')
        Sleep(delayMs)
    }
}

;= =============================================================================
;= Keyboard
;= =============================================================================

ChordInput() {
    mask(key) {
        if GetKeyState(key, 'P') {
            Send(K_KEYS['MENU_MASK'])
            Send('{Blind}{' key ' Up}')
        }
    }

    mask('LWin')
    mask('RWin')
    mask('Alt')
    mask('Ctrl')

    ih := InputHook('L1 M')
    ih.start()
    ih.wait()
    return ih.input
}

HotkeyDelModifierSymbols(hk) {
    hk := RegExReplace(hk, ' Up$')
    hk := StrReplace(hk, ' ')

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

MaskMenu() {
    Send('{Blind}{' A_MenuMaskKey '}')
            ; No mapping.
}

;= =============================================================================
;= String
;= =============================================================================

QueryToUrl(query, engine) {
    query := StrReplace(query, '&', '&26')
    query := StrReplace(query, '+', '%2B')
    query := StrReplace(query, ' ', '+')
            ; URL encoding is used to encode special characters in query strings.
    return engine query
}

StrDel(haystack, needle, limit := 1) {
    return StrReplace(haystack, needle, , , , limit)
}

;= =============================================================================
;= Window
;= =============================================================================

MouseWinActivate(winTitle := '', winText := '', excludedTitle := '', excludedText := '') {
    MouseGetPos(, , &mouseHwnd)
    WinActivate(mouseHwnd)
    return WinActive(winTitle ' ahk_id ' mouseHwnd, winText, excludedTitle, excludedText)
        ; mouseHwnd is there for the case
        ; when all the parameters are blank and there is no last found window.
}

;= =============================================================================
;= Control
;= =============================================================================

ControlGetHwndFromClassNnAndTextElseExit(controlClassNn, controlText) {
    try {
        controlHwnd := ControlGetHwnd(controlClassNn)
    } catch {
        exit
    }
    controlTextFromClassNn := ControlGetText(controlClassNn)

    if controlText != controlTextFromClassNn {
        exit
    }
    return controlHwnd
}

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
