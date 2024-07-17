/**
 * This script still gets the modifiers stuck sometimes,
 * but my latest idea for solving it is defining hotkeys with the standard modifiers.
 * e.g. ^h:: ^Left
 * I have no idea if that would work, but it is something to try.
 * Though, I have no interest at the moment of doing so.
 */

/**
 * What I said in commit a1d121c02ec05014f058437f773dccc06cef2999 might be useful:
 * "Keys that send modifiers can get those modifiers stuck
 * if CapsLock is released before they are."
 */

#HotIf GetKeyState(K_LAYER_ACTIVATOR, 'P')
/**
 * I'm using #HotIf instead of Hotkey(K_LAYER_ACTIVATOR ' & ' originKey, fn)
 * (that would be the same, for example, as `CapsLock & h:: Left`)
 * because if K_LAYER_ACTIVATOR were a standard modifier key or toggleable key,
 * it would not lose its native function.
 * See https://www.autohotkey.com/docs/v2/Hotkeys.htm#combo
 */

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
    ToggleNumLock()
    CreateFollowingNumLockIndicator()
}
#HotIf
