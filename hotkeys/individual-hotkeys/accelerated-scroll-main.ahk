#Include ahk-utils
#Include default-settings.ahk

; Originally by BoffinbraiN. For full details, visit the forum thread:
; https://www.autohotkey.com/board/topic/48426-accelerated-scrolling-script

A_MaxHotkeysPerInterval := 200
        ; I have adjusted this to my laptop touchpad
        ; which sends a lot of mouse events in a short time.

WheelUp::
WheelDown::
{
    AcceleratedScroll()
}

; To use effectively, make sure this function is the first line in a hotkey.
AcceleratedScroll() {
    static TIMEOUT_MS := 500
            ; Length of a scrolling session.
            ; Keep scrolling within this time to accumulate boost.
            ; Recommended: 400 < x < 1000.

    static MIN_BOOST_MOMENTUM := 30
            ; The smaller the value, the faster boost activates and accumulates.
            ; Set to 0 to disable boost completely.
    static BOOST_IS_ENABLED := MIN_BOOST_MOMENTUM > 1

    static MAX_SCROLLS_TO_SEND := 60
            ; Spamming apps with hundreds of individual scroll events can slow them down,
            ; so set a max number of scrolls sent per click.

    static _momentum
    static _highestSpeedAchieved

    timeBetweenHotkeysMs := A_TimeSincePriorHotkey or 1

    isNewSession := (A_ThisHotkey != A_PriorHotkey) or (timeBetweenHotkeysMs > TIMEOUT_MS)
    if isNewSession {
        _momentum := 0
        _highestSpeedAchieved := 1
        scrollsToSend := 1
    } else {
        _momentum++
                ; Remember how many times the current direction has been scrolled in.

        if timeBetweenHotkeysMs < 80 {
            speed := (250.0 / timeBetweenHotkeysMs) - 1
                    ; Calculate acceleration factor using a 1/x like curve.
                    ; The smaller timeBetweenHotkeysMs is, the higher speed is.
        } else {
            speed := 1
        }

        if BOOST_IS_ENABLED and _momentum > MIN_BOOST_MOMENTUM {
            if speed > _highestSpeedAchieved {
                _highestSpeedAchieved := speed
            } else {
                speed := _highestSpeedAchieved
            }

            boost := _momentum / MIN_BOOST_MOMENTUM
            speed *= boost
        }

        if speed > MAX_SCROLLS_TO_SEND {
            scrollsToSend := MAX_SCROLLS_TO_SEND
        } else {
            scrollsToSend := Floor(speed)
        }
    }
    Click(A_ThisHotkey ' ' scrollsToSend)
}
