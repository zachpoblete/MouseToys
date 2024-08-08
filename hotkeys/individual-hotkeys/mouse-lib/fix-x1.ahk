*XButton1 Up:: return

; The below hotkeys are needed so that they don't get stuck.
; I think it has something to do with X1+W.
; See https://www.autohotkey.com/boards/viewtopic.php?f=82&t=125851
; which may mean this is a bug:
#HotIf GetKeyState('XButton1', 'P')
    *MButton:: return
    *LButton:: return
    *RButton:: return
#HotIf
