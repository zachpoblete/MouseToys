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

SendInstantRaw(text) {
    savedClipboard := ClipboardAll()
    A_Clipboard := text
    ClipWait(0.05)
    Send('{Ctrl Down}v{Ctrl Up}')
            ; See GetSelected for why I chose {Ctrl Down}v{Ctrl Up} over ^v
    SetTimer(() => A_Clipboard := savedClipboard, -100)
            ; Fsr, Sleep(50) is too fast.
}
