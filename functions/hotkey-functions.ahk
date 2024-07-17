; Why isn't this HkEncloseInBraces?
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
