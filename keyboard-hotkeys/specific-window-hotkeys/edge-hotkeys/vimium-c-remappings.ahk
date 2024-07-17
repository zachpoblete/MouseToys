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

#HotIf
