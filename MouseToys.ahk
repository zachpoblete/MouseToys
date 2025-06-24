#Requires AutoHotkey v2.0

A_IconTip := "MouseToys"

; For an explanation as to why the hotkeys are made the way they are, see https://github.com/zachpoblete/MouseToys/wiki/Why-the-hotkeys-are-made-the-way-are-(it's-because-of-the-3‐button-combinations)

#Include hotkeys
#Include accelerated-scroll-hotkeys.ahk
#Include x1-win-and-general-hotkeys.ahk
#Include x2-tab-and-page-hotkeys.ahk

; Allow Standard Modifier+RButton to work.
~*RButton:: return
