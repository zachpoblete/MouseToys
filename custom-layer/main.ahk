; WARNING: I am no longer using this script because I couldn't figure out
; how to stop it from getting the standard modifiers stuck sometimes.
; For example, pressing Ctrl+CapsLock+H would send Ctrl+Left as intended,
; but sometimes it would also leave Ctrl pressed down.
; My guess was that it was because I was using a Bluetooth keyboard.
; Something to do with lag? Idk.

#Requires AutoHotkey v2.0.7
        ; Before v2.0.7, hook hotkeys were not recognizing modifiers that were pressed down by SendInput.
        ; Custom Layer would not work in v2.0.6 and below.

#Include constants.ahk
#Include general.ahk
#Include vimium-c-commands.ahk
#Include double-shift-for-capslock.ahk
