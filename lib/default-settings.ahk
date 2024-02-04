#Requires AutoHotkey v2.0.7
        ; Before v2.0.7, hook hotkeys were not recognizing modifiers which were pressed down by SendInput.
        ; Custom Layer would not work in v2.0.6 and below.
#Warn
#WinActivateForce
#SingleInstance

; Setting these values to 0 ensures each hotkey press is registered:
A_WinDelay := 0
A_ControlDelay := 0

A_MenuMaskKey := 'vkFF'
