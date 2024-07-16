; For information on what Vimium C is:
; https://github.com/gdh1995/vimium-c

#HotIf WinActive('ahk_exe msedge.exe') and GetKeyState(K_LAYER_ACTIVATOR, 'P')
`;:: VimcCmd(1)
        ; LinkHints.activate.
+;:: VimcCmd(2)
        ; LinkHints.activateEdit.
^;:: VimcCmd(3)
        ; LinkHints.activateHover.

+':: VimcCmd(4)
        ; LinkHints.activateCopyLinkUrl.
'::  VimcCmd(5)
        ; LinkHints.activateCopyLinkText.

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
