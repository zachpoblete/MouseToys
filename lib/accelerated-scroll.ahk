/**
 * Originally by BoffinbraiN.
 * For full details, visit the forum thread:
 * https://autohotkey.com/board/topic/48426-accelerated-scrolling-script
 */

#Include default-settings.ahk

A_MaxHotkeysPerInterval := 140
        ; Default: 120

/**
 * To use effectively, make sure this function is the first line in a hotkey.
 */
AcceleratedScroll() {
    static TIMEOUT_MS := 500,
            ; Length of a scrolling session.
            ; Keep scrolling within this time to accumulate boost.
            ; Default: 500
            ; Recommended: 400 < x < 1000.

    BOOST := 25,
            ; If you scroll a long distance in one session, apply additional boost factor.
            ; The higher the value, the longer it takes to activate,
            ; and the slower it accumulates.
            ; Set to 0 to disable completely.
            ; Default: 30.

    MAX_SCROLLS := 70,
            ; Spamming applications with hundreds of individual scroll events can slow them down,
            ; so set a max number of scrolls sent per click.
            ; Default: 60.

    ; Session variables:
    _distance,
    _maxSpeed

    timeBetweenHotkeysMs := A_TimeSincePriorHotkey or 1

    if not (A_ThisHotkey = A_PriorHotkey and timeBetweenHotkeysMs < TIMEOUT_MS) {
        ; Combo broken, so reset session variables:
        _distance := 0
        _maxSpeed := 1

        MouseClick(A_ThisHotkey)
        return
    }
    _distance++
            ; Remember how many times the current direction has been scrolled in.
    speed := (timeBetweenHotkeysMs < 100)? (250.0 / timeBetweenHotkeysMs) - 1 : 1
            ; Calculate acceleration factor using a 1/x like curve.

    ; Apply boost:
    if BOOST > 1 and _distance > BOOST {
        ; Hold onto the highest speed achieved during this boost:
        if speed > _maxSpeed {
            _maxSpeed := speed
        } else {
            speed := _maxSpeed
        }
        speed *= _distance / BOOST
    }
    speed := (speed > MAX_SCROLLS)? MAX_SCROLLS : Floor(speed)
    MouseClick(A_ThisHotkey, , , speed)
}
