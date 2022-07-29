; Originally by BoffinbraiN
; For full details, visit the forum thread:
; https://autohotkey.com/board/topic/48426-accelerated-scrolling-script

#Include default-settings.ahk

A_MaxHotkeysPerInterval := 140  ; Default: 120

AcceleratedScroll() {  ; To use effectively, make sure this function is the first line in a hotkey.
    static TIMEOUT_MS := 500,  ; Length of a scrolling session. Keep scrolling within this time to accumulate boost. Default: 500 | Recommended: 400 < x < 1000

    BOOST := 25,  ; If you scroll a long distance in one session, apply additional boost factor. The higher the value, the longer it takes to activate, and the slower it accumulates. Set to 0 to disable completely. Default: 30

    MAX_SCROLLS := 70,  ; Spamming applications with hundreds of individual scroll events can slow them down, so set a max number of scrolls sent per click. Default: 60

    ; Session variables:
    _distance,
    _max_speed

    time_between_hotkeys_ms := A_TimeSincePriorHotkey or 1

    if not (A_ThisHotkey = A_PriorHotkey and time_between_hotkeys_ms < TIMEOUT_MS) {
        ; Combo broken, so reset session variables:
        _distance := 0
        _max_speed := 1

        MouseClick A_ThisHotkey
        return
    }

    _distance++  ; Remember how many times the current direction has been scrolled in.
    speed := (time_between_hotkeys_ms < 100) ? 250.0/time_between_hotkeys_ms - 1 : 1  ; Calculate acceleration factor using a 1/x curve.

    ; Apply boost:
    if BOOST > 1 and _distance > BOOST {
        ; Hold onto the highest speed achieved during this boost:
        if speed > _max_speed
            _max_speed := speed
        else
            speed := _max_speed
        speed *= _distance / BOOST
    }

    speed := (speed > MAX_SCROLLS) ? MAX_SCROLLS : Floor(speed)
    MouseClick A_ThisHotkey, , , speed
}
