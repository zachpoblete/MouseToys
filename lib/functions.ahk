#Include default-settings.ahk
#Include <constants>

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

MoveWinMiddleToMouse() {
    WinGetPos(, , &winW, &winH)

    CoordMode('Mouse')
    MouseGetPos(&mouseX, &mouseY)

    WinMove(mouseX - (winW / 2), mouseY - (winH / 2))
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
