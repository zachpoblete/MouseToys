/**
 * Disclaimer: I am no longer using this script because I couldn't figure out
 * how to stop it from getting the standard modifiers stuck sometimes.
 * For example, pressing Ctrl+CapsLock+H would send Ctrl+Left as intended,
 * but sometimes it would also leave Ctrl pressed down.
 * My guess was that it was because I was using a Bluetooth keyboard.
 * Something to do with lag? Idk.
 */

/**
 * Actually, in general-custom-layer-mappings.ahk, I have some more ideas on how to fix the problem.
 * But I'm not trying any of them because my second reason for not using this script anymore
 * is the arrows keys on my current keyboard are close enough to my hand,
 * to the point where I don't have to shift it to the right
 * but just rotate it slightly to reach the arrow keys.
 */

/**
 * Wait, why didn't I just try out QMK? :P
 */

#Requires AutoHotkey v2.0.7
        ; Before v2.0.7, hook hotkeys were not recognizing modifiers that were pressed down by SendInput.
        ; Custom Layer would not work in v2.0.6 and below.

#Include _constants.ahk
#Include general-custom-layer-mappings.ahk
#Include vimium-c-remappings.ahk
        ; WARNING: Has conflicts with another file.
        ; Read file to learn more.
#Include map-double-shift-to-capslock.ahk
