#Requires AutoHotkey v2.0

; Note: The order of some of the following #Include directives is very
; important. Namely, moving the X1+W hotkeys below the X1+R+W hotkeys would make
; pressing X1+R+W perform the function of X1+W. See
; https://www.autohotkey.com/boards/viewtopic.php?f=14&t=125819

#Include individual-hotkeys
#Include x1-cycle-windows-order-used.ahk

#Include x1-close-win-at-mouse.ahk
#Include x1-copy-or-paste.ahk
#Include x1-min-or-maximize-win-at-mouse.ahk
#Include x1-restore-and-drag-win-at-mouse.ahk
#Include x1-screenshot.ahk
#Include x1-send-delete-or-enter.ahk
#Include x1-change-volume.ahk
