; I believe it's harder to spot a bug if we just use !!, so let's turn it into
; the Boolean function that we see in other languages
Boolean(var) {
    ; Unfamiliar with the trick? See
    ; https://stackoverflow.com/q/784929/21138349
    return !!var
}
