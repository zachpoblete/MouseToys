/**
 * Note: The order of some of the following #Include directives is very important.
 * Namely, moving the X1+W hotkeys below the X1+R+W hotkeys would make X1+R+W not work.
 * See https://www.autohotkey.com/boards/viewtopic.php?f=14&t=125819
 */

#Include individual-hotkeys
#Include x1-cycle-windows-in-used-order.ahk
#Include x1-send-delete-or-enter.ahk
#Include x1-close-window.ahk
#Include x1-minimize-or-maximize-window.ahk
#Include x1-restore-and-move-window.ahk
#Include x1-undo-or-redo.ahk
#Include x1-copy-or-paste.ahk
#Include x1-screenshot.ahk
