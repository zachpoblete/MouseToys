#Include default-settings.ahk

;====================================================================================================
; Clipboard
;====================================================================================================

GetSelected() {
    saved_clipboard := ClipboardAll()
    A_Clipboard := ''
    Send '{Ctrl Down}c{Ctrl Up}'
    ClipWait 0.05
    selected := A_Clipboard
    A_Clipboard := saved_clipboard
    return selected
}

GetSelectedElseExit() {
    selected := GetSelected()
    if not selected
        exit
    return selected
}

SendInstantRaw(text) {
    saved_clipboard := ClipboardAll()
    A_Clipboard := text
    ClipWait 0.05
    Send '{Ctrl Down}v{Ctrl Up}'
    Sleep 1000
    SetTimer () => A_Clipboard := saved_clipboard, -50
}

;====================================================================================================
; File
;====================================================================================================

GetFileExt(file_name) {
    RegExMatch file_name, '\.[^.]+$', &file_ext
    return file_ext
}

OnFileSave(file_name, function, should_call := true) {
    funcIfSave(function) {            
        if not InStr(FileGetAttrib(file_name), 'A')
            return
        FileSetAttrib '-A', file_name
        function
    }

    period_ms := (should_call) ? 1000 : 0
    SetTimer () => funcIfSave(function), period_ms
}

;====================================================================================================
; Hotkey
;====================================================================================================

HotkeyDelModifierSymbols(hk) {
    hk := StrReplace(RegExReplace(hk, ' Up$'), A_Space)
    if InStr(hk, '&')
        return StrSplit(hk, '&')
    return RegExReplace(hk, '[#!^+<>*~$]')
}

HotkeyEncloseInBraces(hk) {
    if InStr(hk, '&')
        return '{' . RegExReplace(hk, ' *& *', '}{') . '}'
    if RegExMatch(hk, ' Up$')
        return '{' . hk . '}'
    return RegExReplace(hk, '([#!^+<>]*)([*~$]*)([^*~$]+)', '$1{$3}')
}

HotkeyGetPrefixKey(hk) {
    if HotstringGetAbbrev(hk)
        return
    hk_keys := HotkeyDelModifierSymbols(hk)
    if not IsObject(hk_keys)
        return hk_keys
    return hk_keys[1]
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

ActivateElseRun(to_run, working_dir := '', to_activate := '') {
    if to_activate = ''
        to_activate := 'ahk_exe ' . to_run

    if not WinExist(to_activate)
        Run to_run, working_dir
    else if InStr(to_activate, 'ahk_group')
        GroupActivate LTrim(StrDel(to_activate, 'ahk_group')), 'R'
    else
        WinActivate to_activate
}

GroupActivateRelIfExists(group_name) {
    if not WinExist('ahk_group ' . group_name)
        return
    GroupActivate group_name, 'R'
}

MouseControlFocus(control := '', win_title := '', win_text := '', excluded_title := '', excluded_text := '') {
    MouseGetPos , , &mouse_hwnd, &mouse_control_hwnd, 2
    WinActivate mouse_hwnd
    ControlFocus mouse_control_hwnd

    mouse_class_nn := ControlGetClassNN(mouse_control_hwnd)
    mouse_control_text := ControlGetText(mouse_control_hwnd)

    if not control ~= '\A(' mouse_class_nn '|' mouse_control_text '|' mouse_control_hwnd ')\z'
        if not control.Hwnd = mouse_control_hwnd
            return
    if not WinActive(win_title . ' ahk_id ' . mouse_hwnd, win_text, excluded_title, excluded_text)
        return
    return mouse_control_hwnd
}

MouseWinActivate(win_title := '', win_text := '', excluded_title := '', excluded_text := '') {
    MouseGetPos , , &mouse_hwnd
    WinActivate mouse_hwnd
    return WinActive(win_title . ' ahk_id ' . mouse_hwnd, win_text, excluded_title, excluded_text)  ; The mouse_hwnd is there for the case when all the parameters are blank and there is no last found window.
}

TitleMatch(options, win_functor) {
    if RegExMatch(options, 'i)1|2|3|RegEx', &match_mode)
        SetTitleMatchMode match_mode[]
    if RegExMatch(options, 'i)Fast|Slow', &speed)
        SetTitleMatchMode speed[]

    if InStr(options, 'Hidden')
        DetectHiddenWindows true
    else if InStr(options, 'Visible')
        DetectHiddenWindows false

    win_functor
}

TryWinGetPid(win_title := '', win_text := '', excluded_title := '', excluded_text := '') {
    try
        return WinGetPID(win_title, win_text, excluded_title, excluded_text)
    catch
        return
}
