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
