; For information on what Vimium C is:
; https://github.com/gdh1995/vimium-c

#HotIf WinActive('ahk_exe msedge.exe') and GetKeyState(K_LAYER_ACTIVATOR, 'P')
`;:: VimcCmd(1)
        ; LinkHints.activate.

+;:: VimcCmd(2)
        ; LinkHints.activateEdit.
^;:: VimcCmd(3)
        ; LinkHints.activateHover.
        ; WARNING: Conflicts with ..\specific-app\edge\vimium-c-commands.ahk

+':: VimcCmd(4)
        ; LinkHints.activateCopyLinkUrl.
'::  VimcCmd(5)
        ; LinkHints.activateCopyLinkText.
#HotIf
