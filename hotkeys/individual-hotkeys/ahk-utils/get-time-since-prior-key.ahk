GetTimeSincePriorKeyMs() {
    keyHistoryText := ScriptInfo("KeyHistory")
    last2LinesPos := InStr(keyHistoryText, "`n", , , -2)
    last2Lines := SubStr(keyHistoryText, last2LinesPos + 1)
    RegExMatch(last2Lines, "^.+[du]\s+(\S+)", &match)
    timeSincePriorKeyMs := match[1] * 1000
    return timeSincePriorKeyMs
}

; ScriptInfo.
; Originally by Lexikos: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=9656
; Converted to AHK v2 by Descolada: https://www.autohotkey.com/boards/viewtopic.php?p=486018#p486018
ScriptInfo(Command) {
    static hEdit := 0, pfn, bkp, cmds := {ListLines:65406, ListVars:65407, ListHotkeys:65408, KeyHistory:65409}
    if !hEdit {
        hEdit := DllCall("GetWindow", "ptr", A_ScriptHwnd, "uint", 5, "ptr")
        user32 := DllCall("GetModuleHandle", "str", "user32.dll", "ptr")
        pfn := [], bkp := []
        for i, fn in ["SetForegroundWindow", "ShowWindow"] {
            pfn.Push(DllCall("GetProcAddress", "ptr", user32, "astr", fn, "ptr"))
            DllCall("VirtualProtect", "ptr", pfn[i], "ptr", 8, "uint", 0x40, "uint*", 0)
            bkp.Push(NumGet(pfn[i], 0, "int64"))
        }
    }

    if (A_PtrSize=8) {  ; Disable SetForegroundWindow and ShowWindow.
        NumPut("int64", 0x0000C300000001B8, pfn[1], 0)  ; return TRUE
        NumPut("int64", 0x0000C300000001B8, pfn[2], 0)  ; return TRUE
    } else {
        NumPut("int64", 0x0004C200000001B8, pfn[1], 0)  ; return TRUE
        NumPut("int64", 0x0008C200000001B8, pfn[2], 0)  ; return TRUE
    }

    cmds.%Command% ? DllCall("SendMessage", "ptr", A_ScriptHwnd, "uint", 0x111, "ptr", cmds.%Command%, "ptr", 0) : 0

    NumPut("int64", bkp[1], pfn[1], 0)  ; Enable SetForegroundWindow.
    NumPut("int64", bkp[2], pfn[2], 0)  ; Enable ShowWindow.

    return ControlGetText(hEdit)
}
