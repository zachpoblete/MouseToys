/**
 * Open uniqoda.
 */
#+,:: {
    winKeysUp := ''
    loop parse 'LR' {
        if GetKeyState(A_LoopField 'Win', 'P') {
            winKeysUp .= '{' A_LoopField 'Win Up}'
        }
    }
    Send('{Blind}' winKeysUp '^+{F20}')
            ; {Blind#}^+{F20} does not work
            ; because that would be equivalent to
            ; {Blind}{LWin Up}^+{F20}{LWin Down}
                    ; (Well, actually, not sure how it accounts for RWin.)
            ; and fsr, uniqoda does something weird when a Win key is down
            ; a short time after F20 has already been sent.
}
