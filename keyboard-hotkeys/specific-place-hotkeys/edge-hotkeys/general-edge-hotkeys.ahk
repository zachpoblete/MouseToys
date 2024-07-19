#HotIf WinActive('ahk_exe msedge.exe')
^!+e:: Send('{Ctrl Down}w{PgUp}{Ctrl Up}')
        ; Close current tab and move to the tab that was to its left.

/**
 * Disable.
 */
^+Delete::
        ; Clear browsing data.
^r::
        ; I sometimes accidentally press this when I want to ^t.
        ; I will just use F5 instead.
{
    return
}
#HotIf
