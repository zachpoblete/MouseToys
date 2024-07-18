; Add my PowerToys hotkeys to AHK's hotkey list so that if I ever forget they
; exist and try to redefine them somewhere else, I get an error.
; (To learn more about PowerToys, see https://github.com/microsoft/PowerToys)
AddPowerToysHksToHksList()

; I don't use the form `hotkey:: return` so that the code can better explain
; itself.
AddPowerToysHksToHksList() {
    toyToHk := Map(
        "Video Conference Mute", "#+a",
        "Color Picker",          "#+c",
        "Screen Ruler",          "#+r"
    )

    for toy, hk in toyToHk {
        ; Don't change the hotkeys's original external effects.
        Hotkey("~" . hk, (thisHotkey) => "")
    }
}
