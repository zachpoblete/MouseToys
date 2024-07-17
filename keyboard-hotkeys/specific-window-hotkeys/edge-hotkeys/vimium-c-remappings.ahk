; For information on what Vimium C is:
; https://github.com/gdh1995/vimium-c

#HotIf WinActive('ahk_exe msedge.exe')
^;::  VimcCmd(2)
        ; LinkHints.activateEdit

^!r:: VimcCmd(6)
        ; reopenTab.
^!e:: VimcCmd(7)
        ; removeRightTab.

^+PgUp:: VimcCmd(8)
        ; moveTabLeft.
^+PgDn:: VimcCmd(9)
        ; moveTabRight.

VimcCmd(num) {
    if num > 24 {
        Send('!{F' (num - 12) '}')
    } else if num > 16 {
        Send('^{F' (num - 4) '}')
    } else if num > 8 {
        Send('+{F' (num + 4) '}')
    } else {
        Send('{F' (num + 12) '}')
    }
}
#HotIf
