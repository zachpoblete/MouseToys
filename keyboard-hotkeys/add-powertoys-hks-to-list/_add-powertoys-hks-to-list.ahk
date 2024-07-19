; Add my PowerToys hotkeys to AHK's hotkey list so that if I ever forget they
; exist and try to redefine them somewhere else, I get an error.
; (To learn more about PowerToys, see https://github.com/microsoft/PowerToys)
AddPowerToysHksToList()

; I use `hk` because `hotkey` is not a valid variable name.
AddPowerToysHksToList() {
    hksPowerToysAlwaysSees := [
        "~#+a",  ; Video Conference Mute
        "~#+c",  ; Color Picker
        "~#+r"   ; Screen Ruler
    ]

    for hk in hksPowerToysAlwaysSees {
        Hotkey(hk, dontModify)
    }

    dontModify(thisHotkey) {
        return
    }
}
