#HotIf WinActive('ahk_exe Notion.exe')
!Left::  Send('^[')
        ; Go back.
!Right:: Send('^]')
        ; Go forward.

^+f:: Send('^+h')
        ; Apply last text or highlight color used.
#HotIf
