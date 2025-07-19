#Requires AutoHotkey v2.0

; Note: The order of some of the following #Include directives is very
; important. Namely, moving the X1+W hotkeys below the X1+R+W hotkeys would make
; pressing X1+R+W perform the function of X1+W. See
; https://www.autohotkey.com/boards/viewtopic.php?f=14&t=125819

#Include individual-hotkeys
#Include x1w-cycle-windows-order-used.ahk

#Include x1mr-close-win.ahk
#Include x1rl-play-pause.ahk
#Include x1mw-min-or-maximize-win.ahk
#Include x1m-restore-and-drag-win.ahk
#Include x1lm-screenshot.ahk
#Include x1l-send-enter-or-delete.ahk
#Include x1rw-change-volume.ahk
