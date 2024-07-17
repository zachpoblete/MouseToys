; I don't need this because, in Equalizer APO, my gain is set to -30 dB
; which makes a change in volume of 2 already much finer.

#HotIf GetKeyState('CapsLock', 'T')
$Volume_Up::   DisplayAndSetVolume(1)
$Volume_Down:: DisplayAndSetVolume(-1)

DisplayAndSetVolume(variation) {
    newVol := SoundGetVolume() + variation
    newVol := Round(newVol)

    Send('{Blind}{Volume_Up Down}{Volume_Up Up}')
            ; On the surface, this increases the volume by 2,
            ; but what this line is actually for is to display the volume slider (and media overlay).
            ; because SoundSetVolume doesn't do that on its own.
            ; We use {Blind}{Key Up} so that keyboards that send Volume_Up and Volume_Down as artificial keys
            ; don't trick AHK into thinking the hotkey was pressed again,
            ; resulting in an infinite loop
            ; We send Volume_Up instead of Volume_Down
            ; because if Volume_Down were used, then when the volume is at 2,
            ; the volume would briefly mute for a split second if the keyboard sends inputs slow.
    SoundSetVolume(newVol)
            ; Override that normal volume variation/increase of 2
            ; with the actual new volume variation we want.
}
#HotIf
