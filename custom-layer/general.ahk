#Include ..\lib\classes.ahk

/**
 * I'm using #HotIf instead of Hotkey(K_LAYER_ACTIVATOR ' & ' originKey, fn)
 * because if K_LAYER_ACTIVATOR were a standard modifier key or toggleable key,
 * it would not lose its native function.
 * See https://www.autohotkey.com/docs/v2/Hotkeys.htm#combo
 */

#HotIf GetKeyState(K_LAYER_ACTIVATOR, 'P')
        ; There's a reason why I don't use `Capslock &`
        ; but I can't remember.
        ; Is it so that I can also use the standard modifiers in the hotkey definition?
        ; e.g. +h::
h:: Left
j:: Down
k:: Up
l:: Right

/**
 * How do they manage to activate the ^+PgDn and ^+PgUp VimcCmds
 * if they use SendInput?
 */
u:: PgDn
i:: PgUp

m:: Home
,:: End
n:: Insert
p:: PrintScreen
Backspace:: Delete
]::p

Space:: Backspace

3::
        ; The hotkey is 3
        ; because the 3 key is also for #.
        ; We can think of # as standing for NumLock.
{
    numLockState := GetKeyState('NumLock', 'T')
    SetNumLockState(not numLockState)
    DoOnNumLockToggle()
}

DoOnNumLockToggle() {
    NumLockIndicatorFollowMouse()
    C_InsertInputRightOfCaret.toggle()
}

/**
 * Display ToolTip while NumLock is on.
 */
NumLockIndicatorFollowMouse() {
    Sleep(10)

    if GetKeyState('NumLock', 'T') {
        SetTimer(toolTipNumLock, 10)
    } else {
        SetTimer(toolTipNumLock, 0)
        ToolTip()
    }

    toolTipNumLock() => ToolTip('NumLock On')
}
#HotIf
