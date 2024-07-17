; TODO: Further organize by creating libraries.
; TODO: #Include every file to show dependencies

#Requires AutoHotkey v2.0.18
; #Requires needs to be here so that AHK doesn't ask which version I want to run.

#Include default-settings.ahk  ; TODO: Decide whether to include this for every file and how
#Include globals\_globals.ahk
#Include constants\_constants.ahk
#Include functions\_functions.ahk

#Include keyboard-hotkeys\_keyboard-hotkeys.ahk
#Include keyboard-hotkeys\_keyboard-functions.ahk
        ; Note: This is a temporary fix.
        ; #Include it properly in the individual files.
#Include mouse-hotkeys\_mouse-hotkeys.ahk
#Include script-hotkeys\_script-hotkeys.ahk
#Include background-functions\_background-functions.ahk

