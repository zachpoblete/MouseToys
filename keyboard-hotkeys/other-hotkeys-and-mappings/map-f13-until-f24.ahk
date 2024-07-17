MapF13UntilF24()
MapF13UntilF24() {
    HotIf((thisHotkey) => GetKeyState('NumLock', 'T'))
    loop 12 {
        if A_Index < 3 {
            num := A_Index + 22
        } else {
            num := A_Index + 10
        }

        Hotkey('*F' (A_Index), remap.bind(num))
    }
    HotIf

    remap(num, thisHotkey) => Send('{Blind}{F' num '}')
}
