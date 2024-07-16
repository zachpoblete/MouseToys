; I don't need this because my MX Keys Mini has a pause button.

#HotIf GetKeyState('CapsLock', 'T')
Volume_Mute:: vk13
        ; Pause key.
#HotIf

Pause:: OneBtnRemote()
OneBtnRemote() {
    static _quickPressCount := 0

    _quickPressCount++
    if _quickPressCount > 2 {
        return
    } else {
        Send('{Media_Play_Pause}')
    }

    SetTimer(chooseMediaControl, -500)

    chooseMediaControl() {
        switch _quickPressCount {
        case 2: Send('{Media_Next}')
        case 3: Send('{Media_Prev}')
        }

        _quickPressCount := 0
    }
}

