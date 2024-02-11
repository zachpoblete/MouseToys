#Include default-settings.ahk
#Include <constants>

;= =============================================================================
;= Clipboard
;= =============================================================================

GetSelected() {
    savedClipboard := ClipboardAll()
    A_Clipboard := ''

    Send('{Ctrl Down}c{Ctrl Up}')
            ; I deliberately made this {Ctrl Down}c{Ctrl Up}
            ; because that seemed more consistent.
            ; But I'm not sure if ^c was really the problem.
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
            ; See GetSelected for why I chose {Ctrl Down}v{Ctrl Up} over ^v
    SetTimer(() => A_Clipboard := savedClipboard, -100)
            ; Fsr, Sleep(50) is too fast.
}

;= =============================================================================
;= Control
;= =============================================================================

ControlClassNnFocused(winTitle, controlClassNn, useRegEx := false) {
    try {
        focusedControlHwnd    := ControlGetFocus(winTitle)
        focusedControlClassNn := ControlGetClassNn(focusedControlHwnd)
    } catch {
        return
    }

    if not useRegEx and focusedControlClassNn != controlClassNn {
        return
    } else if not RegExMatch(focusedControlClassNn, controlClassNn) {
        return
    }

    return focusedControlClassNn
}

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

;= =============================================================================
;= File
;= =============================================================================

GetFileExt(fileName) {
    RegExMatch(fileName, '\.[^.]+$', &fileExt)
    return fileExt
}

OnFileSave(fileName, fn, shouldCall := true) {
    periodMs := shouldCall ? 1000 : 0
    SetTimer(() => funcIfSave(fn), periodMs)

    funcIfSave(fn) {
        fileAttrib := FileGetAttrib(fileName)
        if not InStr(fileAttrib, 'A') {
            return
        }

        FileSetAttrib('-A', fileName)
        fn()
    }
}

StdOut(text, delayMs := '', delimiter := '') {
    if delayMs = '' {
        FileAppend(text, '*')
        return
    }

    loop parse text, delimiter {
        FileAppend(A_LoopField delimiter, '*')
        Sleep(delayMs)
    }
}

;= =============================================================================
;= Keyboard
;= =============================================================================

ChordInput() {
    ih := InputHook('')

    ih.keyOpt('{All}', 'E')
    maskKey := RegExReplace(A_MenuMaskKey, '(vk[[:xdigit:]]{2})(sc[[:xdigit:]]{3})', '{$1}{$2}')
    ih.keyOpt('{LWin}{RWin}{LCtrl}{RCtrl}{LShift}{RShift}{LAlt}{RAlt}' maskKey , '-E')

    ih.start()
    ih.wait()
    return ih.endMods ih.endKey
}

;== ============================================================================
;== Hotkey
;== ============================================================================

HotkeyEncloseInBraces(hk) {
    hk := HkSplit(hk)
    hk[1] := RegExReplace(hk[1], '[*~$]')
    hk.prefix := []
    RegExMatch(hk[1], '([#!^+<>]*)(.+)', hk.refProp('prefix'))
    return hk.prefix[1] '{' hk.prefix[2] '}{' hk[2] '}'
}

; Note: This currently does not account for Up hotkeys.
HkSplit(hk) {
    RegExMatch(hk, '(^:[^:]*:)(.+)', &hs)

    if hs {
        hk := hs
    } else {
        if InStr(hk, ' & ') {
            hk := StrReplace(hk, ' ')
            hk := StrSplit(hk, '&')
        } else {
            hk := StrReplace(hk, ' ')
            RegExMatch(hk, '([#!^+<>*~$]*)(.+)', &hk)
        }
    }

    return hk
}

MaskMenu() {
    Send('{Blind}{' A_MenuMaskKey '}')
            ; No mapping.
}

;= =============================================================================
;= Meta
;= =============================================================================

Object.prototype.defineProp('refProp', {call: ObjProto_RefProp})
/**
 * Taken from Lexikos from:
 * https://www.autohotkey.com/boards/viewtopic.php?p=394816#p394816
 */
ObjProto_RefProp(this, name) {
    desc := this.getOwnPropDesc(name)
    if desc.hasProp('value') {
        this.defineProp(name, makeRef(desc))
    } else if not desc.get.hasProp('ref') {
        throw Error('Invalid property for ref', -1, name)
    }

    return desc.get.ref

    makeRef(desc) {
        v := desc.deleteProp('value')
        desc.get := (this)        => v
        desc.set := (this, value) => v := value
        desc.get.ref := &v
        return desc
    }
}

;= =============================================================================
;= String
;= =============================================================================

QueryToUrl(query, engine) {
    query := StrReplace(query, '&', '%26')
    query := StrReplace(query, '#', '%23')
    query := StrReplace(query, '+', '%2B')
    query := StrReplace(query, ' ', '+')
            ; URL encoding is used to encode special characters in query strings.
    return engine query
}

StrDelete(haystack, needle, limit := 1) {
    return StrReplace(haystack, needle, , , , limit)
}

;= =============================================================================
;= Window
;= =============================================================================

WinThatUsesCtrlYAsRedoIsActive() {
    if WinActive('ahk_exe Photoshop.exe') {
        return true
    }
}

Zoom_MeetingWinExist(isVisible) {
    try {
        meetingWinPid := WinGetPid(K_CLASSES['ZOOM']['TOOLBAR'])
    } catch {
        return
    }

    winTitle := isVisible ? 'Zoom' : ''
    return WinExist(winTitle ' ahk_pid ' meetingWinPid)
}
