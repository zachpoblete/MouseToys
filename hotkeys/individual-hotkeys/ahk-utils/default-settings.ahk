#Requires AutoHotkey v2.0

#Warn All
#SingleInstance Force

; Prevent Taskbar buttons from possibly flashing if their windows are activated.
#WinActivateForce

; Make functions that use window or control functions not 100 ms slow but as
; snappy as safely possible. There is probably a greater chance of
; unreliability, but I haven't noticed this.
SetWinDelay(0)
SetControlDelay(0)
